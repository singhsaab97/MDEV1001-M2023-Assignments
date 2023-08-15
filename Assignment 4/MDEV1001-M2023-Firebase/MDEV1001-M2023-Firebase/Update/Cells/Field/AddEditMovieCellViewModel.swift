//
//  AddEditMovieCellViewModel.swift
//  MDEV1001-M2023-Firebase
//
//  Created by Abhijit Singh on 15/08/23.
//

import UIKit

protocol AddEditMovieCellListener: AnyObject {
    func movieFieldUpdated(_ field: AddEditMovieViewModel.Field, with text: String?)
}

protocol AddEditMovieCellViewModelable: CellViewModelable {
    var field: AddEditMovieViewModel.Field { get }
    var fieldText: String? { get }
    func didTypeText(_ text: String?, newText: String) -> Bool
}

final class AddEditMovieCellViewModel: AddEditMovieCellViewModelable {

    let mode: AddEditMovieViewModel.Mode
    let field: AddEditMovieViewModel.Field
    
    private weak var listener: AddEditMovieCellListener?
    
    init(mode: AddEditMovieViewModel.Mode,
         field: AddEditMovieViewModel.Field,
         listener: AddEditMovieCellListener?) {
        self.mode = mode
        self.field = field
        self.listener = listener
    }
    
}

// MARK: - Exposed Helpers
extension AddEditMovieCellViewModel {
    
    var fieldText: String? {
        switch mode {
        case .add:
            return nil
        case let .edit(movie):
            switch field {
            case .title:
                return movie.title
            case .studio:
                return movie.studio
            case .genres:
                return movie.genres.toCsv
            case .directors:
                return movie.directors.toCsv
            case .writers:
                return movie.writers.toCsv
            case .actors:
                return movie.actors.toCsv
            case .year:
                return String(movie.year)
            case .length:
                return String(movie.runtime)
            case .mpaRating:
                return movie.contentRating
            case .criticsRating:
                return String(movie.criticsRating)
            case .description:
                return movie.summary
            }
        }
    }
    
    func didTypeText(_ text: String?, newText: String) -> Bool {
        guard let text = text else { return false }
        var fieldText: String?
        if newText.isEmpty {
            // Deleting
            fieldText = text.count <= 1 ? nil : String(text.dropLast())
        } else {
            // Typing
            fieldText = text.appending(newText)
        }
        listener?.movieFieldUpdated(field, with: fieldText)
        return true
    }
    
}

// MARK: - AddEditMovieViewModel.Field Helpers
extension AddEditMovieViewModel.Field {
    
    var placeholder: String {
        switch self {
        case .title:
            return Constants.titleFieldPlaceholder
        case .studio:
            return Constants.studioFieldPlaceholder
        case .genres:
            return Constants.genresFieldPlaceholder
        case .directors:
            return Constants.directorsFieldPlaceholder
        case .writers:
            return Constants.writersFieldPlaceholder
        case .actors:
            return Constants.actorsFieldPlaceholder
        case .year:
            return Constants.yearFieldPlaceholder
        case .length:
            return Constants.lengthFieldPlaceholder
        case .mpaRating:
            return Constants.mpaRatingFieldPlaceholder
        case .criticsRating:
            return Constants.criticsRatingFieldPlaceholder
        case .description:
            return Constants.descriptionFieldPlaceholder
        }
    }
    
    var keyboardType: UIKeyboardType {
        switch self {
        case .title, .studio, .genres, .directors, .writers, .actors, .mpaRating:
            return .alphabet
        case .year, .length:
            return .numberPad
        case .criticsRating:
            return .decimalPad
        case .description:
            return .default
        }
    }
    
}
