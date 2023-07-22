//
//  Movie.swift
//  MDEV1001-M2023-UIForAPIData
//
//  Created by Abhijit Singh on 20/07/23.
//

import Foundation

enum MovieType: String, Codable {
    case movie
    case series
    case episode
}

struct Movie: Codable {
    let id: String?
    let title: String?
    let year: String?
    let rated: String?
    let released: String?
    let duration: String?
    let genre: String?
    let director: String?
    let writer: String?
    let actors: String?
    let summary: String?
    let language: String?
    let country: String?
    let awards: String?
    let rating: String?
    let poster: String?
    let type: MovieType?
    
    var posterUrl: URL? {
        guard let poster = poster else { return nil }
        return URL(string: poster)
    }
    
    private enum CodingKeys: String, CodingKey {
        case id = "imdbID"
        case title = "Title"
        case year = "Year"
        case rated = "Rated"
        case released = "Released"
        case duration = "Runtime"
        case genre = "Genre"
        case director = "Director"
        case writer = "Writer"
        case actors = "Actors"
        case summary = "Plot"
        case language = "Language"
        case country = "Country"
        case awards = "Awards"
        case rating = "imdbRating"
        case poster = "Poster"
        case type = "Type"
    }
    
}
