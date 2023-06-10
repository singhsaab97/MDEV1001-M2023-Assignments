//
//  MovieTableViewCell.swift
//  MDEV1001-M2023-UIForLocalDataAssignment
//
//  Created by Abhijit Singh on 08/06/23.
//  Copyright © 2023 Abhijit Singh. All rights reserved.
//

import UIKit

final class MovieTableViewCell: UITableViewCell,
                                ViewLoadable {
    
    static var name = Constants.movieCellName
    static var identifier = Constants.movieCellIdentifier
        
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
        ratingLabel.text = String(viewModel.movie.criticsrating)
        titleLabel.text = viewModel.movie.title
        studioLabel.text = viewModel.movie.studio
        if let poster = viewModel.movie.poster {
            posterImageView.image = UIImage(named: poster)
            posterImageView.isHidden = false
        } else {
            posterImageView.isHidden = true
        }
        let description = viewModel.movie.shortdescription
        descriptionLabel.text = description
        descriptionLabel.isHidden = description == nil || !viewModel.isExpanded
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
