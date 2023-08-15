//
//  PostersListCellViewModel.swift
//  MDEV1001-M2023-Firebase
//
//  Created by Abhijit Singh on 15/08/23.
//

import Foundation

protocol PostersListCellListener: AnyObject {
    func newPosterSelected(_ posterUrl: URL?)
    func oldPosterDeselected()
}

protocol PostersListCellPresenter: AnyObject {
    func updatePoster(from currentIndexPath: IndexPath, to newIndexPath: IndexPath)
    func reloadItems(at indexPaths: [IndexPath])
}

protocol PostersListCellViewModelable: CellViewModelable {
    var numberOfPosters: Int { get }
    var presenter: PostersListCellPresenter? { get set }
    func getCellViewModel(at indexPath: IndexPath) -> PosterCellViewModelable?
    func didSelectPoster(at indexPath: IndexPath)
}

final class PostersListCellViewModel: PostersListCellViewModelable {
    
    private let posters: [URL?]
    private var isSelectedDict: [URL?: Bool]
    private weak var listener: PostersListCellListener?
    
    weak var presenter: PostersListCellPresenter?
    
    init(posters: [URL?], currentPoster: URL?, listener: PostersListCellListener?) {
        self.posters = posters
        self.isSelectedDict = [:]
        self.listener = listener
        setup(with: currentPoster)
    }
    
}

// MARK: - Exposed Helpers
extension PostersListCellViewModel {
    
    var numberOfPosters: Int {
        return posters.count
    }
    
    func getCellViewModel(at indexPath: IndexPath) -> PosterCellViewModelable? {
        guard let poster = posters[safe: indexPath.item],
              let isSelected = isSelectedDict[poster] else { return nil }
        return PosterCellViewModel(posterUrl: poster, isSelected: isSelected)
    }
    
    func didSelectPoster(at indexPath: IndexPath) {
        guard let newPoster = posters[safe: indexPath.item] else { return }
        if let currentPoster = isSelectedDict.first(where: { $0.value })?.key,
           let index = posters.firstIndex(of: currentPoster) {
            // Poster is available for the movie
            isSelectedDict[currentPoster] = false
            let currentIndexPath = IndexPath(item: index, section: 0)
            guard newPoster != currentPoster else {
                // Deselect the assigned poster
                presenter?.reloadItems(at: [currentIndexPath])
                listener?.oldPosterDeselected()
                return
            }
            isSelectedDict[newPoster] = true
            presenter?.updatePoster(from: currentIndexPath, to: indexPath)
        } else {
            // Poster is unavailable for the movie
            isSelectedDict[newPoster] = true
            presenter?.reloadItems(at: [indexPath])
        }
        listener?.newPosterSelected(newPoster)
    }
    
}

// MARK: - Private Helpers
private extension PostersListCellViewModel {
    
    func setup(with currentPoster: URL?) {
        // Initialize isSelectedDict based on currently selected poster
        posters.forEach { url in
            isSelectedDict[url] = url == currentPoster
        }
    }
    
}