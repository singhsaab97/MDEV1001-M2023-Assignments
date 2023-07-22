//
//  MoviesViewModel.swift
//  MDEV1001-M2023-UIForAPIData
//
//  Created by Abhijit Singh on 20/07/23.
//

import UIKit
import RxSwift
import RxCocoa

protocol MoviesViewModelPresenter: AnyObject {
    var searchQuery: String? { get }
    func startLoading()
    func stopLoading()
    func reloadSections(_ sections: IndexSet)
    func present(_ viewController: UIViewController)
}

protocol MoviesViewModelable {
    var title: String { get }
    var movies: [Movie] { get }
    var cellsPerRow: Int { get }
    var presenter: MoviesViewModelPresenter? { get set }
    func screenDidLoad()
    func getMovieCellViewModel(at indexPath: IndexPath) -> MovieCellViewModelable?
    func getEmptyCellViewModel(at indexPath: IndexPath) -> EmptyCellViewModelable?
    func didScroll(with scrollView: UIScrollView)
    func didSelectCell(at indexPath: IndexPath)
    func listenToSearchQuery(with searchText: ControlProperty<String?>)
    func cancelSearchButtonTapped()
}

final class MoviesViewModel: MoviesViewModelable,
                             Toastable {
    
    private var displayMovies: [Movie]
    private var searchedMovies: [Movie]
    private var isSearching: Bool
    private var isFetching: Bool
    private var currentPage: Int
    
    private let disposeBag: DisposeBag
    
    weak var presenter: MoviesViewModelPresenter?
    
    init() {
        self.displayMovies = []
        self.searchedMovies = []
        self.isSearching = false
        self.isFetching = false
        self.currentPage = 1
        self.disposeBag = DisposeBag()
    }
    
}

// MARK: - Exposed Helpers
extension MoviesViewModel {
    
    var title: String {
        return Constants.movies
    }
    
    var movies: [Movie] {
        return isSearching ? searchedMovies : displayMovies
    }
    
    var cellsPerRow: Int {
        return Constants.movieCellsPerRow
    }
    
    func screenDidLoad() {
        fetchMovies()
    }
    
    func getMovieCellViewModel(at indexPath: IndexPath) -> MovieCellViewModelable? {
        guard let movie = movies[safe: indexPath.item] else { return nil }
        return MovieCellViewModel(movie: movie)
    }
    
    func getEmptyCellViewModel(at indexPath: IndexPath) -> EmptyCellViewModelable? {
        guard let query = presenter?.searchQuery else { return nil }
        return EmptyCellViewModel(searchQuery: query)
    }
    
    func didScroll(with scrollView: UIScrollView) {
        let scrollViewHeight = scrollView.frame.size.height
        let scrollContentSizeHeight = scrollView.contentSize.height
        let scrollOffset = scrollView.contentOffset.y
        // Check if the user is close to the bottom of the content
        guard !isFetching,
              isSearching,
              searchedMovies.count < MoviesDataHandler.shared.totalMovies,
              scrollOffset + scrollViewHeight >= scrollContentSizeHeight - Constants.scrollThreshold else { return }
        currentPage += 1
        fetchMovies(for: currentPage)
    }
    
    func didSelectCell(at indexPath: IndexPath) {
        guard let movie = movies[safe: indexPath.item],
              let movieId = movie.id else { return }
        let viewModel = MovieDetailsViewModel(movieId: movieId)
        let viewController = MovieDetailsViewController.loadFromStoryboard()
        viewController.viewModel = viewModel
        viewModel.presenter = viewController
        viewController.modalPresentationStyle = .fullScreen
        presenter?.present(viewController)
    }
    
    func listenToSearchQuery(with searchText: ControlProperty<String?>) {
        searchText
        .throttle(
            .milliseconds(Constants.throttleTime),
            scheduler: MainScheduler.instance
        )
        .subscribe(onNext: { [weak self] query in
            guard let self = self else { return }
            self.resetSearchedMovies()
            self.fetchMovies(for: self.currentPage)
        })
        .disposed(by: disposeBag)
    }
    
    func cancelSearchButtonTapped() {
        resetSearchedMovies()
    }
    
}

// MARK: - Private Helpers
private extension MoviesViewModel {
    
    func fetchMovies() {
        MoviesDataHandler.shared.fetchMoviesList { [weak self] state in
            self?.handleResultState(state)
        }
    }
    
    func fetchMovies(for page: Int) {
        guard let query = presenter?.searchQuery,
              !query.trimmingCharacters(in: .whitespaces).isEmpty else {
            resetSearchedMovies()
            return
        }
        isSearching = true
        isFetching = true
        MoviesDataHandler.shared.fetchMovieSearchResults(for: query, page: page) { [weak self] state in
            self?.handleResultState(state)
        }
    }
    
    func handleResultState(_ state: MoviesResultState) {
        switch state {
        case .loading:
            presenter?.startLoading()
        case let .data(movies):
            presenter?.stopLoading()
            if isSearching {
                searchedMovies.append(contentsOf: movies)
            } else {
                displayMovies = movies
            }
            isFetching = false
            reload()
        case let .error(error):
            presenter?.stopLoading()
            isFetching = false
            showToast(with: error)
        }
    }
    
    func resetSearchedMovies() {
        isSearching = false
        isFetching = false
        currentPage = 1
        searchedMovies.removeAll()
        reload()
    }
    
    func reload() {
        presenter?.reloadSections(IndexSet(integer: 0))
    }
    
}
