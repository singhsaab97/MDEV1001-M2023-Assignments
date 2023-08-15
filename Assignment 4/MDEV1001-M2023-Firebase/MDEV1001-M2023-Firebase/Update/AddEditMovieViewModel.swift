//
//  AddEditMovieViewModel.swift
//  MDEV1001-M2023-Firebase
//
//  Created by Abhijit Singh on 15/08/23.
//

import UIKit

protocol AddEditMovieListener: AnyObject {
    func addNewMovie(_ movie: Movie?)
    func updateMovie(_ movie: Movie, with updatedMovie: Movie?)
    func doesMovieExist(_ movie: Movie?) -> Bool
}

protocol AddEditMoviePresenter: AnyObject {
    func setNavigationTitle(_ title: String)
    func updateHeaderView(with scrollView: UIScrollView)
    func updateHeaderView(with imageUrl: URL?)
    func showKeyboard(with height: CGFloat, duration: TimeInterval)
    func hideKeyboard(with duration: TimeInterval)
    func pop(completion: (() -> Void)?)
}

protocol AddEditMovieViewModelable {
    var sections: [AddEditMovieViewModel.Section] { get }
    var headerViewImageUrl: URL? { get }
    var presenter: AddEditMoviePresenter? { get set }
    func screenWillAppear()
    func getNumberOfFields(in section: Int) -> Int
    func getCellViewModel(at indexPath: IndexPath) -> CellViewModelable?
    func cancelButtonTapped()
    func doneButtonTapped()
    func didScroll(with scrollView: UIScrollView)
    func keyboardWillShow(with frame: CGRect)
    func keyboardWillHide()
}

final class AddEditMovieViewModel: AddEditMovieViewModelable,
                                   Toastable {
    
    enum Mode {
        case add(id: Int)
        case edit(movie: Movie)
    }
    
    enum Section: Hashable {
        case posters
        case fields([Field])
    }
    
    enum Field: CaseIterable {
        case title
        case studio
        case genres
        case directors
        case writers
        case actors
        case year
        case length
        case mpaRating
        case criticsRating
        case description
    }
    
    let sections: [Section]
    
    private let mode: Mode
    private let posters: [URL?]
    private var updatedMovie: Movie?
    private weak var listener: AddEditMovieListener?
    
    weak var presenter: AddEditMoviePresenter?
    
    init(mode: Mode, posters: [URL?], listener: AddEditMovieListener?) {
        self.mode = mode
        self.posters = posters
        self.sections = [.posters, .fields(Field.allCases)]
        self.listener = listener
        setup()
    }
    
}

// MARK: - Exposed Helpers
extension AddEditMovieViewModel {
    
    var headerViewImageUrl: URL? {
        switch mode {
        case .add:
            return nil
        case let .edit(movie):
            return movie.posterUrl
        }
    }
    
    func screenWillAppear() {
        presenter?.setNavigationTitle(mode.title)
    }
    
    func cancelButtonTapped() {
        presenter?.pop(completion: nil)
    }
    
    func doneButtonTapped() {
        guard validateMovieEntry() else { return }
        switch mode {
        case .add:
            guard !(listener?.doesMovieExist(updatedMovie) ?? false) else {
                showToast(with: Constants.movieExistsErrorMessage)
                return
            }
            presenter?.pop { [weak self] in
                self?.listener?.addNewMovie(self?.updatedMovie)
            }
        case let .edit(movie):
            presenter?.pop { [weak self] in
                self?.listener?.updateMovie(movie, with: self?.updatedMovie)
            }
        }
    }
    
    func getNumberOfFields(in section: Int) -> Int {
        guard let section = sections[safe: section] else { return 0 }
        switch section {
        case .posters:
            return 1
        case let .fields(fields):
            return fields.count
        }
    }
    
    func getCellViewModel(at indexPath: IndexPath) -> CellViewModelable? {
        guard let section = sections[safe: indexPath.section] else { return nil }
        switch section {
        case .posters:
            switch mode {
            case .add:
                return PostersListCellViewModel(
                    posters: posters,
                    currentPoster: nil,
                    listener: self
                )
            case let .edit(movie):
                return PostersListCellViewModel(
                    posters: posters,
                    currentPoster: movie.posterUrl,
                    listener: self
                )
            }
        case let .fields(fields):
            guard let field = fields[safe: indexPath.row] else { return nil }
            return AddEditMovieCellViewModel(mode: mode, field: field, listener: self)
        }
    }
    
    func didScroll(with scrollView: UIScrollView) {
        presenter?.updateHeaderView(with: scrollView)
    }
    
    func keyboardWillShow(with frame: CGRect) {
        presenter?.showKeyboard(with: frame.height, duration: Constants.animationDuration)
    }
    
    func keyboardWillHide() {
        presenter?.hideKeyboard(with: Constants.animationDuration)
    }
    
}

// MARK: - Private Helpers
private extension AddEditMovieViewModel {
    
    func setup() {
        switch mode {
        case let .add(id):
            updatedMovie = Movie.createObject(with: id)
        case let .edit(movie):
            updatedMovie = movie
        }
    }
    
    func validateMovieEntry() -> Bool {
        guard let movie = updatedMovie else { return false }
        // Validate mandatory fields
        let mandatoryFields = Field.allCases.filter { $0.isMandatory }
        for field in mandatoryFields {
            switch field {
            case .title:
                guard movie.title.isEmpty else { continue }
                return showError(for: field)
            case .studio:
                guard movie.studio.isEmpty else { continue }
                return showError(for: field)
            case .genres:
                guard movie.genres.isEmpty else { continue }
                return showError(for: field)
            case .directors:
                guard movie.directors.isEmpty else { continue }
                return showError(for: field)
            case .writers:
                guard movie.writers.isEmpty else { continue }
                return showError(for: field)
            case .actors:
                guard movie.actors.isEmpty else { continue }
                return showError(for: field)
            case .year:
                guard movie.year == 0 else { continue }
                return showError(for: field)
            case .length:
                guard movie.runtime == 0 else { continue }
                return showError(for: field)
            case .mpaRating:
                guard movie.contentRating.isEmpty else { continue }
                return showError(for: field)
            case .criticsRating:
                guard movie.criticsRating.isZero else { continue }
                return showError(for: field)
            case .description:
                guard movie.summary == nil else { continue }
                return showError(for: field)
            }
        }
        return true
    }
    
    func showError(for field: Field) -> Bool {
        showToast(with: field.errorMessage)
        return false
    }
    
}

// MARK: - PostersListCellListener Methods
extension AddEditMovieViewModel: PostersListCellListener {
    
    func newPosterSelected(_ posterUrl: URL?) {
        updatedMovie?.poster = posterUrl?.absoluteString
        switch mode {
        case .add:
            return
        case .edit:
            presenter?.updateHeaderView(with: posterUrl)
        }
    }
    
    func oldPosterDeselected() {
        updatedMovie?.poster = nil
    }
    
}

// MARK: - AddEditMovieCellListener Methods
extension AddEditMovieViewModel: AddEditMovieCellListener {
    
    func movieFieldUpdated(_ field: Field, with text: String?) {
        guard let text = text else { return }
        switch field {
        case .title:
            updatedMovie?.title = text
        case .studio:
            updatedMovie?.studio = text
        case .genres:
            updatedMovie?.genres = text.toArray
        case .directors:
            updatedMovie?.directors = text.toArray
        case .writers:
            updatedMovie?.writers = text.toArray
        case .actors:
            updatedMovie?.actors = text.toArray
        case .year:
            guard let year = Int(text) else { return }
            updatedMovie?.year = year
        case .length:
            guard let length = Int(text) else { return }
            updatedMovie?.runtime = length
        case .mpaRating:
            updatedMovie?.contentRating = text
        case .criticsRating:
            guard let rating = Double(text) else { return }
            updatedMovie?.criticsRating = rating
        case .description:
            updatedMovie?.summary = text
        }
    }
    
}

// MARK: - AddEditMovieViewModel.Mode Helpers
private extension AddEditMovieViewModel.Mode {
    
    var title: String {
        switch self {
        case .add:
            return Constants.addMovie
        case .edit:
            return Constants.editMovie
        }
    }
    
}

// MARK: - AddEditMovieViewModel.Field Helpers
private extension AddEditMovieViewModel.Field {
    
    var isMandatory: Bool {
        switch self {
        case .title, .studio, .criticsRating:
            return true
        case .genres, .directors, .writers, .actors, .year, .length, .mpaRating, .description:
            return false
        }
    }
    
    var errorMessage: String {
        return "\(placeholder) \(Constants.fieldErrorMessageSubtext)"
    }
    
}

