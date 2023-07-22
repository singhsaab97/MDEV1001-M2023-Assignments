//
//  MovieDetailsViewController.swift
//  MDEV1001-M2023-UIForAPIData
//
//  Created by Abhijit Singh on 21/07/23.
//

import UIKit

final class MovieDetailsViewController: UIViewController,
                                        ViewLoadable {
    
    static let name = Constants.storyboardName
    static let identifier = Constants.movieDetailsViewController
    
    @IBOutlet private weak var spinnerView: UIActivityIndicatorView!
    @IBOutlet private weak var closeButton: UIButton!
    @IBOutlet private weak var tableView: UITableView!
    
    var viewModel: MovieDetailsViewModelable?

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
}

// MARK: - Private Helpers
private extension MovieDetailsViewController {
    
    func setup() {
        setupCloseButton()
        setupTableView()
        viewModel?.screenDidLoad()
    }
    
    func setupCloseButton() {
        closeButton.backgroundColor = Color.background.shade
        closeButton.tintColor = Color.label.shade
        closeButton.setImage(viewModel?.closeImage, for: .normal)
        closeButton.layer.cornerRadius = min(
            closeButton.bounds.width,
            closeButton.bounds.height
        ) / 2
    }
    
    func setupTableView() {
        MovieTitleTableViewCell.register(for: tableView)
        MovieStackTableViewCell.register(for: tableView)
        MoviePlotTableViewCell.register(for: tableView)
    }
    
    func setupHeaderView() {
        guard let viewModel = viewModel else { return }
        let frame = CGRect(
            x: 0,
            y: 0,
            width: view.bounds.width,
            height: viewModel.headerViewHeight
        )
        let headerView = MovieDetailsHeaderView(frame: frame)
        headerView.setImage(with: viewModel.posterUrl)
        tableView.tableHeaderView = headerView
    }
    
    @IBAction func closeButtonTapped() {
        viewModel?.closeButtonTapped()
    }
    
}

// MARK: - UITableViewDelegate Methods
extension MovieDetailsViewController: UITableViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        viewModel?.didScroll(with: scrollView)
    }
    
}

// MARK: - UITableViewDataSource Methods
extension MovieDetailsViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel?.sections.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let section = viewModel?.sections[safe: indexPath.section] else { return UITableViewCell() }
        switch section {
        case .title:
            guard let cellViewModel = viewModel?.movieTitleCellViewModel else { return UITableViewCell() }
            let titleCell = MovieTitleTableViewCell.dequeCell(from: tableView, at: indexPath)
            titleCell.configure(with: cellViewModel)
            return titleCell
        case .stack:
            guard let cellViewModel = viewModel?.movieStackCellViewModel else { return UITableViewCell() }
            let stackCell = MovieStackTableViewCell.dequeCell(from: tableView, at: indexPath)
            stackCell.configure(with: cellViewModel)
            return stackCell
        case .plot:
            guard let cellViewModel = viewModel?.moviePlotCellViewModel else { return UITableViewCell() }
            let plotCell = MoviePlotTableViewCell.dequeCell(from: tableView, at: indexPath)
            plotCell.configure(with: cellViewModel)
            return plotCell
        }
    }
    
}

// MARK: - MovieDetailsViewModelPresenter Methods
extension MovieDetailsViewController: MovieDetailsViewModelPresenter {
    
    func startLoading() {
        spinnerView.isHidden = false
        spinnerView.startAnimating()
    }
    
    func stopLoading() {
        spinnerView.stopAnimating()
        spinnerView.isHidden = true
    }
    
    func reload() {
        setupHeaderView()
        tableView.reloadData()
    }
    
    func updateHeaderView(with scrollView: UIScrollView) {
        guard let headerView = tableView.tableHeaderView as? MovieDetailsHeaderView else { return }
        headerView.scrollViewDidScroll(scrollView)
    }
    
    func dismiss() {
        dismiss(animated: true)
    }
    
}
