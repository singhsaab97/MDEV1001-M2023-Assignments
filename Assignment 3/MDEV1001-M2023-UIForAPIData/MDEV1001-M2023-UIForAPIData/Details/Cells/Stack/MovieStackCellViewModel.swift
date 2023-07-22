//
//  MovieStackCellViewModel.swift
//  MDEV1001-M2023-UIForAPIData
//
//  Created by Abhijit Singh on 21/07/23.
//

import UIKit

protocol MovieStackCellViewModelable {
    var genreImage: UIImage? { get }
    var genreTitle: String { get }
    var movieGenre: String? { get }
    var durationImage: UIImage? { get }
    var durationTitle: String { get }
    var movieDuration: String? { get }
    var ratingImage: UIImage? { get }
    var ratingTitle: String { get }
    var movieRating: String? { get }
}

final class MovieStackCellViewModel: MovieStackCellViewModelable {
    
    private let movie: Movie
    
    init(movie: Movie) {
        self.movie = movie
    }
    
}

// MARK: - Exposed Helpers
extension MovieStackCellViewModel {
    
    var genreImage: UIImage? {
        return UIImage(named: "camera")
    }
    
    var genreTitle: String {
        return Constants.genre
    }
    
    var movieGenre: String? {
        return movie.genre?.components(separatedBy: ", ").first
    }
    
    var durationImage: UIImage? {
        return UIImage(named: "clock")
    }
    
    var durationTitle: String {
        return Constants.duration
    }
    
    var movieDuration: String? {
        return movie.duration
    }
    
    var ratingImage: UIImage? {
        return UIImage(named: "star")
    }
    
    var ratingTitle: String {
        return Constants.rating
    }
    
    var movieRating: String? {
        guard let rating = movie.rating else { return nil }
        return "\(rating) / 10"
    }
    
}
