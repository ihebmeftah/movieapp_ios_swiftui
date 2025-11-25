//
//  TMDBUpcomingCard.swift
//  projectswift
//
//  Created by Maalej Ahmed on 24/11/2025.
//

import SwiftUI

struct TMDBUpcomingCard: View {
    let movie: TMDBMovie

    var body: some View {
        NavigationLink(destination: TMDBMovieDetailView(movieId: movie.id)) {
            ZStack(alignment: .bottomLeading) {
                if let url = movie.backdropURL {
                    AsyncImage(url: url) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                    } placeholder: {
                        LinearGradient(colors: [Color.blue, Color.purple], startPoint: .topLeading, endPoint: .bottomTrailing)
                    }
                    .frame(width: 260, height: 150)
                    .clipped()
                } else {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(LinearGradient(colors: [Color.blue, Color.purple], startPoint: .topLeading, endPoint: .bottomTrailing))
                        .frame(width: 260, height: 150)
                }
                
                LinearGradient(
                    colors: [Color.clear, Color.black.opacity(0.7)],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .frame(width: 260, height: 150)

                VStack(alignment: .leading) {
                    Text(movie.title)
                        .font(.headline)
                        .foregroundColor(.white)
                    Text(String(movie.releaseDate.prefix(4)))
                        .font(.subheadline)
                        .foregroundColor(.white.opacity(0.9))
                }
                .padding()
            }
            .cornerRadius(12)
        }
        .buttonStyle(PlainButtonStyle())
    }
}
