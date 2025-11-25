//
//  FavoritesViewModel.swift
//  projectswift
//
//  Created by Maalej Ahmed on 24/11/2025.
//

import Foundation
import SwiftUI
import FirebaseFirestore
import FirebaseAuth

@MainActor
class FavoritesViewModel: ObservableObject {
    @Published var favoriteMovies: [TMDBMovie] = []
    @Published var selectedFilter = "All"
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var isUserLoggedIn = false
    
    private let db = Firestore.firestore()
    private var listener: ListenerRegistration?
    private var authListener: AuthStateDidChangeListenerHandle?
    
    let filterOptions = ["All", "Movies", "Recently Added"]
    
    init() {
        setupAuthListener()
    }
    
    deinit {
        listener?.remove()
        if let authListener = authListener {
            Auth.auth().removeStateDidChangeListener(authListener)
        }
    }
    
    private func setupAuthListener() {
        authListener = Auth.auth().addStateDidChangeListener { [weak self] _, user in
            guard let self = self else { return }
            Task { @MainActor in
                self.isUserLoggedIn = user != nil
                if user != nil {
                    self.setupListener()
                } else {
                    self.listener?.remove()
                    self.favoriteMovies = []
                }
            }
        }
    }
    
    private func setupListener() {
        listener?.remove()
        
        guard let userId = Auth.auth().currentUser?.uid else {
            favoriteMovies = []
            return
        }
        
        listener = db.collection("favorites")
            .whereField("userId", isEqualTo: userId)
            .addSnapshotListener { [weak self] snapshot, error in
                guard let self = self else { return }
                
                if let error = error {
                    Task { @MainActor in
                        self.errorMessage = "Error loading favorites: \(error.localizedDescription)"
                        print("❌ Listener error: \(error)")
                    }
                    return
                }
                
                guard let documents = snapshot?.documents else { return }
                
                Task { @MainActor in
                    let favorites = documents.compactMap { doc in
                        try? doc.data(as: FavoriteMovie.self)
                    }
                    // Sort by addedAt in memory
                    self.favoriteMovies = favorites
                        .sorted { $0.addedAt > $1.addedAt }
                        .map { $0.toTMDBMovie }
                    print("✅ Favorites updated: \(self.favoriteMovies.count) movies")
                }
            }
    }
    
    func loadFavorites() async {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        
        isLoading = true
        errorMessage = nil
        
        do {
            let snapshot = try await db.collection("favorites")
                .whereField("userId", isEqualTo: userId)
                .getDocuments()
            
            let favorites = snapshot.documents.compactMap { doc in
                try? doc.data(as: FavoriteMovie.self)
            }
            // Sort by addedAt in memory
            favoriteMovies = favorites
                .sorted { $0.addedAt > $1.addedAt }
                .map { $0.toTMDBMovie }
            
            print("✅ Loaded \(favoriteMovies.count) favorites")
        } catch {
            errorMessage = "Failed to load favorites: \(error.localizedDescription)"
            print("❌ Error loading favorites: \(error)")
        }
        
        isLoading = false
    }
    
    func addToFavorites(_ movie: TMDBMovie) async {
        guard let userId = Auth.auth().currentUser?.uid else {
            errorMessage = "You must be logged in to add favorites"
            return
        }
        
        if favoriteMovies.contains(where: { $0.id == movie.id }) {
            print("⚠️ Movie already in favorites")
            return
        }
        
        let favorite = FavoriteMovie(from: movie, userId: userId)
        
        do {
            try db.collection("favorites").addDocument(from: favorite)
            print("✅ Added to favorites: \(movie.title)")
        } catch {
            errorMessage = "Failed to add favorite: \(error.localizedDescription)"
            print("❌ Error adding favorite: \(error)")
        }
    }
    
    func removeFromFavorites(_ movie: TMDBMovie) async {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        
        do {
            let snapshot = try await db.collection("favorites")
                .whereField("userId", isEqualTo: userId)
                .whereField("movieId", isEqualTo: movie.id)
                .getDocuments()
            
            for document in snapshot.documents {
                try await document.reference.delete()
                print("✅ Removed from favorites: \(movie.title)")
            }
        } catch {
            errorMessage = "Failed to remove favorite: \(error.localizedDescription)"
            print("❌ Error removing favorite: \(error)")
        }
    }
    
    func isFavorite(_ movie: TMDBMovie) -> Bool {
        return favoriteMovies.contains { $0.id == movie.id }
    }
    
    func toggleFavorite(_ movie: TMDBMovie) async {
        if isFavorite(movie) {
            await removeFromFavorites(movie)
        } else {
            await addToFavorites(movie)
        }
    }
    
    func clearAllFavorites() async {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        
        do {
            let snapshot = try await db.collection("favorites")
                .whereField("userId", isEqualTo: userId)
                .getDocuments()
            
            for document in snapshot.documents {
                try await document.reference.delete()
            }
            
            print("✅ Cleared all favorites")
        } catch {
            errorMessage = "Failed to clear favorites: \(error.localizedDescription)"
        }
    }
}
