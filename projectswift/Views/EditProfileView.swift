//
//  EditProfileView.swift
//  projectswift
//
//  Created by Maalej Ahmed on 24/11/2025.
//

import SwiftUI
import FirebaseAuth

struct EditProfileView: View {
    @Environment(\.dismiss) var dismiss
    @State private var displayName: String = ""
    @State private var isLoading = false
    @State private var errorMessage: String?
    @State private var successMessage: String?
    
    var body: some View {
        Form {
            Section("Profile Information") {
                TextField("Display Name", text: $displayName)
                    .textContentType(.name)
                    .autocapitalization(.words)
                
                if let user = Auth.auth().currentUser {
                    HStack {
                        Text("Email")
                            .foregroundColor(.secondary)
                        Spacer()
                        Text(user.email ?? "")
                            .foregroundColor(.primary)
                    }
                }
            }
            
            if let error = errorMessage {
                Section {
                    Text(error)
                        .foregroundColor(.red)
                        .font(.caption)
                }
            }
            
            if let success = successMessage {
                Section {
                    Text(success)
                        .foregroundColor(.green)
                        .font(.caption)
                }
            }
            
            Section {
                Button(action: updateProfile) {
                    if isLoading {
                        HStack {
                            Spacer()
                            ProgressView()
                            Spacer()
                        }
                    } else {
                        HStack {
                            Spacer()
                            Text("Update Profile")
                                .fontWeight(.semibold)
                            Spacer()
                        }
                    }
                }
                .disabled(isLoading || displayName.isEmpty)
            }
        }
        .navigationTitle("Edit Profile")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            loadUserProfile()
        }
    }
    
    private func loadUserProfile() {
        if let user = Auth.auth().currentUser {
            displayName = user.displayName ?? ""
        }
    }
    
    private func updateProfile() {
        guard let user = Auth.auth().currentUser else { return }
        
        isLoading = true
        errorMessage = nil
        successMessage = nil
        
        let changeRequest = user.createProfileChangeRequest()
        changeRequest.displayName = displayName
        
        changeRequest.commitChanges { error in
            isLoading = false
            
            if let error = error {
                errorMessage = error.localizedDescription
            } else {
                successMessage = "Profile updated successfully!"
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    dismiss()
                }
            }
        }
    }
}

#Preview {
    NavigationView {
        EditProfileView()
    }
}
