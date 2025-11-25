//
//  TrendingRow.swift
//  projectswift
//
//  Created by Maalej Ahmed on 24/11/2025.
//

import SwiftUI

struct TrendingRow: View {
    let movie: Movie

    var body: some View {
        NavigationLink(destination: MovieDetailView(movie: movie)) {
            HStack(spacing: 12) {
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.orange.opacity(0.4))
                    .frame(width: 80, height: 80)

                VStack(alignment: .leading, spacing: 6) {
                    Text(movie.title)
                        .font(.headline)
                        .foregroundColor(.primary)
                    Text(movie.category + " • " + movie.year)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }

                Spacer()

                Text(String(format: "%.1f", movie.rating))
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
