//
//  MovieTitleCellViewModel.swift
//  MDEV1001-M2023-UIForAPIData
//
//  Created by Abhijit Singh on 21/07/23.
//

import Foundation

protocol MovieTitleCellViewModelable {
    var title: String? { get }
    var releaseDate: String? { get }
}

final class MovieTitleCellViewModel: MovieTitleCellViewModelable {
    
    private let movie: Movie
    
    init(movie: Movie) {
        self.movie = movie
    }
    
}

// MARK: - Exposed Helpers
extension MovieTitleCellViewModel {
    
    var title: String? {
        return movie.title
    }
    
    var releaseDate: String? {
        return movie.released
    }
    
}
