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
    case error(Error)
}

final class MoviesDataHandler {
    
    static let shared = MoviesDataHandler()
    
    private lazy var apiClient: MoyaProvider<MoviesApiConstructor> = {
        return MoyaProvider<MoviesApiConstructor>()
    }()
    
    private init() {}
    
}

// MARK: - Exposed Helpers
extension MoviesDataHandler {
    
    func fetchMoviesList(completion: @escaping MoviesDataFetchCompletion) {
        completion(.loading)
        guard let fileURL = Bundle.main.url(forResource: "DefaultMovies", withExtension: "json"),
              let data = try? Data(contentsOf: fileURL),
              let models = try? JSONDecoder().decode([Movie].self, from: data) else { return }
        completion(.data(models))
    }
    
    func fetchMovieSearchResults(with query: String, completion: @escaping MoviesDataFetchCompletion) {
        completion(.loading)
        apiClient.request(.movieSearchResults(query: query)) { result in
            switch result {
            case let .success(response):
                do {
                    let models = try JSONDecoder().decode([Movie].self, from: response.data)
                    completion(.data(models))
                } catch {
                    completion(.error(error))
                }
            case let .failure(error):
                completion(.error(error))
            }
        }
    }
    
}
