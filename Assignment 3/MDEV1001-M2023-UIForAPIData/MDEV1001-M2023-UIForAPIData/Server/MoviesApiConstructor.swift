//
//  MoviesApiConstructor.swift
//  MDEV1001-M2023-UIForAPIData
//
//  Created by Abhijit Singh on 20/07/23.
//

import Foundation
import Moya

enum MoviesApiConstructor {
    case movieSearchResults(query: String?)
}

// MARK: - TargetType Conformation
extension MoviesApiConstructor: TargetType {
    
    var baseURL: URL {
        switch self {
        case .movieSearchResults:
            return Constants.baseApiURL!
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
        case let .movieSearchResults(query):
            var parameters = [String: Any]()
            parameters["apikey"] = Constants.apiKey
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
