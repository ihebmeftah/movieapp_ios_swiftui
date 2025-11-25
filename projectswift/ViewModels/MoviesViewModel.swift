//
//  MoviesViewModel.swift
//  projectswift
//
//  Created by Maalej Ahmed on 24/11/2025.
//

import Foundation
import SwiftUI

@MainActor
class MoviesViewModel: ObservableObject {
    @Published var upcomingMovies: [TMDBMovie] = []
    @Published var topRatedMovies: [TMDBMovie] = []
    @Published var trendingMovies: [TMDBMovie] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let service = TMDBService.shared
    
    func loadAllMovies() async {
        isLoading = true
        errorMessage = nil
        
        async let upcoming = service.fetchUpcomingMovies()
        async let topRated = service.fetchTopRatedMovies()
        async let trending = service.fetchTrendingMovies()
        
        do {
            let (upcomingResult, topRatedResult, trendingResult) = try await (upcoming, topRated, trending)
            self.upcomingMovies = upcomingResult
            self.topRatedMovies = topRatedResult
            self.trendingMovies = trendingResult
        } catch {
            self.errorMessage = "Failed to load movies: \(error.localizedDescription)"
            print("Error loading movies: \(error)")
        }
        
        isLoading = false
    }
    
    func loadUpcoming() async {
        do {
            upcomingMovies = try await service.fetchUpcomingMovies()
        } catch {
            errorMessage = "Failed to load upcoming movies"
        }
    }
    
    func loadTopRated() async {
        do {
            topRatedMovies = try await service.fetchTopRatedMovies()
        } catch {
            errorMessage = "Failed to load top rated movies"
        }
    }
    
    func loadTrending() async {
        do {
            trendingMovies = try await service.fetchTrendingMovies()
        } catch {
            errorMessage = "Failed to load trending movies"
        }
    }
    
    var allMovies: [TMDBMovie] {
        upcomingMovies + topRatedMovies + trendingMovies
    }
}
