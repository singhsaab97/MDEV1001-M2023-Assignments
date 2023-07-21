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
    static let identifier = Constants.moviesViewController
    
    @IBOutlet private weak var spinnerView: UIActivityIndicatorView!
    @IBOutlet private weak var collectionView: UICollectionView!
   
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
        setupCollectionView()
        viewModel?.screenDidLoad()
    }
    
    func setupSearchBar() {
        let searchController = UISearchController()
        searchController.searchBar.tintColor = Color.secondaryLabel.shade
        searchController.delegate = self
        searchController.searchBar.delegate = self
        navigationItem.searchController = searchController
    }
    
    func setupCollectionView() {
        MovieCollectionViewCell.register(for: collectionView)
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

// MARK: - UICollectionViewDelegate Methods
extension MoviesViewController: UICollectionViewDelegate {
    
}

// MARK: - UICollectionViewDataSource Methods
extension MoviesViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel?.movies.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cellViewModel = viewModel?.getCellViewModel(at: indexPath) else { return UICollectionViewCell() }
        let movieCell = MovieCollectionViewCell.dequeCell(
            from: collectionView,
            at: indexPath
        )
        movieCell.configure(with: cellViewModel)
        return movieCell
    }
    
}

// MARK: - UICollectionViewDataSource Methods
extension MoviesViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let viewModel = viewModel,
              let cellViewModel = viewModel.getCellViewModel(at: indexPath) else { return CGSize() }
        var cellWidth = collectionView.bounds.width - 2 * 20 // Horizontal section inset
        cellWidth = (cellWidth - 20) / CGFloat(viewModel.cellsPerRow) // Minimum line spacing
        let cellHeight = MovieCollectionViewCell.calculateHeight(
            with: cellViewModel,
            width: cellWidth
        )
        return CGSize(width: cellWidth, height: cellHeight)
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
        collectionView.reloadData()
    }
    
}
