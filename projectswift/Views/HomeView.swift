//
//  HomeView.swift
//  projectswift
//
//  Created by Maalej Ahmed on 24/11/2025.
//

import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel = MoviesViewModel()
    @State private var selectedCategory = "All"

    var body: some View {
        NavigationView {
            ScrollView {
                if viewModel.isLoading {
                    ProgressView()
                        .frame(maxWidth: .infinity)
                        .padding(.top, 100)
                } else {
                    VStack(alignment: .leading, spacing: 20) {
                        // Upcoming carousel
                        if !viewModel.upcomingMovies.isEmpty {
                            Text("Upcoming")
                                .font(.title2)
                                .bold()
                                .padding(.horizontal)

                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 16) {
                                    ForEach(viewModel.upcomingMovies) { movie in
                                        TMDBUpcomingCard(movie: movie)
                                    }
                                }
                                .padding(.horizontal)
                            }
                        }

                        // Top Rated
                        if !viewModel.topRatedMovies.isEmpty {
                            SectionHeader(title: "Top Rated")

                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 12) {
                                    ForEach(viewModel.topRatedMovies) { movie in
                                        TMDBMovieCard(movie: movie)
                                    }
                                }
                                .padding(.horizontal)
                            }
                        }

                        // Trending
                        if !viewModel.trendingMovies.isEmpty {
                            SectionHeader(title: "Trending")

                            VStack(spacing: 12) {
                                ForEach(viewModel.trendingMovies.prefix(5)) { movie in
                                    TMDBTrendingRow(movie: movie)
                                        .padding(.horizontal)
                                }
                            }
                        }
                        
                        if let error = viewModel.errorMessage {
                            Text(error)
                                .foregroundColor(.red)
                                .padding()
                        }
                    }
                    .padding(.bottom)
                }
            }
            .navigationTitle("Home")
            .task {
                await viewModel.loadAllMovies()
            }
        }
    }
}

#Preview {
    HomeView()
}
