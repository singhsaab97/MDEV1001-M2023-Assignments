//
//  MoviePlotTableViewCell.swift
//  MDEV1001-M2023-UIForAPIData
//
//  Created by Abhijit Singh on 21/07/23.
//

import UIKit

final class MoviePlotTableViewCell: UITableViewCell,
                                    ViewLoadable {

    static let name = Constants.moviePlotTableViewCell
    static let identifier = Constants.moviePlotTableViewCell
    
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var plotLabel: UILabel!
    
}

// MARK: - Exposed Helpers
extension MoviePlotTableViewCell {
    
    func configure(with viewModel: MoviePlotCellViewModelable) {
        titleLabel.text = viewModel.title
        plotLabel.text = viewModel.moviePlot
    }
    
}
