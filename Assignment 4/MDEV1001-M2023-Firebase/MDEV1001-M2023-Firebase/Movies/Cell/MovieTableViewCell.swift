//
//  MovieTableViewCell.swift
//  MDEV1001-M2023-Firebase
//
//  Created by Abhijit Singh on 14/08/23.
//

import UIKit
import SDWebImage

final class MovieTableViewCell: UITableViewCell,
                                ViewLoadable {
    
    static var name = Constants.movieCell
    static var identifier = Constants.movieCell
        
    @IBOutlet private weak var ratingContainerView: UIView!
    @IBOutlet private weak var ratingLabel: UILabel!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var studioLabel: UILabel!
    @IBOutlet private weak var posterImageView: UIImageView!
    @IBOutlet private weak var descriptionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
}

// MARK: - Exposed Helpers
extension MovieTableViewCell {
    
    func configure(with viewModel: MovieCellViewModelable) {
        ratingContainerView.backgroundColor = viewModel.state.color.withAlphaComponent(0.6)
        ratingContainerView.layer.borderColor = viewModel.state.color.cgColor
        ratingLabel.text = String(viewModel.movie.criticsRating)
        titleLabel.text = viewModel.movie.title
        studioLabel.text = viewModel.movie.studio
        let posterUrl = viewModel.movie.posterUrl
        posterImageView.sd_setImage(with: posterUrl)
        posterImageView.isHidden = posterUrl == nil
        let description = viewModel.movie.summary
        descriptionLabel.text = description
        descriptionLabel.isHidden = description == nil || !viewModel.movie.isExpanded
    }
    
}

// MARK: - Private Helpers
private extension MovieTableViewCell {
    
    func setup() {
        ratingContainerView.layer.cornerRadius = 12
        ratingContainerView.layer.borderWidth = 3
        posterImageView.layer.cornerRadius = 12
    }
    
}

// MARK: - MovieCellViewModel.RatingState Helpers
private extension MovieCellViewModel.RatingState {
    
    var color: UIColor {
        switch self {
        case .good:
            return .systemGreen
        case .okay:
            return .systemYellow
        case .meh:
            return .systemOrange
        case .bad:
            return .systemRed
        case .unknown:
            return .clear
        }
    }
    
}
