//
//  MovieCellViewModel.swift
//  MDEV1001-M2023-UIForAPIData
//
//  Created by Abhijit Singh on 20/07/23.
//

import UIKit

protocol MovieCellViewModelable {
    var movie: Movie { get }
    var ratingImage: UIImage? { get }
    var durationImage: UIImage? { get }
}

final class MovieCellViewModel: MovieCellViewModelable {
    
    let movie: Movie
    
    init(movie: Movie) {
        self.movie = movie
    }
    
}

// MARK: - Exposed Helpers
extension MovieCellViewModel {
    
    var ratingImage: UIImage? {
        return UIImage(named: "star")
    }
    
    var durationImage: UIImage? {
        return UIImage(named: "clock")
    }
   
}
