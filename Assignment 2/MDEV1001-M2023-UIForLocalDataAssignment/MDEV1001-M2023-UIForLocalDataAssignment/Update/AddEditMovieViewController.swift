//
//  AddEditMovieViewController.swift
//  MDEV1001-M2023-UIForLocalDataAssignment
//
//  Created by Abhijit Singh on 09/06/23.
//  Copyright © 2023 Abhijit Singh. All rights reserved.
//

import UIKit

final class AddEditMovieViewController: UIViewController,
                                        ViewLoadable {
    
    static var name = Constants.storyboardName
    static var identifier = Constants.addEditMovieViewControllerIdentifier
    
    @IBOutlet private weak var tableView: UITableView!
    
    var viewModel: AddEditMovieViewModelable?

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
private extension AddEditMovieViewController {
    
    func setup() {
        navigationItem.largeTitleDisplayMode = .never
        addActionButtons()
        addHeaderView()
        AddEditMovieTableViewCell.register(for: tableView)
    }
    
    func addActionButtons() {
        // Cancel button
        let cancelButton = UIBarButtonItem(
            barButtonSystemItem: .cancel,
            target: self,
            action: #selector(cancelButtonTapped)
        )
        navigationItem.leftBarButtonItem = cancelButton
        // Done button
        let doneButton = UIBarButtonItem(
            barButtonSystemItem: .done,
            target: self,
            action: #selector(doneButtonTapped)
        )
        navigationItem.rightBarButtonItem = doneButton
    }
    
    func addHeaderView() {
        guard let image = viewModel?.headerViewImage else { return }
        let frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: Constants.headerViewHeight)
        let headerView = StretchyTableHeaderView(frame: frame)
        headerView.setImage(image)
        tableView.tableHeaderView = headerView
    }
    
    @objc
    func cancelButtonTapped() {
        viewModel?.cancelButtonTapped()
    }
    
    @objc
    func doneButtonTapped() {
        viewModel?.doneButtonTapped()
    }
    
}

// MARK: - UITableViewDelegate Methods
extension AddEditMovieViewController: UITableViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        viewModel?.didScroll(with: scrollView)
    }
    
}

// MARK: - UITableViewDataSource Methods
extension AddEditMovieViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.numberOfFields ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let viewModel = viewModel?.getCellViewModel(at: indexPath) else { return UITableViewCell() }
        let addEditMovieCell = AddEditMovieTableViewCell.dequeReusableCell(from: tableView, at: indexPath)
        addEditMovieCell.configure(with: viewModel)
        return addEditMovieCell
    }
    
}

// MARK: - AddEditMoviePresenter Methods
extension AddEditMovieViewController: AddEditMoviePresenter {
    
    func setNavigationTitle(_ title: String) {
        navigationItem.title = title
    }
    
    func updateHeaderView(with scrollView: UIScrollView) {
        guard let headerView = tableView.tableHeaderView as? StretchyTableHeaderView else { return }
        headerView.scrollViewDidScroll(scrollView)
    }
    
    func pop(completion: (() -> Void)?) {
        popViewController(completion: completion)
    }
    
}
