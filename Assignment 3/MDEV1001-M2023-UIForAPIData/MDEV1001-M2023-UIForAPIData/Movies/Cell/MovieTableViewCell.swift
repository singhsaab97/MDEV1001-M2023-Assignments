//
//  MovieTableViewCell.swift
//  MDEV1001-M2023-UIForAPIData
//
//  Created by Abhijit Singh on 20/07/23.
//

import UIKit
import SDWebImage

final class MovieTableViewCell: UITableViewCell,
                                ViewLoadable {
    
    static let name = Constants.movieCellName
    static let identifier = Constants.movieCellName
    
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var genresLabel: UILabel!
    @IBOutlet private weak var yearContainerView: UIView!
    @IBOutlet private weak var yearLabel: UILabel!
    @IBOutlet private weak var contentRatingContainerView: UIView!
    @IBOutlet private weak var contentRatingLabel: UILabel!
    @IBOutlet private weak var ratingContainerView: UIView!
    @IBOutlet private weak var ratingImageView: UIImageView!
    @IBOutlet private weak var ratingLabel: UILabel!
    @IBOutlet private weak var durationContainerView: UIView!
    @IBOutlet private weak var durationImageView: UIImageView!
    @IBOutlet private weak var durationLabel: UILabel!

    override func layoutSubviews() {
        super.layoutSubviews()
        setContainerViewsCornerRadius()
    }

}

// MARK: - Exposed Helpers
extension MovieTableViewCell {
    
    func configure(with viewModel: MovieCellViewModelable) {
        nameLabel.text = viewModel.movie.title
        genresLabel.text = viewModel.movie.genre
        yearLabel.text = viewModel.movie.year
        contentRatingLabel.text = viewModel.movie.rated
        ratingImageView.image = viewModel.ratingImage
        ratingLabel.text = viewModel.movie.rating
        durationImageView.image = viewModel.durationImage?.withTintColor(Color.label.shade)
        durationLabel.text = viewModel.movie.duration
    }
    
}

// MARK: - Private Helpers
private extension MovieTableViewCell {
    
    func setContainerViewsCornerRadius() {
        yearContainerView.layer.cornerRadius = min(
            yearContainerView.bounds.width,
            yearContainerView.bounds.height
        ) / 2
        contentRatingContainerView.layer.cornerRadius = min(
            contentRatingContainerView.bounds.width,
            contentRatingContainerView.bounds.height
        ) / 2
        ratingContainerView.layer.cornerRadius = min(
            ratingContainerView.bounds.width,
            ratingContainerView.bounds.height
        ) / 2
        durationContainerView.layer.cornerRadius = min(
            durationContainerView.bounds.width,
            durationContainerView.bounds.height
        ) / 2
    }
    
}
