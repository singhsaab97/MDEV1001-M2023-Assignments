//
//  MoviesDataHandler.swift
//  MDEV1001-M2023-Firebase
//
//  Created by Abhijit Singh on 14/08/23.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

typealias MoviesFetchCompletion = (_ movies: [Movie], _ error: String?) -> Void
typealias MovieDefaultCompletion = (_ error: String?) -> Void

final class MoviesDataHandler {
    
    static let instance = MoviesDataHandler()
    
    private let collection: CollectionReference
        
    private init() {
        self.collection = Firestore.firestore().collection(Constants.moviesCollectionName)
    }
    
}

// MARK: - Exposed Helpers
extension MoviesDataHandler {
    
    func fetchMovies(completion: @escaping MoviesFetchCompletion) {
        collection.getDocuments { (snapshot, error) in
            if let error = error {
                completion([], error.localizedDescription)
            } else if let documents = snapshot?.documents {
                var movies = [Movie]()
                documents.forEach { document in
                    do {
                        var movie = try Firestore.Decoder().decode(
                            Movie.self,
                            from: document.data()
                        )
                        // Don't forget this necessary step
                        movie.documentId = document.documentID
                        movies.append(movie)
                    } catch {
                        completion([], error.localizedDescription)
                    }
                }
                completion(movies, nil)
            }
        }
    }
    
    func addMovie(_ movie: Movie, completion: @escaping MovieDefaultCompletion) {
        do {
            try collection.addDocument(from: movie) { error in
                completion(error?.localizedDescription)
            }
        } catch {
            completion(error.localizedDescription)
        }
    }
    
    func updateMovie(at documentId: String, with movie: Movie, completion: @escaping MovieDefaultCompletion) {
        do {
            try collection.document(documentId).setData(from: movie)
            completion(nil)
        } catch {
            completion(error.localizedDescription)
        }
    }
    
    func deleteMovie(at documentId: String, completion: @escaping MovieDefaultCompletion) {
        collection.document(documentId).delete { error in
            completion(error?.localizedDescription)
        }
    }
    
}
