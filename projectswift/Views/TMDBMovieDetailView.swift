//
//  TMDBMovieDetailView.swift
//  projectswift
//
//  Created by Maalej Ahmed on 24/11/2025.
//

import SwiftUI

struct TMDBMovieDetailView: View {
    let movieId: Int
    @StateObject private var viewModel = MovieDetailViewModel()
    @EnvironmentObject var favoritesViewModel: FavoritesViewModel
    
    private var isFavorite: Bool {
        guard let details = viewModel.movieDetails else { return false }
        let movie = createTMDBMovieFromDetails()
        return favoritesViewModel.isFavorite(movie)
    }
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                if viewModel.isLoading {
                    ProgressView()
                        .frame(width: geometry.size.width, height: geometry.size.height)
                } else if let movieDetails = viewModel.movieDetails {
                    VStack(alignment: .leading, spacing: 0) {
                        // Hero poster section
                        ZStack(alignment: .bottom) {
                            if let url = movieDetails.backdropURL {
                                AsyncImage(url: url) { image in
                                    image
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                } placeholder: {
                                    LinearGradient(
                                        colors: [Color.blue.opacity(0.8), Color.purple.opacity(0.8)],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                }
                                .frame(width: geometry.size.width, height: 400)
                                .clipped()
                            } else {
                                LinearGradient(
                                    colors: [Color.blue.opacity(0.8), Color.purple.opacity(0.8)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                                .frame(width: geometry.size.width, height: 400)
                            }
                            
                            LinearGradient(
                                colors: [Color.clear, Color(.systemBackground)],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                            .frame(width: geometry.size.width, height: 150)
                        }
                        .frame(width: geometry.size.width)
                        .ignoresSafeArea(edges: .top)
                    
                    VStack(alignment: .leading, spacing: 16) {
                        // Title and favorite button
                        HStack(alignment: .top) {
                            VStack(alignment: .leading, spacing: 8) {
                                Text(movieDetails.title)
                                    .font(.system(size: 28, weight: .bold))
                                    .fixedSize(horizontal: false, vertical: true)
                                
                                HStack(spacing: 8) {
                                    Text(String(movieDetails.releaseDate.prefix(4)))
                                        .foregroundColor(.secondary)
                                        .font(.subheadline)
                                    
                                    if !movieDetails.durationFormatted.isEmpty {
                                        Text("•")
                                            .foregroundColor(.secondary)
                                        
                                        Text(movieDetails.durationFormatted)
                                            .foregroundColor(.secondary)
                                            .font(.subheadline)
                                    }
                                    
                                    if let genre = movieDetails.genres.first {
                                        Text("•")
                                            .foregroundColor(.secondary)
                                        
                                        Text(genre.name)
                                            .padding(.horizontal, 10)
                                            .padding(.vertical, 4)
                                            .background(Color.accentColor.opacity(0.2))
                                            .cornerRadius(6)
                                            .font(.caption)
                                    }
                                }
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            
                            Button(action: {
                                Task {
                                    let movie = createTMDBMovieFromDetails()
                                    await favoritesViewModel.toggleFavorite(movie)
                                }
                            }) {
                                Image(systemName: isFavorite ? "heart.fill" : "heart")
                                    .font(.title2)
                                    .foregroundColor(isFavorite ? .red : .gray)
                                    .frame(width: 44, height: 44)
                            }
                            .fixedSize()
                        }
                        
                        // Tagline
                        if let tagline = movieDetails.tagline, !tagline.isEmpty {
                            Text(tagline)
                                .font(.subheadline)
                                .italic()
                                .foregroundColor(.secondary)
                        }
                        
                        // Rating
                        HStack(spacing: 12) {
                            HStack(spacing: 4) {
                                Image(systemName: "star.fill")
                                    .foregroundColor(.yellow)
                                Text(String(format: "%.1f", movieDetails.voteAverage))
                                    .font(.title3)
                                    .bold()
                                Text("/ 10")
                                    .foregroundColor(.secondary)
                            }
                            
                            Divider()
                                .frame(height: 20)
                            
                            HStack(spacing: 4) {
                                Image(systemName: "person.2.fill")
                                    .foregroundColor(.secondary)
                                Text("\(movieDetails.voteCount.formatted()) votes")
                                    .foregroundColor(.secondary)
                                    .font(.subheadline)
                            }
                        }
                        .padding(.vertical, 8)
                        
                        // Action buttons
                        HStack(spacing: 12) {
                            Button(action: {}) {
                                HStack {
                                    Image(systemName: "play.fill")
                                    Text("Play Trailer")
                                        .fontWeight(.semibold)
                                }
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 14)
                                .background(Color.accentColor)
                                .foregroundColor(.white)
                                .cornerRadius(12)
                            }
                            
                            Button(action: {}) {
                                Image(systemName: "square.and.arrow.up")
                                    .font(.title3)
                                    .frame(width: 50, height: 50)
                                    .background(Color(.systemGray5))
                                    .cornerRadius(12)
                            }
                            .fixedSize()
                        }
                        
                        Divider()
                            .padding(.vertical, 8)
                        
                        // Description
                        if !movieDetails.overview.isEmpty {
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Synopsis")
                                    .font(.title3)
                                    .bold()
                                
                                Text(movieDetails.overview)
                                    .foregroundColor(.secondary)
                                    .lineSpacing(4)
                            }
                            
                            Divider()
                                .padding(.vertical, 8)
                        }
                        
                        // Genres
                        if !movieDetails.genres.isEmpty {
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Genres")
                                    .font(.headline)
                                
                                ScrollView(.horizontal, showsIndicators: false) {
                                    HStack(spacing: 8) {
                                        ForEach(movieDetails.genres) { genre in
                                            Text(genre.name)
                                                .font(.subheadline)
                                                .padding(.horizontal, 12)
                                                .padding(.vertical, 6)
                                                .background(Color.accentColor.opacity(0.2))
                                                .cornerRadius(16)
                                        }
                                    }
                                }
                            }
                            
                            Divider()
                                .padding(.vertical, 8)
                        }
                        
                        // Director
                        if let director = viewModel.director {
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Director")
                                    .font(.headline)
                                
                                HStack {
                                    if let url = TMDBConfig.imageURL(for: director.profilePath) {
                                        AsyncImage(url: url) { image in
                                            image
                                                .resizable()
                                                .aspectRatio(contentMode: .fill)
                                        } placeholder: {
                                            Color.accentColor.opacity(0.3)
                                                .overlay(
                                                    Image(systemName: "person.fill")
                                                        .foregroundColor(.accentColor)
                                                )
                                        }
                                        .frame(width: 50, height: 50)
                                        .clipShape(Circle())
                                    } else {
                                        Circle()
                                            .fill(Color.accentColor.opacity(0.3))
                                            .frame(width: 50, height: 50)
                                            .overlay(
                                                Image(systemName: "person.fill")
                                                    .foregroundColor(.accentColor)
                                            )
                                    }
                                    
                                    VStack(alignment: .leading) {
                                        Text(director.name)
                                            .font(.subheadline)
                                            .fontWeight(.semibold)
                                        Text("Director")
                                            .font(.caption)
                                            .foregroundColor(.secondary)
                                    }
                                    
                                    Spacer()
                                }
                            }
                            
                            Divider()
                                .padding(.vertical, 8)
                        }
                        
                        // Cast
                        if !viewModel.mainCast.isEmpty {
                            VStack(alignment: .leading, spacing: 12) {
                                Text("Cast")
                                    .font(.title3)
                                    .bold()
                                
                                ScrollView(.horizontal, showsIndicators: false) {
                                    HStack(spacing: 16) {
                                        ForEach(viewModel.mainCast) { actor in
                                            VStack(spacing: 8) {
                                                if let url = actor.profileURL {
                                                    AsyncImage(url: url) { image in
                                                        image
                                                            .resizable()
                                                            .aspectRatio(contentMode: .fill)
                                                    } placeholder: {
                                                        Circle()
                                                            .fill(
                                                                LinearGradient(
                                                                    colors: [Color.blue.opacity(0.4), Color.purple.opacity(0.4)],
                                                                    startPoint: .topLeading,
                                                                    endPoint: .bottomTrailing
                                                                )
                                                            )
                                                            .overlay(
                                                                Image(systemName: "person.fill")
                                                                    .font(.title2)
                                                                    .foregroundColor(.white)
                                                            )
                                                    }
                                                    .frame(width: 80, height: 80)
                                                    .clipShape(Circle())
                                                } else {
                                                    Circle()
                                                        .fill(
                                                            LinearGradient(
                                                                colors: [Color.blue.opacity(0.4), Color.purple.opacity(0.4)],
                                                                startPoint: .topLeading,
                                                                endPoint: .bottomTrailing
                                                            )
                                                        )
                                                        .frame(width: 80, height: 80)
                                                        .overlay(
                                                            Image(systemName: "person.fill")
                                                                .font(.title2)
                                                                .foregroundColor(.white)
                                                        )
                                                }
                                                
                                                Text(actor.name)
                                                    .font(.caption)
                                                    .fontWeight(.medium)
                                                    .lineLimit(2)
                                                    .multilineTextAlignment(.center)
                                                    .frame(width: 80)
                                                
                                                Text(actor.character)
                                                    .font(.caption2)
                                                    .foregroundColor(.secondary)
                                                    .lineLimit(2)
                                                    .multilineTextAlignment(.center)
                                                    .frame(width: 80)
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                    .padding()
                }
            } else if let error = viewModel.errorMessage {
                VStack(spacing: 16) {
                    Image(systemName: "exclamationmark.triangle")
                        .font(.system(size: 60))
                        .foregroundColor(.red)
                    Text("Error")
                        .font(.title3)
                    Text(error)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                }
                .padding()
                .frame(width: geometry.size.width, height: geometry.size.height)
            }
        }
        .ignoresSafeArea(edges: .top)
        }
        .navigationBarTitleDisplayMode(.inline)
        .task {
            await viewModel.loadMovieDetails(id: movieId)
        }
    }
    
    private func createTMDBMovieFromDetails() -> TMDBMovie {
        guard let details = viewModel.movieDetails else {
            return TMDBMovie(
                adult: false,
                backdropPath: nil,
                genreIds: [],
                id: movieId,
                originalLanguage: "",
                originalTitle: "",
                overview: "",
                popularity: 0,
                posterPath: nil,
                releaseDate: "",
                title: "",
                video: false,
                voteAverage: 0,
                voteCount: 0
            )
        }
        
        return TMDBMovie(
            adult: false,
            backdropPath: details.backdropPath,
            genreIds: details.genres.map { $0.id },
            id: details.id,
            originalLanguage: "",
            originalTitle: details.title,
            overview: details.overview,
            popularity: 0,
            posterPath: details.posterPath,
            releaseDate: details.releaseDate,
            title: details.title,
            video: false,
            voteAverage: details.voteAverage,
            voteCount: details.voteCount
        )
    }
}
