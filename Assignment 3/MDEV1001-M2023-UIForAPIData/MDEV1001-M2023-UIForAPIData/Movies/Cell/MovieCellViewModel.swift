//
//  MovieCellViewModel.swift
//  MDEV1001-M2023-UIForAPIData
//
//  Created by Abhijit Singh on 20/07/23.
//

import UIKit

protocol MovieCellViewModelable {
    var posterUrl: URL? { get }
    var title: String? { get }
    var typeAndYear: String? { get }
}

final class MovieCellViewModel: MovieCellViewModelable {
    
    private let movie: Movie
    
    init(movie: Movie) {
        self.movie = movie
    }
    
}

// MARK: - Exposed Helpers
extension MovieCellViewModel {
    
    var posterUrl: URL? {
        return movie.posterUrl
    }
    
    var title: String? {
        return movie.title
    }
    
    var typeAndYear: String? {
        guard let type = movie.type?.rawValue.capitalizedInitial,
              let year = movie.year else { return nil }
        return "\(type)  •  \(year)"
    }
   
}
