//
//  EmptyCellViewModel.swift
//  MDEV1001-M2023-UIForAPIData
//
//  Created by Abhijit Singh on 21/07/23.
//

import UIKit

protocol EmptyCellViewModelable {
    var emptyImage: UIImage? { get }
    var title: String { get }
    var message: String { get }
    var searchQuery: String { get }
}

final class EmptyCellViewModel: EmptyCellViewModelable {
    
    let searchQuery: String
    
    init(searchQuery: String) {
        self.searchQuery = searchQuery
    }
    
}

// MARK: - Exposed Helpers
extension EmptyCellViewModel {
    
    var emptyImage: UIImage? {
        return UIImage(named: "emptyMovies")
    }
    
    var title: String {
        return Constants.uhOh
    }
    
    var message: String {
        return "\(Constants.emptyMovies) \"\(searchQuery)\""
    }
    
}
