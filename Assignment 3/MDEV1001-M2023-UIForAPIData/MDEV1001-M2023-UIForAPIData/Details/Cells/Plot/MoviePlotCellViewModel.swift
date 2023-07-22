//
//  MoviePlotCellViewModel.swift
//  MDEV1001-M2023-UIForAPIData
//
//  Created by Abhijit Singh on 21/07/23.
//

import Foundation

protocol MoviePlotCellViewModelable {
    var title: String { get }
    var moviePlot: String? { get }
}

final class MoviePlotCellViewModel: MoviePlotCellViewModelable {
    
    private let movie: Movie
    
    init(movie: Movie) {
        self.movie = movie
    }
    
}

// MARK: - Exposed Helpers
extension MoviePlotCellViewModel {
    
    var title: String {
        return Constants.storyline
    }
    
    var moviePlot: String? {
        return movie.summary
    }
    
}
