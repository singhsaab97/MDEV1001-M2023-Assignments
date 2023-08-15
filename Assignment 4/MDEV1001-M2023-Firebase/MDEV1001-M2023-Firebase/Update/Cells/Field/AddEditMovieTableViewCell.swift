//
//  AddEditMovieTableViewCell.swift
//  MDEV1001-M2023-Firebase
//
//  Created by Abhijit Singh on 15/08/23.
//

import UIKit

final class AddEditMovieTableViewCell: UITableViewCell,
                                       ViewLoadable {
    
    static var name = Constants.addEditMovieCell
    static var identifier = Constants.addEditMovieCell
    
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
