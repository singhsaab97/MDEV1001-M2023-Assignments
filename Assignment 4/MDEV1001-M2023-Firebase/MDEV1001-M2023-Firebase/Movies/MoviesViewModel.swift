//
//  MoviesViewModel.swift
//  MDEV1001-M2023-Firebase
//
//  Created by Abhijit Singh on 14/08/23.
//

import UIKit

protocol MoviesPresenter: AnyObject {
    func setNavigationTitle(_ title: String)
    func startLoading()
    func stopLoading()
    func reloadSections(_ indexSet: IndexSet)
    func reloadRows(at indexPaths: [IndexPath])
    func insertRows(at indexPaths: [IndexPath])
    func deleteRows(at indexPaths: [IndexPath])
    func scroll(to indexPath: IndexPath)
    func present(_ viewController: UIViewController)
    func push(_ viewController: UIViewController)
}

protocol MoviesViewModelable {
    var numberOfMovies: Int { get }
    var presenter: MoviesPresenter? { get set }
    func screenWillAppear()
    func screenLoaded()
    func addButtonTapped()
    func getCellViewModel(at indexPath: IndexPath) -> MovieCellViewModelable?
    func didSelectMovie(at indexPath: IndexPath)
    func leadingSwipedMovie(at indexPath: IndexPath) -> UIContextualAction
    func trailingSwipedMovie(at indexPath: IndexPath) -> UISwipeActionsConfiguration
}

final class MoviesViewModel: MoviesViewModelable {
    
    private var movies: [Movie]
       
    weak var presenter: MoviesPresenter?
    
    init() {
        self.movies = []
    }
    
}

// MARK: - Exposed Helpers
extension MoviesViewModel {
    
    var numberOfMovies: Int {
        return movies.count
    }
    
    func screenWillAppear() {
        presenter?.setNavigationTitle(Constants.moviesViewControllerTitle)
    }
    
    func screenLoaded() {
        fetchMovies()
    }
    
    func addButtonTapped() {
        showAddEditViewController(for: .add(id: movies.count + 1))
    }
    
    func getCellViewModel(at indexPath: IndexPath) -> MovieCellViewModelable? {
        guard let movie = movies[safe: indexPath.row] else { return nil }
        return MovieCellViewModel(movie: movie)
    }
    
    func didSelectMovie(at indexPath: IndexPath) {
        guard var movie = movies[safe: indexPath.row] else { return }
        movie.isExpanded = !movie.isExpanded
        movies[indexPath.row] = movie
        presenter?.reloadRows(at: [indexPath])
    }
    
    func leadingSwipedMovie(at indexPath: IndexPath) -> UIContextualAction {
        // Edit action
        return UIContextualAction(style: .normal, title: Constants.edit) { [weak self] (_, _, _) in
            self?.editMovie(at: indexPath)
        }
    }
    
    func trailingSwipedMovie(at indexPath: IndexPath) -> UISwipeActionsConfiguration {
        // Delete action
        let action = UIContextualAction(style: .destructive, title: Constants.delete) { [weak self] (_, _, _) in
            self?.deleteMovie(at: indexPath)
        }
        return UISwipeActionsConfiguration(actions: [action])
    }
    
}

// MARK: - Private Helpers
private extension MoviesViewModel {
    
    func fetchMovies() {
        presenter?.startLoading()
        MoviesDataHandler.instance.fetchMovies { [weak self] (movies, error) in
            self?.presenter?.stopLoading()
            guard let error = error else {
                self?.movies = movies
                self?.presenter?.reloadSections(IndexSet(integer: 0))
                return
            }
            // TODO: Show error alert
        }
    }
    
    func editMovie(at indexPath: IndexPath) {
        guard let movie = movies[safe: indexPath.row] else { return }
        showAddEditViewController(for: .edit(movie: movie))
    }
    
    func deleteMovie(at indexPath: IndexPath) {
        // Delete movie
        guard let movie = movies[safe: indexPath.row],
              let documentId = movie.documentId,
              let index = movies.firstIndex(of: movie) else { return }
        let alertTitle = "\(Constants.delete) \"\(movie.title)\"?"
        prepareDeleteAlert(with: alertTitle, message: Constants.deleteAlertMessage) { [weak self] in
            MoviesDataHandler.instance.deleteMovie(at: documentId) { [weak self] error in
                let indexPath = IndexPath(row: index, section: 0)
                self?.movies.remove(at: index)
                self?.presenter?.deleteRows(at: [indexPath])
            }
        }
    }
    
    func showAddEditViewController(for mode: AddEditMovieViewModel.Mode) {
        let posters = movies.map { $0.posterUrl }
        let viewModel = AddEditMovieViewModel(
            mode: mode,
            posters: posters,
            listener: self
        )
        let viewController = AddEditMovieViewController.loadFromStoryboard()
        viewController.viewModel = viewModel
        viewModel.presenter = viewController
        presenter?.push(viewController)
    }
    
    func scroll(to indexPath: IndexPath) {
        DispatchQueue.main.async { [weak self] in
            self?.presenter?.scroll(to: indexPath)
        }
    }
    
    func prepareDeleteAlert(with title: String, message: String, action: @escaping () -> Void) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: Constants.deleteAlertCancelTitle, style: .default)
        let deleteAction = UIAlertAction(title: Constants.deleteAlertDeleteTitle, style: .destructive) {_ in
            action()
        }
        alertController.addAction(cancelAction)
        alertController.addAction(deleteAction)
        presenter?.present(alertController)
    }
    
}

// MARK: - AddEditMovieListener Methods
extension MoviesViewModel: AddEditMovieListener {

    func addNewMovie(_ movie: Movie?) {
        // Add movie
        guard let movie = movie else { return }
        MoviesDataHandler.instance.addMovie(movie) { [weak self] error in
            guard let self = self else { return }
            guard let error = error else {
                let indexPath = IndexPath(row: self.movies.count, section: 0)
                self.movies.append(movie)
                self.presenter?.insertRows(at: [indexPath])
                self.scroll(to: indexPath)
                return
            }
            // TODO: Show error alert
        }
    }

    func updateMovie(_ movie: Movie, with updatedMovie: Movie?) {
        // Update movie
        guard let documentId = movie.documentId,
              let movie = updatedMovie else { return }
        MoviesDataHandler.instance.updateMovie(at: documentId, with: movie) { [weak self] error in
            guard let error = error else {
                if let index = self?.movies.firstIndex(where: { $0.documentId == movie.documentId }) {
                    let indexPath = IndexPath(row: index, section: 0)
                    self?.movies[index] = movie
                    self?.presenter?.reloadRows(at: [indexPath])
                    self?.scroll(to: indexPath)
                }
                return
            }
            // TODO: Show error alert
        }
    }
    
    func doesMovieExist(_ movie: Movie?) -> Bool {
        return movies.contains(where: {
            return $0.title == movie?.title && $0.studio == movie?.studio
        })
    }

}
