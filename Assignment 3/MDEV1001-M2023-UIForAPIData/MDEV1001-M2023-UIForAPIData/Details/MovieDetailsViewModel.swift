//
//  MovieDetailsViewModel.swift
//  MDEV1001-M2023-UIForAPIData
//
//  Created by Abhijit Singh on 21/07/23.
//

import UIKit

protocol MovieDetailsViewModelPresenter: AnyObject {
    func startLoading()
    func stopLoading()
    func reload()
    func updateHeaderView(with scrollView: UIScrollView)
    func dismiss()
}

protocol MovieDetailsViewModelable {
    var sections: [MovieDetailsViewModel.Section] { get }
    var closeImage: UIImage? { get }
    var posterUrl: URL? { get }
    var headerViewHeight: CGFloat { get }
    var movieTitle: String? { get }
    var movieTitleCellViewModel: MovieTitleCellViewModelable? { get }
    var movieStackCellViewModel: MovieStackCellViewModelable? { get }
    var moviePlotCellViewModel: MoviePlotCellViewModelable? { get }
    var presenter: MovieDetailsViewModelPresenter? { get set }
    func screenDidLoad()
    func didScroll(with scrollView: UIScrollView)
    func closeButtonTapped()
}

final class MovieDetailsViewModel: MovieDetailsViewModelable,
                                   Toastable {
    
    enum Section: CaseIterable {
        case title
        case stack
        case plot
    }
    
    private let movieId: String
    
    private var movie: Movie?
        
    weak var presenter: MovieDetailsViewModelPresenter?
    
    init(movieId: String) {
        self.movieId = movieId
    }
    
}

// MARK: - Exposed Helpers
extension MovieDetailsViewModel {
    
    var sections: [Section] {
        return movie == nil ? [] : Section.allCases
    }
    
    var closeImage: UIImage? {
        return UIImage(named: "cross")
    }
    
    var posterUrl: URL? {
        return movie?.posterUrl
    }
    
    var headerViewHeight: CGFloat {
        return Constants.movieHeaderViewHeight
    }
    
    var movieTitle: String? {
        return movie?.title
    }
    
    var movieTitleCellViewModel: MovieTitleCellViewModelable? {
        guard let movie = movie else { return nil }
        return MovieTitleCellViewModel(movie: movie)
    }
    
    var movieStackCellViewModel: MovieStackCellViewModelable? {
        guard let movie = movie else { return nil }
        return MovieStackCellViewModel(movie: movie)
    }
    
    var moviePlotCellViewModel: MoviePlotCellViewModelable? {
        guard let movie = movie else { return nil }
        return MoviePlotCellViewModel(movie: movie)
    }
    
    func screenDidLoad() {
        fetchMovie()
    }
    
    func didScroll(with scrollView: UIScrollView) {
        presenter?.updateHeaderView(with: scrollView)
    }
    
    func closeButtonTapped() {
        presenter?.dismiss()
    }
    
}

// MARK: - Private Helpers
private extension MovieDetailsViewModel {
    
    func fetchMovie() {
        MoviesDataHandler.shared.fetchMovie(with: movieId) { [weak self] state in
            switch state {
            case .loading:
                self?.presenter?.startLoading()
            case let .data(movies):
                self?.presenter?.stopLoading()
                self?.movie = movies.first
                self?.presenter?.reload()
            case let .error(error):
                self?.presenter?.stopLoading()
                self?.showToast(with: error)
            }
        }
    }
    
}
