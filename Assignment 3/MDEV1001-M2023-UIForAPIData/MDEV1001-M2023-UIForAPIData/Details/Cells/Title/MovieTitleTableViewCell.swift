//
//  MovieTitleTableViewCell.swift
//  MDEV1001-M2023-UIForAPIData
//
//  Created by Abhijit Singh on 21/07/23.
//

import UIKit

final class MovieTitleTableViewCell: UITableViewCell,
                                     ViewLoadable {
    
    static let name = Constants.movieTitleTableViewCell
    static let identifier = Constants.movieTitleTableViewCell
    
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var releaseDateLabel: UILabel!
    
}

// MARK: - Exposed Helpers
extension MovieTitleTableViewCell {
    
    func configure(with viewModel: MovieTitleCellViewModelable) {
        titleLabel.text = viewModel.title
        releaseDateLabel.text = viewModel.releaseDate
    }
    
}
