//
//  String+Extensions.swift
//  MDEV1001-M2023-UIForAPIData
//
//  Created by Abhijit Singh on 20/07/23.
//

import UIKit

enum StringSizeParameter {
    case width(constrainedHeight: CGFloat)
    case height(constrainedWidth: CGFloat)
}

extension String {
    
    var capitalizedInitial: String {
        return prefix(1).capitalized + dropFirst()
    }
    
    func calculate(_ parameter: StringSizeParameter, with font: UIFont) -> CGFloat {
        let constrainedSize: CGSize
        switch parameter {
        case let .width(constrainedHeight):
            constrainedSize = CGSize(width: .greatestFiniteMagnitude, height: constrainedHeight)
        case let .height(constrainedWidth):
            constrainedSize = CGSize(width: constrainedWidth, height: .greatestFiniteMagnitude)
        }
        let boundingBox = self.boundingRect(
            with: constrainedSize,
            options: [.usesLineFragmentOrigin, .usesFontLeading],
            attributes: [.font: font],
            context: nil
        )
        switch parameter {
        case .width:
            return boundingBox.width
        case .height:
            return boundingBox.height
        }
    }
    
}
