//
//  TMDBService.swift
//  projectswift
//
//  Created by Maalej Ahmed on 24/11/2025.
//

import Foundation

enum TMDBError: Error {
    case invalidURL
    case networkError(Error)
    case decodingError(Error)
    case invalidResponse
    case serverError(Int)
}

class TMDBService {
    static let shared = TMDBService()
    
    private init() {}
    
    private func fetch<T: Decodable>(from url: URL?) async throws -> T {
        guard let url = url else {
            throw TMDBError.invalidURL
        }
        
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw TMDBError.invalidResponse
            }
            
            guard (200...299).contains(httpResponse.statusCode) else {
                throw TMDBError.serverError(httpResponse.statusCode)
            }
            
            do {
                let decoded = try JSONDecoder().decode(T.self, from: data)
                return decoded
            } catch {
                throw TMDBError.decodingError(error)
            }
        } catch let error as TMDBError {
            throw error
        } catch {
            throw TMDBError.networkError(error)
        }
    }
    
    // MARK: - Movie Lists
    
    func fetchUpcomingMovies() async throws -> [TMDBMovie] {
        let response: MoviesResponse = try await fetch(from: TMDBConfig.Endpoint.upcoming.url)
        return response.results
    }
    
    func fetchTopRatedMovies() async throws -> [TMDBMovie] {
        let response: MoviesResponse = try await fetch(from: TMDBConfig.Endpoint.topRated.url)
        return response.results
    }
    
    func fetchTrendingMovies() async throws -> [TMDBMovie] {
        let response: MoviesResponse = try await fetch(from: TMDBConfig.Endpoint.trending.url)
        return response.results
    }
    
    // MARK: - Movie Details
    
    func fetchMovieDetails(id: Int) async throws -> MovieDetails {
        try await fetch(from: TMDBConfig.Endpoint.movieDetails(id: id).url)
    }
    
    func fetchMovieCredits(id: Int) async throws -> MovieCredits {
        try await fetch(from: TMDBConfig.Endpoint.movieCredits(id: id).url)
    }
}
