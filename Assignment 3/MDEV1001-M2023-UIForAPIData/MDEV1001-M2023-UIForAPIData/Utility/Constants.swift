//
//  Constants.swift
//  MDEV1001-M2023-UIForAPIData
//
//  Created by Abhijit Singh on 20/07/23.
//

import Foundation

struct Constants {
    
    static let baseApiUrl = URL(string: "https://www.omdbapi.com")
    static let apiKey = "92300c89"
    static let commonApiHeaders = ["Content-Type": "application/json"]
    
    static let movies = "Movies"
    static let moviesFileName = "DefaultMovies"
    static let uhOh = "Uh Oh!"
    static let emptyMovies = "There are no movies available for the searched query"
    static let movieCellsPerRow: Int = 2
    static let throttleTime: Int = 500 // Milliseconds
    
    static let storyboardName = "Main"
    static let moviesViewController = String(describing: MoviesViewController.self)
    static let movieCollectionViewCell = String(describing: MovieCollectionViewCell.self)
    static let emptyCollectionViewCell = String(describing: EmptyCollectionViewCell.self)
    
}
