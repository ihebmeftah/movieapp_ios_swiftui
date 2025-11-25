//
//  ProfileView.swift
//  projectswift
//
//  Created by Maalej Ahmed on 24/11/2025.
//

import SwiftUI
import FirebaseAuth

struct ProfileView: View {
    @ObservedObject var authViewModel: AuthViewModel
    @State private var displayName: String = ""
    
    var body: some View {
        NavigationView {
            List {
                // User Info Section
                Section {
                    HStack(spacing: 16) {
                        Circle()
                            .fill(
                                LinearGradient(
                                    colors: [.blue, .purple],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(width: 70, height: 70)
                            .overlay(
                                Text(String((displayName.isEmpty ? authViewModel.email : displayName).prefix(1).uppercased()))
                                    .font(.title)
                                    .foregroundColor(.white)
                                    .bold()
                            )
                        
                        VStack(alignment: .leading, spacing: 4) {
                            if !displayName.isEmpty {
                                Text(displayName)
                                    .font(.headline)
                                Text(authViewModel.email)
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            } else {
                                Text(authViewModel.email)
                                    .font(.headline)
                                Text("Movie Enthusiast")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                    .padding(.vertical, 8)
                }
                
                // Account Settings
                Section("Account") {
                    NavigationLink(destination: EditProfileView()) {
                        Label("Edit Profile", systemImage: "person.circle")
                    }
                    
                    NavigationLink(destination: ChangePasswordView()) {
                        Label("Change Password", systemImage: "lock.rotation")
                    }
                }
                
                // Logout
                Section {
                    Button(action: {
                        authViewModel.logout()
                    }) {
                        HStack {
                            Spacer()
                            Label("Logout", systemImage: "rectangle.portrait.and.arrow.right")
                                .foregroundColor(.red)
                            Spacer()
                        }
                    }
                }
            }
            .navigationTitle("Profile")
            .onAppear {
                loadUserProfile()
            }
        }
    }
    
    private func loadUserProfile() {
        if let user = Auth.auth().currentUser {
            displayName = user.displayName ?? ""
        }
    }
}

#Preview {
    ProfileView(authViewModel: AuthViewModel())
}
