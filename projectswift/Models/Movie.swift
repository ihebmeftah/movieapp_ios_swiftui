//
//  Movie.swift
//  projectswift
//
//  Created by Maalej Ahmed on 24/11/2025.
//

import Foundation

struct Movie: Identifiable {
    let id = UUID()
    let title: String
    let year: String
    let rating: Double
    let category: String
    let description: String
    let director: String
    let duration: String
    let actors: [String]
}
