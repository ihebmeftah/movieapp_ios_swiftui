//
//  FavoriteView.swift
//  projectswift
//
//  Created by Maalej Ahmed on 24/11/2025.
//

import SwiftUI

struct FavoriteView: View {
    @EnvironmentObject var viewModel: FavoritesViewModel
    @State private var showDeleteAlert = false
    @State private var movieToDelete: TMDBMovie?
    
    var filteredMovies: [TMDBMovie] {
        switch viewModel.selectedFilter {
        case "Recently Added":
            return Array(viewModel.favoriteMovies.prefix(10))
        default:
            return viewModel.favoriteMovies
        }
    }
    
    var body: some View {
        NavigationView {
            if !viewModel.isUserLoggedIn {
                VStack(spacing: 20) {
                    Image(systemName: "person.crop.circle.badge.xmark")
                        .font(.system(size: 60))
                        .foregroundColor(.gray)
                    Text("Please log in to view favorites")
                        .font(.headline)
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .navigationTitle("Favorites")
            } else {
            VStack(spacing: 0) {
                // Filter chips
                if !viewModel.favoriteMovies.isEmpty {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 12) {
                            ForEach(viewModel.filterOptions, id: \.self) { option in
                                Button(action: { viewModel.selectedFilter = option }) {
                                    Text(option)
                                        .font(.subheadline)
                                        .fontWeight(.medium)
                                        .padding(.vertical, 8)
                                        .padding(.horizontal, 16)
                                        .background(
                                            viewModel.selectedFilter == option
                                            ? Color.accentColor
                                            : Color(.systemGray5)
                                        )
                                        .foregroundColor(
                                            viewModel.selectedFilter == option
                                            ? .white
                                            : .primary
                                        )
                                        .cornerRadius(20)
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                    .padding(.vertical, 12)
                    
                    Divider()
                }
                
                // Content
                if viewModel.favoriteMovies.isEmpty {
                    // Empty state
                    VStack(spacing: 20) {
                        Image(systemName: "heart.slash.fill")
                            .font(.system(size: 80))
                            .foregroundStyle(
                                LinearGradient(
                                    colors: [.gray.opacity(0.5), .gray.opacity(0.3)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                        
                        Text("No Favorites Yet")
                            .font(.title2)
                            .fontWeight(.bold)
                        
                        Text("Start adding movies to your favorites\nto see them here")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                            .lineSpacing(4)
                        
                        NavigationLink(destination: MoviesView()) {
                            Text("Browse Movies")
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                                .padding(.horizontal, 32)
                                .padding(.vertical, 12)
                                .background(
                                    LinearGradient(
                                        colors: [.blue, .purple],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                                .cornerRadius(25)
                        }
                        .padding(.top, 8)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    // Movies list
                    ScrollView {
                        LazyVStack(spacing: 16) {
                            ForEach(filteredMovies) { movie in
                                FavoriteMovieRow(
                                    movie: movie,
                                    onDelete: {
                                        movieToDelete = movie
                                        showDeleteAlert = true
                                    }
                                )
                            }
                        }
                        .padding()
                    }
                }
            }
            .navigationTitle("Favorites")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                if !viewModel.favoriteMovies.isEmpty {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Menu {
                            Button(role: .destructive, action: {
                                Task {
                                    await viewModel.clearAllFavorites()
                                }
                            }) {
                                Label("Clear All", systemImage: "trash")
                            }
                        } label: {
                            Image(systemName: "ellipsis.circle")
                        }
                    }
                }
            }
            .alert("Remove from Favorites", isPresented: $showDeleteAlert) {
                Button("Cancel", role: .cancel) {}
                Button("Remove", role: .destructive) {
                    if let movie = movieToDelete {
                        Task {
                            await viewModel.removeFromFavorites(movie)
                        }
                    }
                }
            } message: {
                Text("Are you sure you want to remove this movie from your favorites?")
            }
            .onAppear {
                Task {
                    await viewModel.loadFavorites()
                }
            }
            }
        }
    }
}

struct FavoriteMovieRow: View {
    let movie: TMDBMovie
    let onDelete: () -> Void
    
    var body: some View {
        NavigationLink(destination: TMDBMovieDetailView(movieId: movie.id)) {
            HStack(spacing: 12) {
                // Poster - Use posterURL directly
                if let posterURL = movie.posterURL {
                    AsyncImage(url: posterURL) { phase in
                        switch phase {
                        case .success(let image):
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                        case .failure(_):
                            placeholderImage
                        case .empty:
                            ProgressView()
                        @unknown default:
                            placeholderImage
                        }
                    }
                    .frame(width: 100, height: 150)
                    .cornerRadius(12)
                    .clipped()
                } else {
                    placeholderImage
                        .frame(width: 100, height: 150)
                }
                
                // Movie info
                VStack(alignment: .leading, spacing: 8) {
                    Text(movie.title)
                        .font(.headline)
                        .foregroundColor(.primary)
                        .lineLimit(2)
                    
                    HStack(spacing: 4) {
                        Image(systemName: "star.fill")
                            .font(.caption)
                            .foregroundColor(.yellow)
                        Text(String(format: "%.1f", movie.voteAverage))
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    
                    Text(String(movie.releaseDate.prefix(4)))
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    Text(movie.overview)
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .lineLimit(3)
                        .padding(.top, 4)
                    
                    Spacer()
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                
                // Remove button
                Button(action: onDelete) {
                    Image(systemName: "heart.fill")
                        .font(.title3)
                        .foregroundColor(.red)
                        .frame(width: 44, height: 44)
                }
                .buttonStyle(PlainButtonStyle())
            }
            .padding(12)
            .background(Color(.systemBackground))
            .cornerRadius(12)
            .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    private var placeholderImage: some View {
        RoundedRectangle(cornerRadius: 12)
            .fill(
                LinearGradient(
                    colors: [Color.blue.opacity(0.4), Color.purple.opacity(0.4)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
    }
}

#Preview {
    FavoriteView()
        .environmentObject(FavoritesViewModel())
}
