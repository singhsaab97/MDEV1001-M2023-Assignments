//
//  Array+Extensions.swift
//  MDEV1001-M2023-Firebase
//
//  Created by Abhijit Singh on 14/08/23.
//

import Foundation

extension Array {
    
    subscript(safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
    
}

extension Array where Element == String {
    
    var toCsv: String {
        return joined(separator: ", ")
    }
    
}

extension Array where Element: Equatable {
    
    var removedDuplicates: [Element] {
        var results = [Element]()
        for value in self {
            if !results.contains(value) {
                results.append(value)
            }
        }
        return results
    }
    
}
