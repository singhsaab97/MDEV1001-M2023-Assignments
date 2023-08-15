//
//  Constants.swift
//  MDEV1001-M2023-Firebase
//
//  Created by Abhijit Singh on 14/08/23.
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
    static let moviesCollectionName = "Movies"
    static let storyboardName = "Main"
    static let moviesViewController = String(describing: MoviesViewController.self)
    static let movieCell = String(describing: MovieTableViewCell.self)
    static let addEditMovieViewController = String(describing: AddEditMovieViewController.self)
    static let addEditMovieCell = String(describing: AddEditMovieTableViewCell.self)
    static let postersListCell = String(describing: PostersListTableViewCell.self)
    static let posterCell = String(describing: PosterCollectionViewCell.self)
    static let toastView = String(describing: ToastView.self)
    
    static let moviesViewControllerTitle = "Favourite Movies"
    static let edit = "Edit"
    static let delete = "Delete"
    static let editMovie = "Edit Movie"
    static let addMovie = "Add Movie"
    static let titleFieldPlaceholder = "Title"
    static let studioFieldPlaceholder = "Studio"
    static let genresFieldPlaceholder = "Genres"
    static let directorsFieldPlaceholder = "Directors"
    static let writersFieldPlaceholder = "Writers"
    static let actorsFieldPlaceholder = "Actors"
    static let yearFieldPlaceholder = "Release year"
    static let lengthFieldPlaceholder = "Running time (minutes)"
    static let mpaRatingFieldPlaceholder = "MPA rating"
    static let criticsRatingFieldPlaceholder = "Critics rating"
    static let descriptionFieldPlaceholder = "Summary"
    static let fieldErrorMessageSubtext = "is required"
    static let movieExistsErrorMessage = "This movie already exists in the database"
    static let deleteAlertMessage = "This action will delete it from the database permanently."
    static let deleteAlertDeleteTitle = "Delete"
    static let deleteAlertCancelTitle = "Cancel"
    
}
