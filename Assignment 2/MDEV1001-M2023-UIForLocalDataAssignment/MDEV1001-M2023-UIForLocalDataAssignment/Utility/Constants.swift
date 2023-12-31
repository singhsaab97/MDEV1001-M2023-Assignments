//
//  Constants.swift
//  MDEV1001-M2023-UIForLocalDataAssignment
//
//  Created by Abhijit Singh on 09/06/23.
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
    static let animationDuration: TimeInterval = 0.3
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
    static let postersListCellName = String(describing: PostersListTableViewCell.self)
    static let postersListCellIdentifier = String(describing: PostersListTableViewCell.self)
    static let posterCellName = String(describing: PosterCollectionViewCell.self)
    static let posterCellIdentifier = String(describing: PosterCollectionViewCell.self)
    static let toastViewName = String(describing: ToastView.self)
    static let toastViewIdentifier = String(describing: ToastView.self)
    
    static let sort = "Sort"
    static let edit = "Edit"
    static let editMovie = "Edit Movie"
    static let addMovie = "Add Movie"
    static let delete = "Delete"
    static let alphabeticallyOption = "Alphabetically"
    static let highestRatingOption = "Highest rating"
    static let lowestRatingOption = "Lowest rating"
    static let latestReleaseOption = "Latest release"
    static let oldestReleaseOption = "Oldest release"
    static let longestRunningTimeOption = "Longest running time"
    static let shortestRunningTimeOption = "Shortest running time"
    static let moviesViewControllerTitle = "Favourite Movies"
    static let titleFieldPlaceholder = "Title"
    static let studioFieldPlaceholder = "Studio"
    static let genresFieldPlaceholder = "Genres"
    static let directorsFieldPlaceholder = "Directors"
    static let writersFieldPlaceholder = "Writers"
    static let yearFieldPlaceholder = "Release year"
    static let lengthFieldPlaceholder = "Running time (minutes)"
    static let mpaRatingFieldPlaceholder = "MPA rating"
    static let criticsRatingFieldPlaceholder = "Critics rating"
    static let descriptionFieldPlaceholder = "Summary"
    static let fieldErrorMessageSubtext = "is required"
    static let cannotDeleteDuringSearchMessage = "Deletion cannot be performed while searching"
    static let cannotEditDuringSearchMessage = "Editing cannot be performed while searching"
    static let movieExistsErrorMessage = "This movie already exists in the database"
    static let deleteAlertMessage = "This action will delete it from the database permanently."
    static let deleteAllAlertTitle = "Delete all movies?"
    static let deleteAllAlertMessage = "This action will delete all the movies from the database permanently."
    static let deleteAlertDeleteTitle = "Delete"
    static let deleteAlertCancelTitle = "Cancel"
    
}
