//
//  MoviesViewController.swift
//  MDEV1001-M2023-Firebase
//
//  Created by Abhijit Singh on 14/08/23.
//

import UIKit

final class MoviesViewController: UIViewController,
                                  ViewLoadable {
    
    static let name = Constants.storyboardName
    static let identifier = Constants.moviesViewController

    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var spinnerView: UIActivityIndicatorView!
    
    private lazy var themeButton: UIBarButtonItem = {
        return UIBarButtonItem(
            image: viewModel?.userInterfaceStyle.image,
            style: .plain,
            target: self,
            action: #selector(themeButtonTapped)
        )
    }()
    
    var viewModel: MoviesViewModelable?
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        // Logout button
        let logoutButton = UIBarButtonItem(
            image: viewModel?.logoutButtonImage,
            style: .plain,
            target: self,
            action: #selector(logoutButtonTapped)
        )
        navigationItem.leftBarButtonItems = [logoutButton, themeButton]
        // Add button
        let addButton = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(addButtonTapped)
        )
        navigationItem.rightBarButtonItem = addButton
    }
    
    @objc
    func logoutButtonTapped() {
        viewModel?.logoutButtonTapped()
    }
    
    @objc
    func themeButtonTapped() {
        viewModel?.themeButtonTapped()
    }
    
    @objc
    func addButtonTapped() {
        viewModel?.addButtonTapped()
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
    
    func setThemeButton(with image: UIImage?) {
        themeButton.image = image
    }
    
    func startLoading() {
        spinnerView.isHidden = false
        spinnerView.startAnimating()
    }
    
    func stopLoading() {
        spinnerView.stopAnimating()
        spinnerView.isHidden = true
    }
    
    func reloadSections(_ indexSet: IndexSet) {
        tableView.reloadSections(indexSet, with: .fade)
    }
    
    func reloadRows(at indexPaths: [IndexPath]) {
        tableView.reloadRows(at: indexPaths, with: .fade)
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
    
    func dismiss() {
        navigationController?.dismiss(animated: true)
    }
    
}
