//
//  EmptyCollectionViewCell.swift
//  MDEV1001-M2023-UIForAPIData
//
//  Created by Abhijit Singh on 21/07/23.
//

import UIKit

final class EmptyCollectionViewCell: UICollectionViewCell,
                                     ViewLoadable {
    
    static let name = Constants.emptyCollectionViewCell
    static let identifier = Constants.emptyCollectionViewCell
    
    @IBOutlet private weak var emptyImageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var messageLabel: UILabel!

}

// MARK: - Exposed Helpers
extension EmptyCollectionViewCell {
    
    func configure(with viewModel: EmptyCellViewModelable) {
        emptyImageView.image = viewModel.emptyImage?
            .withTintColor(Color.label.shade)
        titleLabel.text = viewModel.title
        messageLabel.text = viewModel.message
    }
    
    static func calculateHeight(with viewModel: EmptyCellViewModelable, width: CGFloat) -> CGFloat {
        let verticalSpacing: CGFloat = 50
        let emptyImageViewHeight = width * 0.35
        let titleLabelHeight = viewModel.title.calculate(
            .height(constrainedWidth: width - 2 * 40), // Horizontal inset
            with: .systemFont(ofSize: 18, weight: .semibold)
        )
        let messageLabelHeight = viewModel.message.calculate(
            .height(constrainedWidth: width - 2 * 40),
            with: .systemFont(ofSize: 16, weight: .medium)
        )
        return verticalSpacing
            + emptyImageViewHeight
            + titleLabelHeight
            + messageLabelHeight
    }
    
}
