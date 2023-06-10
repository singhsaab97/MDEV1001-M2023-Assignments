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
    static let isDataSavedKey = "isDataSavedKey"
    static let sortOptionKey = "sortOptionKey"
    
    static var isDataSaved: Bool {
        return appSuite.bool(forKey: isDataSavedKey)
    }
    
    static var sortOption: MoviesViewModel.SortOption {
        let value = appSuite.integer(forKey: sortOptionKey)
        return MoviesViewModel.SortOption(rawValue: value) ?? .highestRating
    }
    
}
