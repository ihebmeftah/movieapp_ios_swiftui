//
//  TMDBConfig.swift
//  projectswift
//
//  Created by Maalej Ahmed on 24/11/2025.
//

import Foundation

struct TMDBConfig {
    static let apiKey = "66a1973a8db92144f585e27f1c7ce739"
    static let baseUrl = "https://api.themoviedb.org/3"
    static let imageBaseUrl = "https://image.tmdb.org/t/p/w500"
    
    enum Endpoint {
        case upcoming
        case topRated
        case trending
        case movieDetails(id: Int)
        case movieCredits(id: Int)
        
        var path: String {
            switch self {
            case .upcoming:
                return "/movie/upcoming"
            case .topRated:
                return "/movie/top_rated"
            case .trending:
                return "/trending/movie/day"
            case .movieDetails(let id):
                return "/movie/\(id)"
            case .movieCredits(let id):
                return "/movie/\(id)/credits"
            }
        }
        
        var url: URL? {
            var components = URLComponents(string: TMDBConfig.baseUrl + path)
            components?.queryItems = [
                URLQueryItem(name: "api_key", value: TMDBConfig.apiKey),
                URLQueryItem(name: "language", value: "en-US")
            ]
            return components?.url
        }
    }
    
    static func imageURL(for path: String?) -> URL? {
        guard let path = path else { return nil }
        return URL(string: imageBaseUrl + path)
    }
}
