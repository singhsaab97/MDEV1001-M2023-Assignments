//
//  ToastView.swift
//  MDEV1001-M2023-UIForAPIData
//
//  Created by Abhijit Singh on 21/07/23.
//

import UIKit

import UIKit

final class ToastView: UIView,
                       ViewLoadable {
    
    static var name = Constants.toastView
    static var identifier = Constants.toastView
    
    @IBOutlet private weak var messageLabel: UILabel!

}

// MARK: - Exposed Helpers
extension ToastView {
    
    func setMessage(_ message: String?) {
        messageLabel.text = message
    }
   
}
