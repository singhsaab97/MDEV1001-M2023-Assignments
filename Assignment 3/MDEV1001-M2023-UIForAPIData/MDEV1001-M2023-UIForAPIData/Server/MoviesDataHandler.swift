//
//  MoviesDataHandler.swift
//  MDEV1001-M2023-UIForAPIData
//
//  Created by Abhijit Singh on 20/07/23.
//

import Foundation
import Moya

typealias MoviesDataFetchCompletion = (MoviesResultState) -> Void

enum MoviesResultState {
    case loading
    case data([Movie])
    case error(String?)
}

final class MoviesDataHandler {
    
    static let shared = MoviesDataHandler()
    
    private(set) var totalMovies: Int
    
    private lazy var apiClient: MoyaProvider<MoviesApiConstructor> = {
        return MoyaProvider<MoviesApiConstructor>()
    }()
    
    private init() {
        self.totalMovies = 0
    }
    
}

// MARK: - Exposed Helpers
extension MoviesDataHandler {
    
    func fetchMoviesList(completion: @escaping MoviesDataFetchCompletion) {
        completion(.loading)
        guard let fileURL = Bundle.main.url(forResource: Constants.moviesFileName, withExtension: "json"),
              let data = try? Data(contentsOf: fileURL),
              let models = try? JSONDecoder().decode([Movie].self, from: data) else { return }
        completion(.data(models))
    }
    
    func fetchMovieSearchResults(
        for query: String,
        page: Int,
        completion: @escaping MoviesDataFetchCompletion
    ) {
        completion(.loading)
        apiClient.request(.movieSearchResults(query: query, page: page)) { [weak self] result in
            switch result {
            case let .success(response):
                do {
                    let json = try JSONSerialization.jsonObject(
                        with: response.data,
                        options: []
                    ) as? [String: Any]
                    guard let searchResults = json?["Search"] as? [[String: Any]] else {
                        completion(.data([]))
                        completion(.error(json?["Error"] as? String))
                        return
                    }
                    self?.totalMovies = Int(json?["totalResults"] as? String ?? String()) ?? 0
                    let result = try JSONSerialization.data(withJSONObject: searchResults)
                    let models = try JSONDecoder().decode([Movie].self, from: result)
                    completion(.data(models))
                } catch {
                    completion(.error(error.localizedDescription))
                }
            case let .failure(error):
                completion(.error(error.localizedDescription))
            }
        }
    }
    
}
