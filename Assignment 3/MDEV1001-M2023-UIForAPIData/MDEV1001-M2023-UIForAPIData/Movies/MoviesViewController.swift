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
        setupCollectionView()
        setupSearchBar()
        viewModel?.screenDidLoad()
    }
    
    func setupSearchBar() {
        let searchController = UISearchController()
        searchController.searchBar.tintColor = Color.secondaryLabel.shade
        searchController.delegate = self
        navigationItem.searchController = searchController
        viewModel?.listenToSearchQuery(with: searchController.searchBar.rx.text)
    }
    
    func setupCollectionView() {
        MovieCollectionViewCell.register(for: collectionView)
        EmptyCollectionViewCell.register(for: collectionView)
    }
    
}

// MARK: - UISearchControllerDelegate Methods
extension MoviesViewController: UISearchControllerDelegate {
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        viewModel?.cancelSearchButtonTapped()
    }
    
}

// MARK: - UICollectionViewDelegate Methods
extension MoviesViewController: UICollectionViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        viewModel?.didScroll(with: scrollView)
    }
    
}

// MARK: - UICollectionViewDataSource Methods
extension MoviesViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let movies = viewModel?.movies else { return 0 }
        return movies.isEmpty ? 1 : movies.count // Empty cell
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let viewModel = viewModel else { return UICollectionViewCell() }
        if viewModel.movies.isEmpty,
           let cellViewModel = viewModel.getEmptyCellViewModel(at: indexPath) {
            let emptyCell = EmptyCollectionViewCell.dequeCell(
                from: collectionView,
                at: indexPath
            )
            emptyCell.configure(with: cellViewModel)
            return emptyCell
        }
        guard let cellViewModel = viewModel.getMovieCellViewModel(at: indexPath) else { return UICollectionViewCell() }
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
        guard let viewModel = viewModel else { return CGSize() }
        var cellWidth = collectionView.bounds.width - 2 * 20 // Horizontal section inset
        if viewModel.movies.isEmpty {
            guard let cellViewModel = viewModel.getEmptyCellViewModel(at: indexPath) else { return CGSize() }
            var cellHeight = EmptyCollectionViewCell.calculateHeight(
                with: cellViewModel,
                width: cellWidth
            )
            cellHeight = collectionView.bounds.height - cellHeight / 2
            return CGSize(width: cellWidth, height: cellHeight)
        }
        guard let cellViewModel = viewModel.getMovieCellViewModel(at: indexPath) else { return CGSize() }
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
    
    var searchQuery: String? {
        return navigationItem.searchController?.searchBar.text
    }
    
    func startLoading() {
        spinnerView.isHidden = false
        spinnerView.startAnimating()
    }
    
    func stopLoading() {
        spinnerView.stopAnimating()
        spinnerView.isHidden = true
    }
    
    func reloadSections(_ sections: IndexSet) {
        collectionView.performBatchUpdates { [weak self] in
            self?.collectionView.reloadSections(sections)
        }
    }
    
}
