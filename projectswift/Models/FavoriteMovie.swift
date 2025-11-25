//
//  FavoriteMovie.swift
//  projectswift
//
//  Created by Maalej Ahmed on 24/11/2025.
//

import Foundation
import FirebaseFirestore

struct FavoriteMovie: Codable, Identifiable {
    @DocumentID var id: String?
    let userId: String
    let movieId: Int
    let adult: Bool
    let backdropPath: String?
    let backdropURL: String?
    let genreIds: [Int]
    let originalLanguage: String
    let originalTitle: String
    let overview: String
    let popularity: Double
    let posterPath: String?
    let posterURL: String?
    let releaseDate: String
    let title: String
    let video: Bool
    let voteAverage: Double
    let voteCount: Int
    let addedAt: Date
    
    enum CodingKeys: String, CodingKey {
        case id, userId, movieId, adult, backdropPath, backdropURL, genreIds
        case originalLanguage, originalTitle, overview, popularity
        case posterPath, posterURL, releaseDate, title, video, voteAverage, voteCount, addedAt
    }
    
    init(from movie: TMDBMovie, userId: String) {
        self.userId = userId
        self.movieId = movie.id
        self.adult = movie.adult
        self.backdropPath = movie.backdropPath
        self.backdropURL = movie.backdropURL?.absoluteString
        self.genreIds = movie.genreIds
        self.originalLanguage = movie.originalLanguage
        self.originalTitle = movie.originalTitle
        self.overview = movie.overview
        self.popularity = movie.popularity
        self.posterPath = movie.posterPath
        self.posterURL = movie.posterURL?.absoluteString
        self.releaseDate = movie.releaseDate
        self.title = movie.title
        self.video = movie.video
        self.voteAverage = movie.voteAverage
        self.voteCount = movie.voteCount
        self.addedAt = Date()
    }
    
    var toTMDBMovie: TMDBMovie {
        return TMDBMovie(
            adult: adult,
            backdropPath: posterURL != nil ? nil : backdropPath,
            genreIds: genreIds,
            id: movieId,
            originalLanguage: originalLanguage,
            originalTitle: originalTitle,
            overview: overview,
            popularity: popularity,
            posterPath: posterURL != nil ? nil : posterPath,
            releaseDate: releaseDate,
            title: title,
            video: video,
            voteAverage: voteAverage,
            voteCount: voteCount
        )
    }
}

// Extension to TMDBMovie to use stored URLs
extension TMDBMovie {
    var storedPosterURL: URL? {
        // This will be set from FavoriteMovie
        return posterURL
    }
    
    var storedBackdropURL: URL? {
        return backdropURL
    }
}
