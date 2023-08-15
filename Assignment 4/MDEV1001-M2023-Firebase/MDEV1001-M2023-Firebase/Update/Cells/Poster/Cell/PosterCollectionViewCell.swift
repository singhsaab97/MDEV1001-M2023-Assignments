//
//  PosterCollectionViewCell.swift
//  MDEV1001-M2023-Firebase
//
//  Created by Abhijit Singh on 15/08/23.
//

import UIKit
import SDWebImage

final class PosterCollectionViewCell: UICollectionViewCell,
                                      ViewLoadable {
    
    static var name = Constants.posterCell
    static var identifier = Constants.posterCell
    
    @IBOutlet private weak var posterImageView: UIImageView!
    @IBOutlet private weak var highlightingView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
}

// MARK: - Exposed Helpers
extension PosterCollectionViewCell {
    
    func configure(with viewModel: PosterCellViewModelable) {
        let color = viewModel.isSelected ? UIColor.systemBlue : UIColor.clear
        layer.borderColor = color.cgColor
        highlightingView.backgroundColor = color
        posterImageView.sd_setImage(with: viewModel.posterUrl)
    }
    
}

// MARK: - Private Helpers
private extension PosterCollectionViewCell {
    
    func setup() {
        layer.cornerRadius = 12
        layer.borderWidth = 3
        highlightingView.alpha = 0.3
    }
    
}
