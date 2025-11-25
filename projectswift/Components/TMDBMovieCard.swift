//
//  TMDBMovieCard.swift
//  projectswift
//
//  Created by Maalej Ahmed on 24/11/2025.
//

import SwiftUI

struct TMDBMovieCard: View {
    let movie: TMDBMovie

    var body: some View {
        NavigationLink(destination: TMDBMovieDetailView(movieId: movie.id)) {
            VStack(alignment: .leading, spacing: 6) {
                ZStack(alignment: .topTrailing) {
                    if let url = movie.posterURL {
                        AsyncImage(url: url) { image in
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                        } placeholder: {
                            Color.gray.opacity(0.3)
                        }
                        .frame(width: 120, height: 180)
                        .clipped()
                    } else {
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.gray.opacity(0.3))
                            .frame(width: 120, height: 180)
                    }
                    
                    // Rating badge
                    HStack(spacing: 4) {
                        Image(systemName: "star.fill")
                            .font(.caption2)
                            .foregroundColor(.yellow)
                        Text(String(format: "%.1f", movie.voteAverage))
                            .font(.caption)
                            .bold()
                            .foregroundColor(.white)
                    }
                    .padding(.horizontal, 6)
                    .padding(.vertical, 3)
                    .background(Color.black.opacity(0.7))
                    .cornerRadius(8)
                    .padding(4)
                }
                .cornerRadius(8)

                Text(movie.title)
                    .font(.subheadline)
                    .lineLimit(2)
                    .foregroundColor(.primary)
                    .frame(width: 120, alignment: .leading)
            }
            .frame(width: 120)
        }
        .buttonStyle(PlainButtonStyle())
    }
}
