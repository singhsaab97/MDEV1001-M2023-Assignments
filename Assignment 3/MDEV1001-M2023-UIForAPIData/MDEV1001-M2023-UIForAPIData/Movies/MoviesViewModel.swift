//
//  MoviesViewModel.swift
//  MDEV1001-M2023-UIForAPIData
//
//  Created by Abhijit Singh on 20/07/23.
//

import Foundation

protocol MoviesViewModelPresenter: AnyObject {
    func startLoading()
    func stopLoading()
    func reload()
}

protocol MoviesViewModelable {
    var title: String { get }
    var movies: [Movie] { get }
    var presenter: MoviesViewModelPresenter? { get set }
    func screenDidLoad()
    func getCellViewModel(at indexPath: IndexPath) -> MovieCellViewModelable?
}

final class MoviesViewModel: MoviesViewModelable {
    
    private(set) var movies: [Movie]
    
    weak var presenter: MoviesViewModelPresenter?
    
    init() {
        self.movies = []
    }
    
}

// MARK: - Exposed Helpers
extension MoviesViewModel {
    
    var title: String {
        return Constants.movies
    }
    
    func screenDidLoad() {
        fetchMovies()
    }
    
    func getCellViewModel(at indexPath: IndexPath) -> MovieCellViewModelable? {
        guard let movie = movies[safe: indexPath.row] else { return nil }
        return MovieCellViewModel(movie: movie)
    }
    
}

// MARK: - Private Helpers
private extension MoviesViewModel {
    
    func fetchMovies() {
        MoviesDataHandler.shared.fetchMoviesList { [weak self] state in
            switch state {
            case .loading:
                self?.presenter?.startLoading()
            case let .data(movies):
                self?.presenter?.stopLoading()
                self?.movies = movies
                self?.presenter?.reload()
            case let .error(error):
                self?.presenter?.stopLoading()
                // TODO
            }
        }
    }
    
}
