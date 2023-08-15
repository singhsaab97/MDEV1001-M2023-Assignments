//
//  PosterCellViewModel.swift
//  MDEV1001-M2023-Firebase
//
//  Created by Abhijit Singh on 15/08/23.
//

import Foundation

protocol PosterCellViewModelable {
    var posterUrl: URL? { get }
    var isSelected: Bool { get }
}

final class PosterCellViewModel: PosterCellViewModelable {
    
    let posterUrl: URL?
    let isSelected: Bool
    
    init(posterUrl: URL?, isSelected: Bool) {
        self.posterUrl = posterUrl
        self.isSelected = isSelected
    }
    
}
