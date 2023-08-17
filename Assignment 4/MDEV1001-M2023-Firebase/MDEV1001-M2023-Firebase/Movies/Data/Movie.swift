//
//  Movie.swift
//  MDEV1001-M2023-Firebase
//
//  Created by Abhijit Singh on 14/08/23.
//

import Foundation

struct Movie: Codable, Equatable {
    var id: Int
    var documentId: String?
    var title: String
    var studio: String
    var genres: [String]
    var directors: [String]
    var writers: [String]
    var actors: [String]
    var year: Int
    var runtime: Int
    var summary: String?
    var contentRating: String
    var criticsRating: Double
    var poster: String?
    var isExpanded: Bool = false
    
    var posterUrl: URL? {
        guard let poster = poster else { return nil }
        return URL(string: poster)
    }
    
    private enum CodingKeys: String, CodingKey {
        case id
        case title
        case studio
        case genres
        case directors
        case writers
        case actors
        case year
        case runtime = "length"
        case summary = "short_description"
        case contentRating = "mpa_rating"
        case criticsRating = "critics_rating"
        case poster
    }
    
}

// MARK: - Exposed Helpers
extension Movie {
    
    static func createObject(with id: Int, documentId: String) -> Movie {
        return Movie(
            id: id,
            documentId: documentId,
            title: String(),
            studio: String(),
            genres: [],
            directors: [],
            writers: [],
            actors: [],
            year: 0,
            runtime: 0,
            contentRating: String(),
            criticsRating: .zero
        )
    }
    
}
