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
    var sortButtonImage: UIImage? { get }
    var sortContextMenu: UIMenu { get }
    var presenter: MoviesPresenter? { get set }
    func screenWillAppear()
    func screenLoaded()
    func addButtonTapped()
    func deleteAllButtonTapped()
    func cancelSearchButtonTapped()
    func didTypeSearchText(_ text: String)
    func getCellViewModel(at indexPath: IndexPath) -> MovieCellViewModelable?
    func didSelectMovie(at indexPath: IndexPath)
    func leadingSwipedMovie(at indexPath: IndexPath) -> UIContextualAction
    func trailingSwipedMovie(at indexPath: IndexPath) -> UISwipeActionsConfiguration
}

final class MoviesViewModel: MoviesViewModelable,
                             Toastable {
    
    enum SortOption: Int, CaseIterable {
        case alphabetically
        case highestRating
        case lowestRating
        case latestRelease
        case oldestRelease
        case longestRunningTime
        case shortestRunningTime
    }
    
    enum Operation {
        case add(movie: Movie)
        case edit(movie: Movie)
        case delete(indexPath: IndexPath)
        case deleteAll
    }
    
    private var movies: [Movie]
    private var filteredMovies: [Movie]
    private var isExpandedDict: [ObjectIdentifier: Bool]
    private var isSearching: Bool
        
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
        self.filteredMovies = []
        self.isExpandedDict = [:]
        self.isSearching = false
        saveData()
    }
    
}

// MARK: - Exposed Helpers
extension MoviesViewModel {
    
    var numberOfMovies: Int {
        return isSearching ? filteredMovies.count : movies.count
    }
    
    var sortButtonImage: UIImage? {
        return UIImage(systemName: "square.stack")
    }
    
    var sortContextMenu: UIMenu {
        let actions = SortOption.allCases.map { option in
            return UIAction(title: option.title) { [weak self] _ in
                guard option != UserDefaults.sortOption else { return }
                self?.execute(sortingWith: option)
            }
        }
        return UIMenu(children: actions)
    }
    
    func screenWillAppear() {
        presenter?.setNavigationTitle(Constants.moviesViewControllerTitle)
    }
    
    func screenLoaded() {
        loadData()
        presenter?.reloadSections(IndexSet(integer: 0))
    }
    
    func addButtonTapped() {
        showAddEditViewController(for: .add)
    }
    
    func deleteAllButtonTapped() {
        execute(operation: .deleteAll)
    }
    
    func cancelSearchButtonTapped() {
        isSearching = false
        filteredMovies = []
        presenter?.reloadSections(IndexSet(integer: 0))
    }
    
    func didTypeSearchText(_ text: String) {
        isSearching = !text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        filteredMovies = movies.filter {
            return $0.title?.contains(text) ?? false
        }
        presenter?.reloadSections(IndexSet(integer: 0))
    }
    
    func getCellViewModel(at indexPath: IndexPath) -> MovieCellViewModelable? {
        let movies = isSearching ? filteredMovies : movies
        guard let movie = movies[safe: indexPath.row],
              let isExpanded = isExpandedDict[movie.id] else { return nil }
        return MovieCellViewModel(movie: movie, isExpanded: isExpanded)
    }
    
    func didSelectMovie(at indexPath: IndexPath) {
        guard let movie = movies[safe: indexPath.row],
              let isExpanded = isExpandedDict[movie.id] else { return }
        isExpandedDict[movie.id] = !isExpanded
        presenter?.reloadRows(at: [indexPath])
        scroll(to: indexPath)
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
        guard !UserDefaults.areMoviesSaved,
              let url = Bundle.main.url(
                forResource: Constants.jsonFileName,
                withExtension: "json"
              ),
              let data = try? Data(contentsOf: url),
              let jsonArray = try? JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]] else { return }
        let context = persistentContainer.viewContext
        var posters = [String]()
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
            if let year = object["year"] as? Int16 {
                movie.year = year
            }
            if let length = object["length"] as? Int16 {
                movie.length = length
            }
            movie.shortdescription = object["shortDescription"] as? String
            movie.mparating = object["mpaRating"] as? String
            if let criticsRating = object["criticsRating"] as? Double {
                movie.criticsrating = criticsRating
            }
            if let poster = object["poster"] as? String {
                movie.poster = poster
                posters.append(poster)
            }
        }
        saveContext(context)
        UserDefaults.appSuite.set(posters, forKey: UserDefaults.availablePostersKey)
        UserDefaults.appSuite.set(true, forKey: UserDefaults.areMoviesSavedKey)
    }
    
    /// Load stored data from persistent container
    func loadData() {
        let context = persistentContainer.viewContext
        let request = Movie.fetchRequest()
        do {
            movies = try context.fetch(request)
            movies.forEach { movie in
                isExpandedDict[movie.id] = false
            }
            execute(sortingWith: UserDefaults.sortOption)
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
        guard !isSearching else {
            showToast(with: Constants.cannotEditDuringSearchMessage)
            return
        }
        guard let movie = movies[safe: indexPath.row] else { return }
        showAddEditViewController(for: .edit(movie: movie))
    }
    
    func deleteMovie(at indexPath: IndexPath) {
        guard !isSearching else {
            showToast(with: Constants.cannotDeleteDuringSearchMessage)
            return
        }
        execute(operation: .delete(indexPath: indexPath))
    }
    
    func setMovie(_ movie: Movie, with updatedMovie: LocalMovie) {
        movie.title = updatedMovie.title
        movie.studio = updatedMovie.studio
        movie.genres = updatedMovie.genres
        movie.directors = updatedMovie.directors
        movie.writers = updatedMovie.writers
        movie.actors = updatedMovie.actors
        if let year = updatedMovie.year {
            movie.year = year
        }
        if let length = updatedMovie.length {
            movie.length = length
        }
        movie.mparating = updatedMovie.mpaRating
        if let criticsRating = updatedMovie.criticsRating {
            // Limit to one decimal place
            movie.criticsrating = floor(criticsRating * 10) / 10
        }
        movie.shortdescription = updatedMovie.description
        movie.poster = updatedMovie.poster
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
        let viewModel = AddEditMovieViewModel(
            mode: mode,
            posters: UserDefaults.availablePosters,
            listener: self
        )
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
            isExpandedDict[movie.id] = false
            let indexPath = IndexPath(row: Int(movie.movieid - 1), section: 0)
            presenter?.insertRows(at: [indexPath])
            sortAndScroll(to: movie)
        case let .edit(movie):
            guard let index = movies.firstIndex(where: { $0.movieid == movie.movieid }) else { return }
            saveContext(context)
            movies[index] = movie
            let indexPath = IndexPath(row: index, section: 0)
            presenter?.reloadRows(at: [indexPath])
            sortAndScroll(to: movie)
        case let .delete(indexPath):
            guard let movie = movies[safe: indexPath.row],
                  let index = movies.firstIndex(of: movie) else { return }
            var alertTitle = Constants.delete
            if let title = movie.title {
                alertTitle.append(" \"\(title)\"?")
            }
            prepareDeleteAlert(with: alertTitle, message: Constants.deleteAlertMessage) { [weak self] in
                guard let self = self else { return }
                context.delete(movie)
                self.saveContext(context)
                self.movies.removeAll(where: { $0 == movie })
                self.isExpandedDict.removeValue(forKey: movie.id)
                let indexPath = IndexPath(row: index, section: 0)
                self.presenter?.deleteRows(at: [indexPath])
            }
        case .deleteAll:
            guard !isSearching else {
                showToast(with: Constants.cannotDeleteDuringSearchMessage)
                return
            }
            prepareDeleteAlert(
                with: Constants.deleteAllAlertTitle,
                message: Constants.deleteAllAlertMessage
            ) { [weak self] in
                guard let self = self else { return }
                self.movies.forEach { movie in
                    context.delete(movie)
                    self.isExpandedDict.removeValue(forKey: movie.id)
                }
                self.saveContext(context)
                let indexPaths = self.movies.enumerated().map { (index, _) in
                    return IndexPath(row: index, section: 0)
                }
                self.movies.removeAll()
                self.presenter?.deleteRows(at: indexPaths)
            }
        }
    }
    
    func execute(sortingWith option: SortOption) {
        switch option {
        case .alphabetically:
            movies = movies.sorted(by: {
                return $0.title ?? String() < $1.title ?? String()
            })
        case .highestRating:
            movies = movies.sorted(by: {
                return $0.criticsrating > $1.criticsrating
            })
        case .lowestRating:
            movies = movies.sorted(by: {
                return $0.criticsrating < $1.criticsrating
            })
        case .latestRelease:
            movies = movies.sorted(by: {
                return $0.year > $1.year
            })
        case .oldestRelease:
            movies = movies.sorted(by: {
                return $0.year < $1.year
            })
        case .longestRunningTime:
            movies = movies.sorted(by: {
                return $0.length > $1.length
            })
        case .shortestRunningTime:
            movies = movies.sorted(by: {
                return $0.length < $1.length
            })
        }
        presenter?.reloadSections(IndexSet(integer: 0))
        UserDefaults.appSuite.set(option.rawValue, forKey: UserDefaults.sortOptionKey)
    }
    
    func scroll(to indexPath: IndexPath) {
        DispatchQueue.main.async { [weak self] in
            self?.presenter?.scroll(to: indexPath)
        }
    }
    
    /// Called after adding or updating a movie to place the it on appropriate index based on the current sort option
    func sortAndScroll(to movie: Movie) {
        DispatchQueue.main.async { [weak self] in
            self?.execute(sortingWith: UserDefaults.sortOption)
            guard let index = self?.movies.firstIndex(of: movie) else { return }
            let indexPath = IndexPath(row: index, section: 0)
            self?.scroll(to: indexPath)
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
    
    func addNewMovie(_ movie: LocalMovie) {
        let context = persistentContainer.viewContext
        let newMovie = Movie(context: context)
        let movieId = Int16(movies.count + 1)
        newMovie.movieid = movieId
        setMovie(newMovie, with: movie)
        execute(operation: .add(movie: newMovie))
    }
    
    func updateMovie(_ movie: Movie, with editedMovie: LocalMovie) {
        setMovie(movie, with: editedMovie)
        execute(operation: .edit(movie: movie))
    }
    
    func doesMovieExist(_ movie: LocalMovie) -> Bool {
        return movies.contains(where: { movie.isEqual(to: $0) })
    }
    
}

// MARK: - MoviesViewModel.SortOption Helpers
private extension MoviesViewModel.SortOption {
    
    var title: String {
        switch self {
        case .alphabetically:
            return Constants.alphabeticallyOption
        case .highestRating:
            return Constants.highestRatingOption
        case .lowestRating:
            return Constants.lowestRatingOption
        case .latestRelease:
            return Constants.latestReleaseOption
        case .oldestRelease:
            return Constants.oldestReleaseOption
        case .longestRunningTime:
            return Constants.longestRunningTimeOption
        case .shortestRunningTime:
            return Constants.shortestRunningTimeOption
        }
    }
    
}
