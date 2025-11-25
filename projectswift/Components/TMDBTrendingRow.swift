//
//  TMDBTrendingRow.swift
//  projectswift
//
//  Created by Maalej Ahmed on 24/11/2025.
//

import SwiftUI

struct TMDBTrendingRow: View {
    let movie: TMDBMovie

    var body: some View {
        NavigationLink(destination: TMDBMovieDetailView(movieId: movie.id)) {
            HStack(spacing: 12) {
                if let url = movie.posterURL {
                    AsyncImage(url: url) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                    } placeholder: {
                        Color.orange.opacity(0.4)
                    }
                    .frame(width: 80, height: 80)
                    .cornerRadius(8)
                    .clipped()
                } else {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.orange.opacity(0.4))
                        .frame(width: 80, height: 80)
                }

                VStack(alignment: .leading, spacing: 6) {
                    Text(movie.title)
                        .font(.headline)
                        .foregroundColor(.primary)
                        .lineLimit(2)
                    Text(String(movie.releaseDate.prefix(4)))
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }

                Spacer()

                Text(String(format: "%.1f", movie.voteAverage))
                    .bold()
                    .foregroundColor(.primary)
            }
            .padding(12)
            .background(Color(.systemBackground))
            .cornerRadius(10)
            .shadow(color: Color.black.opacity(0.03), radius: 4, x: 0, y: 2)
        }
        .buttonStyle(PlainButtonStyle())
    }
}
