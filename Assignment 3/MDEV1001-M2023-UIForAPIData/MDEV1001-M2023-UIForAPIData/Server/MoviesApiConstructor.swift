//
//  MoviesApiConstructor.swift
//  MDEV1001-M2023-UIForAPIData
//
//  Created by Abhijit Singh on 20/07/23.
//

import Foundation
import Moya

enum MoviesApiConstructor {
    case movieSearchResults(query: String?, page: Int)
}

// MARK: - TargetType Conformation
extension MoviesApiConstructor: TargetType {
    
    var baseURL: URL {
        switch self {
        case .movieSearchResults:
            return Constants.baseApiUrl!
        }
    }
    
    var path: String {
        switch self {
        case .movieSearchResults:
            return String()
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .movieSearchResults:
            return .get
        }
    }
    
    var task: Moya.Task {
        switch self {
        case let .movieSearchResults(query, page):
            var parameters = [String: Any]()
            parameters["apikey"] = Constants.apiKey
            parameters["page"] = page
            if let query = query {
                parameters["s"] = query
            }
            return .requestParameters(parameters: parameters, encoding: URLEncoding.default)
        }
    }
    
    var headers: [String : String]? {
        return Constants.commonApiHeaders
    }
    
}
