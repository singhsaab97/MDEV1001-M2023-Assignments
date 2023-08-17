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
    static let delayDuration: TimeInterval = 0.5
    static let toastDisplayDuration: TimeInterval = 3
    
    static let suiteName = Bundle.main.infoDictionary!["CFBundleName"] as! String
    static let usersCollectionName = "Users"
    static let userEmailIdCodingKey = "email_id"
    static let moviesCollectionName = "Movies"
    static let storyboardName = "Main"
    static let authenticationViewController = String(describing: AuthenticationViewController.self)
    static let moviesViewController = String(describing: MoviesViewController.self)
    static let movieCell = String(describing: MovieTableViewCell.self)
    static let addEditMovieViewController = String(describing: AddEditMovieViewController.self)
    static let addEditMovieCell = String(describing: AddEditMovieTableViewCell.self)
    static let postersListCell = String(describing: PostersListTableViewCell.self)
    static let posterCell = String(describing: PosterCollectionViewCell.self)
    static let toastView = String(describing: ToastView.self)
    
    static let signUpTitle = "Create account"
    static let signUpSubtitle = "Please fill your details in the form below"
    static let signUpMessage = "Already have an account?"
    static let signUp = "Sign Up"
    static let signInTitle = "Welcome back"
    static let signInSubtitle = "Please log in with your details below"
    static let signInMessage = "Don't have an account?"
    static let signIn = "Sign In"
    static let nameFieldPlaceholder = "Full name"
    static let usernameFieldPlaceholder = "Username"
    static let emailFieldPlaceholder = "Email address"
    static let confirmEmailFieldPlaceholder = "Confirm email address"
    static let passwordFieldPlaceholder = "Password"
    static let confirmPasswordFieldPlaceholder = "Confirm password"
    static let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
    static let registrationFailedMessage = "Registration failed"
    static let authenticationFailedMessage = "Authentication failed"
    
    
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
    static let logoutAlertMessage = "You will have to sign in again once you log out."
    static let logoutAlertTitle = "Logout?"
    static let logoutAlertLogoutTitle = "Logout"
    static let alertCancelTitle = "Cancel"
    
}
