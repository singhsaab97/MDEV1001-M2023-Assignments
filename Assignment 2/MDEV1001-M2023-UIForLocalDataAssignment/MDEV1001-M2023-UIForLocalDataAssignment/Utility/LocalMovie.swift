//
//  LocalMovie.swift
//  MDEV1001-M2023-UIForLocalDataAssignment
//
//  Created by Abhijit Singh on 09/06/23.
//  Copyright © 2023 Abhijit Singh. All rights reserved.
//

import Foundation

struct LocalMovie {
    var title: String?
    var studio: String?
    var genres: String?
    var directors: String?
    var writers: String?
    var actors: String?
    var year: Int16?
    var length: Int16?
    var mpaRating: String?
    var criticsRating: Double?
    var description: String?
}

// MARK: - Exposed Helpers
extension LocalMovie {

    static func transform(with movie: Movie) -> LocalMovie {
        return LocalMovie(
            title: movie.title,
            studio: movie.studio,
            genres: movie.genres,
            directors: movie.directors,
            writers: movie.writers,
            actors: movie.actors,
            year: movie.year,
            length: movie.length,
            mpaRating: movie.mparating,
            criticsRating: movie.criticsrating,
            description: movie.shortdescription
        )
    }
    
}
