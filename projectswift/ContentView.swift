//
//  ContentView.swift
//  projectswift
//
//  Created by Maalej Ahmed on 24/11/2025.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var authViewModel = AuthViewModel()
    @StateObject private var favoritesViewModel = FavoritesViewModel()
    
    var body: some View {
        if authViewModel.isLoggedIn {
            TabView {
                HomeView()
                    .tabItem {
                        Label("Home", systemImage: "house.fill")
                    }

                MoviesView()
                    .tabItem {
                        Label("Movies", systemImage: "film")
                    }

                FavoriteView()
                    .tabItem {
                        Label("Favorite", systemImage: "heart")
                    }

                ProfileView(authViewModel: authViewModel)
                    .tabItem {
                        Label("Profile", systemImage: "person.crop.circle")
                    }
            }
            .environmentObject(authViewModel)
            .environmentObject(favoritesViewModel)
        } else {
            LoginView()
                .environmentObject(authViewModel)
        }
    }
}

#Preview {
    ContentView()
}
