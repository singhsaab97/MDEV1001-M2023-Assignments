//
//  Constants.swift
//  MDEV1001-M2023-UIForAPIData
//
//  Created by Abhijit Singh on 20/07/23.
//

import Foundation

struct Constants {
    
    static let baseApiUrl = URL(string: "https://www.omdbapi.com")
    static let apiKey = "612b96bd"
    static let commonApiHeaders = ["Content-Type": "application/json"]
    
    static let movies = "Movies"
    static let moviesFileName = "DefaultMovies"
    static let uhOh = "Uh Oh!"
    static let emptyMovies = "There are no movies available for the searched query"
    static let fullPlotParameter = "full"
    static let genre = "Genre"
    static let duration = "Duration"
    static let rating = "Rating"
    static let storyline = "Storyline"
    static let movieCellsPerRow: Int = 2
    static let movieHeaderViewHeight: CGFloat = 300
    static let throttleTime: Int = 500 // Milliseconds
    static let scrollThreshold: CGFloat = 100
    static let animationDuration: TimeInterval = 0.3
    static let toastDisplayDuration: TimeInterval = 3
    
    static let storyboardName = "Main"
    static let moviesViewController = String(describing: MoviesViewController.self)
    static let movieCollectionViewCell = String(describing: MovieCollectionViewCell.self)
    static let emptyCollectionViewCell = String(describing: EmptyCollectionViewCell.self)
    static let movieDetailsViewController = String(describing: MovieDetailsViewController.self)
    static let movieTitleTableViewCell = String(describing: MovieTitleTableViewCell.self)
    static let movieStackTableViewCell = String(describing: MovieStackTableViewCell.self)
    static let moviePlotTableViewCell = String(describing: MoviePlotTableViewCell.self)
    static let toastView = String(describing: ToastView.self)
    
}
