//
//  AddEditMovieViewController.swift
//  MDEV1001-M2023-Firebase
//
//  Created by Abhijit Singh on 15/08/23.
//

import UIKit

final class AddEditMovieViewController: UIViewController,
                                        ViewLoadable {
    
    static var name = Constants.storyboardName
    static var identifier = Constants.addEditMovieViewController
    
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var tableViewBottomConstraint: NSLayoutConstraint!
    
    var viewModel: AddEditMovieViewModelable?

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
private extension AddEditMovieViewController {
    
    func setup() {
        navigationItem.largeTitleDisplayMode = .never
        addActionButtons()
        addHeaderView()
        addKeyboardObservers()
        PostersListTableViewCell.register(for: tableView)
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
        guard let imageUrl = viewModel?.headerViewImageUrl else { return }
        let frame = CGRect(
            x: 0,
            y: 0,
            width: view.bounds.width,
            height: Constants.headerViewHeight
        )
        let headerView = StretchyTableHeaderView(frame: frame)
        headerView.setImage(with: imageUrl, isAnimated: false)
        tableView.tableHeaderView = headerView
    }
    
    func addKeyboardObservers() {
        NotificationCenter.default.addObserver(
            forName: UIResponder.keyboardWillShowNotification,
            object: nil,
            queue: nil
        ) { [weak self] notification in
            self?.keyboardWillShow(notification)
        }
        NotificationCenter.default.addObserver(
            forName: UIResponder.keyboardWillHideNotification,
            object: nil,
            queue: nil
        ) { [weak self] _ in
            self?.keyboardWillHide()
        }
    }
    
    func keyboardWillShow(_ notification: Notification) {
        guard let frame = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
        viewModel?.keyboardWillShow(with: frame)
    }
    
    func keyboardWillHide() {
        viewModel?.keyboardWillHide()
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
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel?.sections.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.getNumberOfFields(in: section) ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let section = viewModel?.sections[safe: indexPath.section] else { return UITableViewCell() }
        switch section {
        case .posters:
            guard let viewModel = viewModel?.getCellViewModel(at: indexPath) as? PostersListCellViewModel else { return UITableViewCell() }
            let listCell = PostersListTableViewCell.dequeReusableCell(
                from: tableView,
                at: indexPath
            )
            listCell.configure(with: viewModel, height: 0.18 * view.bounds.width)
            viewModel.presenter = listCell
            return listCell
        case .fields:
            guard let viewModel = viewModel?.getCellViewModel(at: indexPath) as? AddEditMovieCellViewModel else { return UITableViewCell() }
            let addEditMovieCell = AddEditMovieTableViewCell.dequeReusableCell(
                from: tableView,
                at: indexPath
            )
            addEditMovieCell.configure(with: viewModel)
            return addEditMovieCell
        }
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
    
    func updateHeaderView(with imageUrl: URL?) {
        guard let headerView = tableView.tableHeaderView as? StretchyTableHeaderView else { return }
        headerView.setImage(with: imageUrl, isAnimated: true)
    }
    
    func showKeyboard(with height: CGFloat, duration: TimeInterval) {
        tableViewBottomConstraint.constant = height
        UIView.animate(withDuration: duration) { [weak self] in
            self?.view?.layoutIfNeeded()
        }
    }
    
    func hideKeyboard(with duration: TimeInterval) {
        tableViewBottomConstraint.constant = .zero
        UIView.animate(withDuration: duration) { [weak self] in
            self?.view?.layoutIfNeeded()
        }
    }
    
    func pop(completion: (() -> Void)?) {
        popViewController(completion: completion)
    }
    
}
