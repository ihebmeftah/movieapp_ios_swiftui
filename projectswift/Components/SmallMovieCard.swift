//
//  SmallMovieCard.swift
//  projectswift
//
//  Created by Maalej Ahmed on 24/11/2025.
//

import SwiftUI

struct SmallMovieCard: View {
    let movie: Movie

    var body: some View {
        NavigationLink(destination: MovieDetailView(movie: movie)) {
            VStack(alignment: .leading, spacing: 6) {
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.gray.opacity(0.3))
                    .frame(width: 120, height: 80)

                Text(movie.title)
                    .font(.subheadline)
                    .lineLimit(1)
                    .foregroundColor(.primary)

                HStack(spacing: 6) {
                    Image(systemName: "star.fill")
                        .foregroundColor(.yellow)
                        .font(.caption)
                    Text(String(format: "%.1f", movie.rating))
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            .frame(width: 120)
        }
        .buttonStyle(PlainButtonStyle())
    }
}
