//
//  MoviesApiConstructor.swift
//  MDEV1001-M2023-UIForAPIData
//
//  Created by Abhijit Singh on 20/07/23.
//

import Foundation
import Moya

enum MoviesApiConstructor {
    case movie(id: String)
    case movieSearchResults(query: String, page: Int)
}

// MARK: - TargetType Conformation
extension MoviesApiConstructor: TargetType {
    
    var baseURL: URL {
        switch self {
        case .movie, .movieSearchResults:
            return Constants.baseApiUrl!
        }
    }
    
    var path: String {
        switch self {
        case .movie, .movieSearchResults:
            return String()
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .movie, .movieSearchResults:
            return .get
        }
    }
    
    var task: Moya.Task {
        var parameters = [String: Any]()
        parameters["apikey"] = Constants.apiKey
        switch self {
        case let .movie(id):
            parameters["i"] = id
            parameters["plot"] = Constants.fullPlotParameter
        case let .movieSearchResults(query, page):
            parameters["s"] = query
            parameters["page"] = page
        }
        return .requestParameters(parameters: parameters, encoding: URLEncoding.default)
    }
    
    var headers: [String : String]? {
        switch self {
        case .movie, .movieSearchResults:
            return Constants.commonApiHeaders
        }
    }
    
}
