//
//  AddEditMovieTableViewCell.swift
//  MDEV1001-M2023-UIForLocalDataAssignment
//
//  Created by Abhijit Singh on 09/06/23.
//  Copyright © 2023 Abhijit Singh. All rights reserved.
//

import UIKit

final class AddEditMovieTableViewCell: UITableViewCell,
                                       ViewLoadable {
    
    static var name = Constants.addEditMovieCellName
    static var identifier = Constants.addEditMovieCellIdentifier
    
    @IBOutlet private weak var textField: UITextField!
    
    private var viewModel: AddEditMovieCellViewModelable?

}

// MARK: - Exposed Helpers
extension AddEditMovieTableViewCell {
    
    func configure(with viewModel: AddEditMovieCellViewModelable) {
        self.viewModel = viewModel
        textField.attributedPlaceholder = NSAttributedString(
            string: viewModel.field.placeholder,
            attributes: [
                .foregroundColor: UIColor.secondaryLabel,
                .font: Constants.placeholderFont
            ]
        )
        textField.keyboardType = viewModel.field.keyboardType
        textField.text = viewModel.fieldText
    }
    
}

// MARK: - UITextFieldDelegate Methods
extension AddEditMovieTableViewCell: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return viewModel?.didTypeText(textField.text, newText: string) ?? false
    }
    
}
