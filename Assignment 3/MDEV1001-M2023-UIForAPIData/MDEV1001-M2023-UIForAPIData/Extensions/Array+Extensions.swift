//
//  Array+Extensions.swift
//  MDEV1001-M2023-UIForAPIData
//
//  Created by Abhijit Singh on 20/07/23.
//

import Foundation

extension Array {
    
    subscript(safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
    
}
