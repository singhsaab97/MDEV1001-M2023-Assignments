//
//  MoviesViewController.swift
//  MDEV1001-M2023-UIForLocalDataAssignment
//
//  Created by Abhijit Singh on 08/06/23.
//  Copyright © 2023 Abhijit Singh. All rights reserved.
//

import UIKit

final class MoviesViewController: UIViewController,
                                  ViewLoadable {
    
    static var name = Constants.storyboardName
    static var identifier = Constants.moviesViewControllerIdentifier
    
    @IBOutlet private weak var tableView: UITableView!
    
    var viewModel: MoviesViewModelable?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel?.presenter = self
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel?.screenWillAppear()
    }
    
}

// MARK: - Private Helpers
private extension MoviesViewController {
    
    func setup() {
        addActionButtons()
        MovieTableViewCell.register(for: tableView)
        viewModel?.screenLoaded()
    }
    
    func addActionButtons() {
        // Sort button
        let sortButton = UIBarButtonItem(
            title: viewModel?.sortButtonTitle,
            style: .plain,
            target: self,
            action: nil
        )
        sortButton.menu = viewModel?.sortContextMenu
        navigationItem.leftBarButtonItem = sortButton
        // Add button
        let addButton = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(addButtonTapped)
        )
        // Delete all button
        let deleteAllButton = UIBarButtonItem(
            barButtonSystemItem: .trash,
            target: self,
            action: #selector(deleteAllButtonTapped)
        )
        navigationItem.rightBarButtonItems = [addButton, deleteAllButton]
    }
    
    @objc
    func addButtonTapped() {
        viewModel?.addButtonTapped()
    }
    
    @objc
    func deleteAllButtonTapped() {
        viewModel?.deleteAllButtonTapped()
    }

}

// MARK: - UITableViewDelegate Methods
extension MoviesViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        viewModel?.didSelectMovie(at: indexPath)
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        guard let action = viewModel?.leadingSwipedMovie(at: indexPath) else { return nil }
        action.backgroundColor = .systemBlue
        return UISwipeActionsConfiguration(actions: [action])
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        return viewModel?.trailingSwipedMovie(at: indexPath)
    }
    
}

// MARK: - UITableViewDataSource Methods
extension MoviesViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.numberOfMovies ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let viewModel = viewModel?.getCellViewModel(at: indexPath) else { return UITableViewCell() }
        let movieCell = MovieTableViewCell.dequeReusableCell(from: tableView, at: indexPath)
        movieCell.configure(with: viewModel)
        return movieCell
    }
    
}

// MARK: - MoviesPresenter Methods
extension MoviesViewController: MoviesPresenter {
    
    func setNavigationTitle(_ title: String) {
        navigationItem.title = title
    }
    
    func reloadData() {
        tableView.reloadData()
    }
    
    func reloadRows(at indexPaths: [IndexPath]) {
        tableView.reloadRows(at: indexPaths, with: .automatic)
    }
    
    func insertRows(at indexPaths: [IndexPath]) {
        tableView.beginUpdates()
        tableView.insertRows(at: indexPaths, with: .left)
        tableView.endUpdates()
    }
    
    func deleteRows(at indexPaths: [IndexPath]) {
        tableView.beginUpdates()
        tableView.deleteRows(at: indexPaths, with: .right)
        tableView.endUpdates()
    }
    
    func scroll(to indexPath: IndexPath) {
        tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
    }
    
    func present(_ viewController: UIViewController) {
        navigationController?.present(viewController, animated: true)
    }
    
    func push(_ viewController: UIViewController) {
        navigationController?.pushViewController(viewController, animated: true)
    }
    
}
