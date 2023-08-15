//
//  String+Extensions.swift
//  MDEV1001-M2023-Firebase
//
//  Created by Abhijit Singh on 15/08/23.
//

import Foundation

extension String {
    
    /// Assumes that the values are separated by `,`
    var toArray: [String] {
        return components(separatedBy: ",").map { $0.trimmingCharacters(in: .whitespaces) }
    }
    
}
