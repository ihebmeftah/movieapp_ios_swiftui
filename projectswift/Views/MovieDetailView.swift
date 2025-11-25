//
//  MovieDetailView.swift
//  projectswift
//
//  Created by Maalej Ahmed on 24/11/2025.
//

import SwiftUI

struct MovieDetailView: View {
    let movie: Movie
    @State private var isFavorite = false
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                // Hero poster section
                ZStack(alignment: .bottom) {
                    // Poster background
                    LinearGradient(
                        colors: [Color.blue.opacity(0.8), Color.purple.opacity(0.8)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                    .frame(height: 400)
                    
                    // Gradient overlay
                    LinearGradient(
                        colors: [Color.clear, Color(.systemBackground)],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                    .frame(height: 150)
                }
                .ignoresSafeArea(edges: .top)
                
                VStack(alignment: .leading, spacing: 16) {
                    // Title and favorite button
                    HStack(alignment: .top) {
                        VStack(alignment: .leading, spacing: 8) {
                            Text(movie.title)
                                .font(.system(size: 32, weight: .bold))
                            
                            HStack(spacing: 8) {
                                Text(movie.year)
                                    .foregroundColor(.secondary)
                                
                                Text("•")
                                    .foregroundColor(.secondary)
                                
                                Text(movie.duration)
                                    .foregroundColor(.secondary)
                                
                                Text("•")
                                    .foregroundColor(.secondary)
                                
                                Text(movie.category)
                                    .padding(.horizontal, 10)
                                    .padding(.vertical, 4)
                                    .background(Color.accentColor.opacity(0.2))
                                    .cornerRadius(6)
                                    .font(.subheadline)
                            }
                        }
                        
                        Spacer()
                        
                        Button(action: { isFavorite.toggle() }) {
                            Image(systemName: isFavorite ? "heart.fill" : "heart")
                                .font(.title2)
                                .foregroundColor(isFavorite ? .red : .gray)
                                .frame(width: 44, height: 44)
                        }
                    }
                    
                    // Rating
                    HStack(spacing: 12) {
                        HStack(spacing: 4) {
                            Image(systemName: "star.fill")
                                .foregroundColor(.yellow)
                            Text(String(format: "%.1f", movie.rating))
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
                            Text("124K votes")
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
                            .padding()
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
                    }
                    
                    Divider()
                        .padding(.vertical, 8)
                    
                    // Description
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Synopsis")
                            .font(.title3)
                            .bold()
                        
                        Text(movie.description)
                            .foregroundColor(.secondary)
                            .lineSpacing(4)
                    }
                    
                    Divider()
                        .padding(.vertical, 8)
                    
                    // Director
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Director")
                            .font(.headline)
                        
                        HStack {
                            Circle()
                                .fill(Color.accentColor.opacity(0.3))
                                .frame(width: 50, height: 50)
                                .overlay(
                                    Image(systemName: "person.fill")
                                        .foregroundColor(.accentColor)
                                )
                            
                            VStack(alignment: .leading) {
                                Text(movie.director)
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
                    
                    // Cast
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Cast")
                            .font(.title3)
                            .bold()
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 16) {
                                ForEach(movie.actors, id: \.self) { actor in
                                    VStack(spacing: 8) {
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
                                        
                                        Text(actor)
                                            .font(.caption)
                                            .fontWeight(.medium)
                                            .lineLimit(2)
                                            .multilineTextAlignment(.center)
                                            .frame(width: 80)
                                    }
                                }
                            }
                        }
                    }
                    
                    Divider()
                        .padding(.vertical, 8)
                    
                    // Reviews section
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Text("Reviews")
                                .font(.title3)
                                .bold()
                            
                            Spacer()
                            
                            Button("See All") {}
                                .font(.subheadline)
                        }
                        
                        ReviewCard(
                            author: "John Doe",
                            rating: 9,
                            review: "An absolute masterpiece! The cinematography is breathtaking and the story keeps you engaged from start to finish.",
                            date: "2 days ago"
                        )
                        
                        ReviewCard(
                            author: "Jane Smith",
                            rating: 8,
                            review: "Great movie with excellent performances. Highly recommended for fans of the genre.",
                            date: "1 week ago"
                        )
                    }
                }
                .padding()
            }
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct ReviewCard: View {
    let author: String
    let rating: Int
    let review: String
    let date: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Circle()
                    .fill(Color.accentColor.opacity(0.3))
                    .frame(width: 40, height: 40)
                    .overlay(
                        Text(String(author.prefix(1)))
                            .font(.headline)
                            .foregroundColor(.accentColor)
                    )
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(author)
                        .font(.subheadline)
                        .fontWeight(.semibold)
                    
                    HStack(spacing: 4) {
                        HStack(spacing: 2) {
                            ForEach(0..<rating, id: \.self) { _ in
                                Image(systemName: "star.fill")
                                    .font(.caption2)
                                    .foregroundColor(.yellow)
                            }
                        }
                        
                        Text(date)
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                
                Spacer()
            }
            
            Text(review)
                .font(.subheadline)
                .foregroundColor(.secondary)
                .lineSpacing(3)
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
}

#Preview {
    NavigationView {
        MovieDetailView(movie: sampleUpcoming[0])
    }
}
