//
//  UserDefaults+Extensions.swift
//  MDEV1001-M2023-UIForLocalDataAssignment
//
//  Created by Abhijit Singh on 10/06/23.
//  Copyright © 2023 Abhijit Singh. All rights reserved.
//

import Foundation

extension UserDefaults {
    
    static let appSuite = UserDefaults(suiteName: Constants.suiteName) ?? UserDefaults()
    static let areMoviesSavedKey = "isDataSavedKey"
    static let availablePostersKey = "availablePostersKey"
    static let sortOptionKey = "sortOptionKey"
    
    static var areMoviesSaved: Bool {
        return appSuite.bool(forKey: areMoviesSavedKey)
    }
    
    static var availablePosters: [String] {
        return appSuite.array(forKey: availablePostersKey) as? [String] ?? []
    }
    
    static var sortOption: MoviesViewModel.SortOption {
        let value = appSuite.integer(forKey: sortOptionKey)
        return MoviesViewModel.SortOption(rawValue: value) ?? .alphabetically
    }
    
}
