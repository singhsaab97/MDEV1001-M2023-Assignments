//
//  MoviesViewModel.swift
//  MDEV1001-M2023-UIForLocalDataAssignment
//
//  Created by Abhijit Singh on 08/06/23.
//  Copyright © 2023 Abhijit Singh. All rights reserved.
//

import UIKit
import CoreData

protocol MoviesPresenter: AnyObject {
    func setNavigationTitle(_ title: String)
    func reloadData()
    func reloadRows(at indexPaths: [IndexPath])
    func insertRows(at indexPaths: [IndexPath])
    func deleteRows(at indexPaths: [IndexPath])
    func scroll(to indexPath: IndexPath)
    func push(_ viewController: UIViewController)
}

protocol MoviesViewModelable {
    var numberOfMovies: Int { get }
    var sortButtonTitle: String { get }
    var sortContextMenu: UIMenu { get }
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
    
    enum SortOption: CaseIterable {
        case highestRating
        case lowestRating
        case alphabetically
    }
    
    enum Operation {
        case add(movie: Movie)
        case edit(indexPath: IndexPath)
        case delete(indexPath: IndexPath)
        case deleteAll
    }
    
    private var movies: [Movie]
    private var isExpandedDict: [Int16: Bool]
        
    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: Constants.dbModelName)
        container.loadPersistentStores { [weak self] (_, error) in
            self?.logError(error)
        }
        return container
    }()
    
    weak var presenter: MoviesPresenter?
    
    init() {
        self.movies = []
        self.isExpandedDict = [:]
        saveData()
    }
    
}

// MARK: - Exposed Helpers
extension MoviesViewModel {
    
    var numberOfMovies: Int {
        return movies.count
    }
    
    var sortButtonTitle: String {
        return Constants.sort
    }
    
    var sortContextMenu: UIMenu {
        let actions = SortOption.allCases.map { option in
            return UIAction(title: option.title) { [weak self] _ in
                switch option {
                case .highestRating:
                    // TODO
                    break
                case .lowestRating:
                    // TODO
                    break
                case .alphabetically:
                    // TODO
                    break
                }
            }
        }
        return UIMenu(children: actions)
    }
    
    func screenWillAppear() {
        presenter?.setNavigationTitle(Constants.moviesViewControllerTitle)
    }
    
    func screenLoaded() {
        loadData()
        presenter?.reloadData()
    }
    
    func addButtonTapped() {
        showAddEditViewController(for: .add)
    }
    
    func getCellViewModel(at indexPath: IndexPath) -> MovieCellViewModelable? {
        guard let movie = movies[safe: indexPath.row],
              let isExpanded = isExpandedDict[movie.movieid] else { return nil }
        return MovieCellViewModel(movie: movie, isExpanded: isExpanded)
    }
    
    func didSelectMovie(at indexPath: IndexPath) {
        guard let movie = movies[safe: indexPath.row],
              let isExpanded = isExpandedDict[movie.movieid] else { return }
        isExpandedDict[movie.movieid] = !isExpanded
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
  
    /// Stores and persists data from `Movies.json` if context doesn't exist
    func saveData() {
        guard !UserDefaults.isDataSaved,
              let url = Bundle.main.url(
                forResource: Constants.jsonFileName,
                withExtension: "json"
              ),
              let data = try? Data(contentsOf: url),
              let jsonArray = try? JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]] else { return }
        let context = persistentContainer.viewContext
        for object in jsonArray {
            let movieId = object["movieId"] as? Int16 ?? .zero
            guard !doesMovieExist(with: movieId) else { continue }
            let movie = Movie(context: context)
            movie.movieid = movieId
            movie.title = object["title"] as? String
            movie.studio = object["studio"] as? String
            movie.genres = object["genres"] as? String
            movie.directors = object["directors"] as? String
            movie.writers = object["writers"] as? String
            movie.actors = object["actors"] as? String
            movie.year = object["year"] as? Int16 ?? .zero
            movie.length = object["length"] as? Int16 ?? .zero
            movie.shortdescription = object["shortDescription"] as? String
            movie.mparating = object["mpaRating"] as? String
            movie.criticsrating = object["criticsRating"] as? Double ?? .zero
            movie.poster = object["poster"] as? String
        }
        saveContext(context)
        UserDefaults.appSuite.set(true, forKey: UserDefaults.isDataSavedKey)
    }
    
    /// Load stored data from persistent container
    func loadData() {
        let context = persistentContainer.viewContext
        let request = Movie.fetchRequest()
        do {
            movies = try context.fetch(request)
            movies.forEach { movie in
                isExpandedDict[movie.movieid] = false
            }
        } catch {
            logError(error)
        }
    }
    
    /// Check if a movie exists in the existing data model
    func doesMovieExist(with id: Int16) -> Bool {
        let context = persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: Constants.dbModelName)
        request.predicate = NSPredicate(format: "movieid == %@", String(id))
        do {
            let results = try context.fetch(request)
            return results.count > 0
        } catch {
            logError(error)
            return false
        }
    }
    
    func logError(_ error: Error?) {
        guard let nserror = error as? NSError else { return }
        fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
    }
    
    func editMovie(at indexPath: IndexPath) {
        guard let movie = movies[safe: indexPath.row] else { return }
        showAddEditViewController(for: .edit(movie: movie))
    }
    
    func deleteMovie(at indexPath: IndexPath) {
        execute(operation: .delete(indexPath: indexPath))
    }
    
    func saveContext(_ context: NSManagedObjectContext) {
        guard context.hasChanges else { return }
        do {
            try context.save()
        } catch {
            logError(error)
        }
    }
    
    func showAddEditViewController(for mode: AddEditMovieViewModel.Mode) {
        let viewModel = AddEditMovieViewModel(mode: mode, listener: self)
        let viewController = AddEditMovieViewController.loadFromStoryboard()
        viewController.viewModel = viewModel
        presenter?.push(viewController)
    }
    
    func execute(operation: Operation) {
        let context = persistentContainer.viewContext
        switch operation {
        case let .add(movie):
            saveContext(context)
            movies.append(movie)
            isExpandedDict[movie.movieid] = false
            let indexPath = IndexPath(row: Int(movie.movieid - 1), section: 0)
            presenter?.insertRows(at: [indexPath])
            DispatchQueue.main.async { [weak self] in
                self?.presenter?.scroll(to: indexPath)
            }
        case let .edit(indexPath):
            // TODO
            return
        case let .delete(indexPath):
            guard let movie = movies[safe: indexPath.row],
                  let index = movies.firstIndex(of: movie) else { return }
            context.delete(movie)
            saveContext(context)
            movies.removeAll(where: { $0 == movie })
            isExpandedDict.removeValue(forKey: movie.movieid)
            let indexPath = IndexPath(row: index, section: 0)
            presenter?.deleteRows(at: [indexPath])
        case .deleteAll:
            // TODO
            return
        }
    }
    
}

// MARK: - AddEditMovieListener Methods
extension MoviesViewModel: AddEditMovieListener {
    
    func addNewMovie(_ movie: LocalMovie) {
        let context = persistentContainer.viewContext
        let newMovie = Movie(context: context)
        let movieId = Int16(movies.count + 1)
        newMovie.movieid = movieId
        newMovie.title = movie.title
        newMovie.studio = movie.studio
        newMovie.genres = movie.genres
        newMovie.directors = movie.directors
        newMovie.writers = movie.writers
        newMovie.actors = movie.actors
        newMovie.year = movie.year ?? .zero
        newMovie.length = movie.length ?? .zero
        newMovie.mparating = movie.mpaRating
        newMovie.criticsrating = movie.criticsRating ?? .zero
        newMovie.shortdescription = movie.description
        execute(operation: .add(movie: newMovie))
    }
    
    func updateMovie(_ movie: Movie, with editedMovie: LocalMovie) {
        // TODO
    }
    
}

// MARK: - MoviesViewModel.SortOption Helpers
private extension MoviesViewModel.SortOption {
    
    var title: String {
        switch self {
        case .highestRating:
            return Constants.highestRatingOption
        case .lowestRating:
            return Constants.lowestRatingOption
        case .alphabetically:
            return Constants.alphabeticallyOption
        }
    }
    
}