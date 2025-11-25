//
//  MoviesView.swift
//  projectswift
//
//  Created by Maalej Ahmed on 24/11/2025.
//

import SwiftUI

struct MoviesView: View {
    @StateObject private var viewModel = MoviesViewModel()
    @State private var searchText = ""
    @State private var selectedSort = "Popular"
    
    let sortOptions = ["Popular", "Top Rated", "Latest", "A-Z"]
    
    // Filtered movies based on search
    var filteredMovies: [TMDBMovie] {
        var movies = viewModel.allMovies
        
        // Filter by search text
        if !searchText.isEmpty {
            movies = movies.filter { $0.title.localizedCaseInsensitiveContains(searchText) }
        }
        
        // Sort movies
        switch selectedSort {
        case "Top Rated":
            movies = movies.sorted { $0.voteAverage > $1.voteAverage }
        case "Latest":
            movies = movies.sorted { $0.releaseDate > $1.releaseDate }
        case "A-Z":
            movies = movies.sorted { $0.title < $1.title }
        default: // Popular
            movies = movies.sorted { $0.popularity > $1.popularity }
        }
        
        return movies
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Search bar
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)
                    
                    TextField("Search movies...", text: $searchText)
                        .textFieldStyle(PlainTextFieldStyle())
                    
                    if !searchText.isEmpty {
                        Button(action: { searchText = "" }) {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(.gray)
                        }
                    }
                }
                .padding(12)
                .background(Color(.systemGray6))
                .cornerRadius(10)
                .padding(.horizontal)
                .padding(.top, 8)
                
                // Filter section
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        // Sort filter
                        Menu {
                            ForEach(sortOptions, id: \.self) { option in
                                Button(action: { selectedSort = option }) {
                                    HStack {
                                        Text(option)
                                        if selectedSort == option {
                                            Image(systemName: "checkmark")
                                        }
                                    }
                                }
                            }
                        } label: {
                            HStack(spacing: 4) {
                                Image(systemName: "arrow.up.arrow.down")
                                    .font(.caption)
                                Text(selectedSort)
                                    .font(.subheadline)
                                Image(systemName: "chevron.down")
                                    .font(.caption2)
                            }
                            .padding(.vertical, 8)
                            .padding(.horizontal, 12)
                            .background(Color.accentColor.opacity(0.15))
                            .cornerRadius(20)
                        }
                        .foregroundColor(.primary)
                        
                        // Reset button
                        if selectedSort != "Popular" {
                            Button(action: {
                                selectedSort = "Popular"
                            }) {
                                HStack(spacing: 4) {
                                    Text("Reset")
                                        .font(.subheadline)
                                    Image(systemName: "arrow.counterclockwise")
                                        .font(.caption)
                                }
                                .padding(.vertical, 8)
                                .padding(.horizontal, 12)
                                .background(Color.red.opacity(0.15))
                                .foregroundColor(.red)
                                .cornerRadius(20)
                            }
                        }
                    }
                    .padding(.horizontal)
                }
                .padding(.vertical, 12)
                
                Divider()
                
                Divider()
                
                // Movies grid
                if viewModel.isLoading {
                    ProgressView()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else if filteredMovies.isEmpty {
                    VStack(spacing: 16) {
                        Image(systemName: "film.stack")
                            .font(.system(size: 60))
                            .foregroundColor(.gray)
                        Text("No movies found")
                            .font(.title3)
                            .foregroundColor(.secondary)
                        if !searchText.isEmpty {
                            Text("Try different search terms")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    ScrollView {
                        LazyVGrid(columns: [
                            GridItem(.flexible(), spacing: 16),
                            GridItem(.flexible(), spacing: 16)
                        ], spacing: 16) {
                            ForEach(filteredMovies) { movie in
                                TMDBMovieGridCard(movie: movie)
                            }
                        }
                        .padding()
                    }
                }
            }
            .navigationTitle("Movies")
            .navigationBarTitleDisplayMode(.large)
            .task {
                await viewModel.loadAllMovies()
            }
        }
    }
}

#Preview {
    MoviesView()
}
