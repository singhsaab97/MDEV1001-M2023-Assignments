//
//  UserDefaults+Extensions.swift
//  MDEV1001-M2023-Firebase
//
//  Created by Abhijit Singh on 15/08/23.
//

import UIKit

extension UserDefaults {
    
    static let appSuite = UserDefaults(suiteName: Constants.suiteName) ?? UserDefaults()
    static let userInterfaceStyleKey = "userInterfaceStyleKey"
    static let availablePostersKey = "availablePostersKey"
    
    static var userInterfaceStyle: UIUserInterfaceStyle {
        let value = appSuite.integer(forKey: userInterfaceStyleKey)
        return UIUserInterfaceStyle(rawValue: value) ?? .unspecified
    }
    
    static var availablePosters: [String] {
        return appSuite.array(forKey: availablePostersKey) as? [String] ?? []
    }
    
}
