//
//  MovieDetailViewModel.swift
//  projectswift
//
//  Created by Maalej Ahmed on 24/11/2025.
//

import Foundation
import SwiftUI

@MainActor
class MovieDetailViewModel: ObservableObject {
    @Published var movieDetails: MovieDetails?
    @Published var credits: MovieCredits?
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let service = TMDBService.shared
    
    func loadMovieDetails(id: Int) async {
        isLoading = true
        errorMessage = nil
        
        async let details = service.fetchMovieDetails(id: id)
        async let movieCredits = service.fetchMovieCredits(id: id)
        
        do {
            let (detailsResult, creditsResult) = try await (details, movieCredits)
            self.movieDetails = detailsResult
            self.credits = creditsResult
        } catch {
            self.errorMessage = "Failed to load movie details: \(error.localizedDescription)"
            print("Error loading movie details: \(error)")
        }
        
        isLoading = false
    }
    
    var director: CrewMember? {
        credits?.crew.first { $0.job == "Director" }
    }
    
    var mainCast: [CastMember] {
        Array((credits?.cast.prefix(10) ?? []))
    }
}
