//
//  MoviesViewController.swift
//  MDEV1001-M2023-UIForAPIData
//
//  Created by Abhijit Singh on 20/07/23.
//

import UIKit

final class MoviesViewController: UIViewController,
                                  ViewLoadable {
    
    static let name = Constants.storyboardName
    static let identifier = Constants.moviesViewControllerIdentifier
    
    @IBOutlet private weak var spinnerView: UIActivityIndicatorView!
    @IBOutlet private weak var tableView: UITableView!
   
    var viewModel: MoviesViewModelable?

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }

}

// MARK: - Private Helpers
private extension MoviesViewController {
    
    func setup() {
        navigationItem.title = viewModel?.title
        setupSearchBar()
        setupTableView()
        viewModel?.screenDidLoad()
    }
    
    func setupSearchBar() {
        let searchController = UISearchController()
        searchController.searchBar.tintColor = Color.secondaryLabel.shade
        searchController.delegate = self
        searchController.searchBar.delegate = self
        navigationItem.searchController = searchController
    }
    
    func setupTableView() {
        MovieTableViewCell.register(for: tableView)
    }
    
}

// MARK: - UISearchControllerDelegate Methods
extension MoviesViewController: UISearchControllerDelegate {
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
//        viewModel?.cancelSearchButtonTapped()
    }
    
}

// MARK: - UISearchBarDelegate Methods
extension MoviesViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//        viewModel?.didTypeSearchText(searchText)
    }
    
}

// MARK: - UITableViewDelegate Methods
extension MoviesViewController: UITableViewDelegate {
    
}

// MARK: - UITableViewDataSource Methods
extension MoviesViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.movies.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cellViewModel = viewModel?.getCellViewModel(at: indexPath) else { return UITableViewCell() }
        let movieCell = MovieTableViewCell.dequeCell(from: tableView, at: indexPath)
        movieCell.configure(with: cellViewModel)
        return movieCell
    }
    
}

// MARK: - MoviesViewModelPresenter Methods
extension MoviesViewController: MoviesViewModelPresenter {
    
    func startLoading() {
        spinnerView.isHidden = false
        spinnerView.startAnimating()
    }
    
    func stopLoading() {
        spinnerView.stopAnimating()
        spinnerView.isHidden = true
    }
    
    func reload() {
        tableView.reloadData()
    }
    
}
