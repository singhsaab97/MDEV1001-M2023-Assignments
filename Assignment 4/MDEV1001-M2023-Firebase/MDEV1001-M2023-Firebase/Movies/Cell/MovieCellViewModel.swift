//
//  MovieCellViewModel.swift
//  MDEV1001-M2023-Firebase
//
//  Created by Abhijit Singh on 14/08/23.
//

import Foundation

protocol MovieCellViewModelable {
    var movie: Movie { get }
    var state: MovieCellViewModel.RatingState { get }
}

final class MovieCellViewModel: MovieCellViewModelable {
    
    /// Determines the background color of movie rating
    enum RatingState {
        case good
        case okay
        case meh
        case bad
        case unknown
    }
    
    let movie: Movie
    
    private(set) var state: RatingState
    
    init(movie: Movie) {
        self.movie = movie
        self.state = .unknown
        setRatingState()
    }
    
}

// MARK: - Private Helpers
private extension MovieCellViewModel {
    
    func setRatingState() {
        if movie.criticsRating >= Constants.goodRating {
            state = .good
        } else if movie.criticsRating >= Constants.okayRating {
            state = .okay
        } else if movie.criticsRating >= Constants.mehRating {
            state = .meh
        } else {
            state = .bad
        }
    }
    
}
