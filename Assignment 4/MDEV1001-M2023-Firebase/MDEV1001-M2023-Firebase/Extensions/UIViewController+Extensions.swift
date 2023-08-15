//
//  UIViewController+Extensions.swift
//  MDEV1001-M2023-Firebase
//
//  Created by Abhijit Singh on 15/08/23.
//

import UIKit

extension UIViewController {
    
    func popViewController(completion: (() -> Void)?) {
        CATransaction.begin()
        CATransaction.setCompletionBlock {
            completion?()
        }
        navigationController?.popViewController(animated: true)
        CATransaction.commit()
    }
    
}
