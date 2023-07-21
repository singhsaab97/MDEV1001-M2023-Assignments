//
//  MovieCollectionViewCell.swift
//  MDEV1001-M2023-UIForAPIData
//
//  Created by Abhijit Singh on 20/07/23.
//

import UIKit
import SDWebImage

final class MovieCollectionViewCell: UICollectionViewCell,
                                     ViewLoadable {
    
    static let name = Constants.movieCollectionViewCell
    static let identifier = Constants.movieCollectionViewCell
    
    @IBOutlet private weak var posterImageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var typeAndYearLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }

}

// MARK: - Exposed Helpers
extension MovieCollectionViewCell {
    
    func configure(with viewModel: MovieCellViewModelable) {
        posterImageView.sd_setImage(with: viewModel.posterUrl)
        titleLabel.text = viewModel.title
        typeAndYearLabel.text = viewModel.typeAndYear
    }
    
    static func calculateHeight(with viewModel: MovieCellViewModelable, width: CGFloat) -> CGFloat {
        let verticalSpacing: CGFloat = 16
        let posterImageViewHeight = width / 0.85 // Using aspect ratio
        let titleLabelHeight: CGFloat = 20
        let typeAndYearLabelHeight: CGFloat = 17
        return verticalSpacing
            + posterImageViewHeight
            + titleLabelHeight
            + typeAndYearLabelHeight
    }
    
}

// MARK: - Private Helpers
private extension MovieCollectionViewCell {
    
    func setup() {
        setupPosterImageView()
    }
    
    func setupPosterImageView() {
        posterImageView.backgroundColor = Color.secondaryBackground.shade
        posterImageView.layer.cornerRadius = 16
    }
    
}
