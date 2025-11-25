//
//  UpcomingCard.swift
//  projectswift
//
//  Created by Maalej Ahmed on 24/11/2025.
//

import SwiftUI

struct UpcomingCard: View {
    let movie: Movie

    var body: some View {
        NavigationLink(destination: MovieDetailView(movie: movie)) {
            ZStack(alignment: .bottomLeading) {
                RoundedRectangle(cornerRadius: 12)
                    .fill(LinearGradient(colors: [Color.blue, Color.purple], startPoint: .topLeading, endPoint: .bottomTrailing))
                    .frame(width: 260, height: 150)

                VStack(alignment: .leading) {
                    Text(movie.title)
                        .font(.headline)
                        .foregroundColor(.white)
                    Text(movie.year)
                        .font(.subheadline)
                        .foregroundColor(.white.opacity(0.9))
                }
                .padding()
            }
        }
        .buttonStyle(PlainButtonStyle())
    }
}
