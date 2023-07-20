//
//  Colors.swift
//  MDEV1001-M2023-UIForAPIData
//
//  Created by Abhijit Singh on 20/07/23.
//

import UIKit

enum Color: String {
    case background
    case secondaryBackground
    case label
    case secondaryLabel
    
    var shade: UIColor {
        return UIColor(named: rawValue)!
    }
    
}
