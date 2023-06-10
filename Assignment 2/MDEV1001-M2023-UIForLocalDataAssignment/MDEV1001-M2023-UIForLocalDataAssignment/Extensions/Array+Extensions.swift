//
//  Array+Extensions.swift
//  MDEV1001-M2023-UIForLocalDataAssignment
//
//  Created by Abhijit Singh on 08/06/23.
//  Copyright © 2023 Abhijit Singh. All rights reserved.
//

import Foundation

extension Array where Element: Hashable {
    
    subscript(safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
    
}
