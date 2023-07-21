//
//  MoviesViewModel.swift
//  MDEV1001-M2023-UIForAPIData
//
//  Created by Abhijit Singh on 20/07/23.
//

import Foundation
import RxSwift
import RxCocoa

protocol MoviesViewModelPresenter: AnyObject {
    func startLoading()
    func stopLoading()
    func reloadSections(_ sections: IndexSet)
}

protocol MoviesViewModelable {
    var title: String { get }
    var movies: [Movie] { get }
    var cellsPerRow: Int { get }
    var presenter: MoviesViewModelPresenter? { get set }
    func screenDidLoad()
    func getMovieCellViewModel(at indexPath: IndexPath) -> MovieCellViewModelable?
    func getEmptyCellViewModel(at indexPath: IndexPath, with searchText: String?) -> EmptyCellViewModelable?
    func listenToSearchQuery(with searchText: ControlProperty<String?>)
    func cancelSearchButtonTapped()
}

final class MoviesViewModel: MoviesViewModelable {
    
    private var displayMovies: [Movie]
    private var searchedMovies: [Movie]
    private var isSearching: Bool
    
    private let disposeBag: DisposeBag
    
    weak var presenter: MoviesViewModelPresenter?
    
    init() {
        self.displayMovies = []
        self.searchedMovies = []
        self.isSearching = false
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
    
    func getEmptyCellViewModel(at indexPath: IndexPath, with searchText: String?) -> EmptyCellViewModelable? {
        guard let searchText = searchText else { return nil }
        return EmptyCellViewModel(searchQuery: searchText)
    }
    
    func listenToSearchQuery(with searchText: ControlProperty<String?>) {
        searchText
        .throttle(
            .milliseconds(Constants.throttleTime),
            scheduler: MainScheduler.instance
        )
        .distinctUntilChanged() // Only emit distinct consecutive elements
        .subscribe(onNext: { [weak self] query in
            self?.fetchMovies(for: query)
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
    
    func fetchMovies(for query: String?) {
        guard let query = query,
              !query.trimmingCharacters(in: .whitespaces).isEmpty else {
            resetSearchedMovies()
            return
        }
        isSearching = true
        searchedMovies.removeAll()
        reload()
        MoviesDataHandler.shared.fetchMovieSearchResults(for: query) { [weak self] state in
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
                searchedMovies = movies
            } else {
                displayMovies = movies
            }
            reload()
        case let .error(error):
            presenter?.stopLoading()
            // TODO
        }
    }
    
    func resetSearchedMovies() {
        isSearching = false
        searchedMovies.removeAll()
        reload()
    }
    
    func reload() {
        presenter?.reloadSections(IndexSet(integer: 0))
    }
    
}
