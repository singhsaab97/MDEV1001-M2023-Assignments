//
//  MovieStackTableViewCell.swift
//  MDEV1001-M2023-UIForAPIData
//
//  Created by Abhijit Singh on 21/07/23.
//

import UIKit

final class MovieStackTableViewCell: UITableViewCell,
                                     ViewLoadable {

    static let name = Constants.movieStackTableViewCell
    static let identifier = Constants.movieStackTableViewCell
    
    @IBOutlet private var containerViews: [UIView]!
    @IBOutlet private weak var genreImageView: UIImageView!
    @IBOutlet private weak var genreTitleLabel: UILabel!
    @IBOutlet private weak var genreLabel: UILabel!
    @IBOutlet private weak var durationImageView: UIImageView!
    @IBOutlet private weak var durationTitleLabel: UILabel!
    @IBOutlet private weak var durationLabel: UILabel!
    @IBOutlet private weak var ratingImageView: UIImageView!
    @IBOutlet private weak var ratingTitleLabel: UILabel!
    @IBOutlet private weak var ratingLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
}

// MARK: - Exposed Helpers
extension MovieStackTableViewCell {
    
    func configure(with viewModel: MovieStackCellViewModelable) {
        genreImageView.image = viewModel.genreImage?.withTintColor(Color.label.shade)
        genreTitleLabel.text = viewModel.genreTitle
        genreLabel.text = viewModel.movieGenre
        durationImageView.image = viewModel.durationImage?.withTintColor(Color.label.shade)
        durationTitleLabel.text = viewModel.durationTitle
        durationLabel.text = viewModel.movieDuration
        ratingImageView.image = viewModel.ratingImage?.withTintColor(Color.label.shade)
        ratingTitleLabel.text = viewModel.ratingTitle
        ratingLabel.text = viewModel.movieRating
    }
    
}

// MARK: - Private Helpers
private extension MovieStackTableViewCell {
    
    func setup() {
        setupContainerView()
    }
    
    func setupContainerView() {
        containerViews.forEach { view in
            view.layer.cornerRadius = 16
            view.layer.borderColor = Color.secondaryBackground.shade.cgColor
            view.layer.borderWidth = 2
        }
    }
    
}
