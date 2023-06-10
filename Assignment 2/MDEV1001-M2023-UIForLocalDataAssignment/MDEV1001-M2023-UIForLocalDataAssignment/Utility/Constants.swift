//
//  Constants.swift
//  MDEV1001-M2023-UIForLocalDataAssignment
//
//  Created by Abhijit Singh on 08/06/23.
//  Copyright © 2023 Abhijit Singh. All rights reserved.
//

import UIKit

struct Constants {
    
    static let goodRating: Double = 9
    static let okayRating: Double = 8
    static let mehRating: Double = 7
    static let badRating: Double = 6
    static let headerViewHeight: CGFloat = 250
    static let placeholderFont = UIFont(name: "Helvetica Neue", size: 16)!
    static let toastAnimationDuration: TimeInterval = 0.3
    static let toastDisplayDuration: TimeInterval = 3
    
    static let suiteName = Bundle.main.infoDictionary!["CFBundleName"] as! String
    static let dbModelName = "Movie"
    static let jsonFileName = "Movies"
    static let storyboardName = "Main"
    static let moviesViewControllerIdentifier = String(describing: MoviesViewController.self)
    static let addEditMovieViewControllerIdentifier = String(describing: AddEditMovieViewController.self)
    static let movieCellName = String(describing: MovieTableViewCell.self)
    static let movieCellIdentifier = String(describing: MovieTableViewCell.self)
    static let addEditMovieCellName = String(describing: AddEditMovieTableViewCell.self)
    static let addEditMovieCellIdentifier = String(describing: AddEditMovieTableViewCell.self)
    static let toastViewName = String(describing: ToastView.self)
    static let toastViewIdentifier = String(describing: ToastView.self)
    
    static let sort = "Sort"
    static let edit = "Edit"
    static let editMovie = "Edit Movie"
    static let addMovie = "Add Movie"
    static let delete = "Delete"
    static let highestRatingOption = "Highest Rating"
    static let lowestRatingOption = "Lowest Rating"
    static let alphabeticallyOption = "Alphabetically"
    static let moviesViewControllerTitle = "Favourite Movies"
    static let titleFieldPlaceholder = "Title"
    static let studioFieldPlaceholder = "Studio"
    static let genresFieldPlaceholder = "Genres"
    static let directorsFieldPlaceholder = "Directors"
    static let writersFieldPlaceholder = "Writers"
    static let yearFieldPlaceholder = "Release year"
    static let lengthFieldPlaceholder = "Runtime (minutes)"
    static let mpaRatingFieldPlaceholder = "MPA rating"
    static let criticsRatingFieldPlaceholder = "Critics rating"
    static let descriptionFieldPlaceholder = "Summary"
    static let fieldErrorMessageSubtext = "is required"
    static let movieExistsErrorMessage = "This movie already exists in the database"
    
}
