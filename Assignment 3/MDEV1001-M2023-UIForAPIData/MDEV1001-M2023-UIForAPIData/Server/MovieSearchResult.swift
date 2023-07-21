//
//  MovieSearchResult.swift
//  MDEV1001-M2023-UIForAPIData
//
//  Created by Abhijit Singh on 21/07/23.
//

import Foundation

struct MovieSearchResult: Codable {
    let models: [Movie]
    
    private enum CodingKeys: String, CodingKey {
        case models = "Search"
    }
    
}
