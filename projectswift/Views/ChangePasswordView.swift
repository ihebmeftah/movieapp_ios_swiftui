//
//  ChangePasswordView.swift
//  projectswift
//
//  Created by Maalej Ahmed on 24/11/2025.
//

import SwiftUI
import FirebaseAuth

struct ChangePasswordView: View {
    @Environment(\.dismiss) var dismiss
    @State private var currentPassword: String = ""
    @State private var newPassword: String = ""
    @State private var confirmPassword: String = ""
    @State private var isLoading = false
    @State private var errorMessage: String?
    @State private var successMessage: String?
    @State private var showCurrentPassword = false
    @State private var showNewPassword = false
    @State private var showConfirmPassword = false
    
    var body: some View {
        Form {
            Section("Current Password") {
                HStack {
                    if showCurrentPassword {
                        TextField("Current Password", text: $currentPassword)
                    } else {
                        SecureField("Current Password", text: $currentPassword)
                    }
                    
                    Button(action: { showCurrentPassword.toggle() }) {
                        Image(systemName: showCurrentPassword ? "eye.slash" : "eye")
                            .foregroundColor(.secondary)
                    }
                }
            }
            
            Section("New Password") {
                HStack {
                    if showNewPassword {
                        TextField("New Password", text: $newPassword)
                    } else {
                        SecureField("New Password", text: $newPassword)
                    }
                    
                    Button(action: { showNewPassword.toggle() }) {
                        Image(systemName: showNewPassword ? "eye.slash" : "eye")
                            .foregroundColor(.secondary)
                    }
                }
                
                HStack {
                    if showConfirmPassword {
                        TextField("Confirm Password", text: $confirmPassword)
                    } else {
                        SecureField("Confirm Password", text: $confirmPassword)
                    }
                    
                    Button(action: { showConfirmPassword.toggle() }) {
                        Image(systemName: showConfirmPassword ? "eye.slash" : "eye")
                            .foregroundColor(.secondary)
                    }
                }
                
                Text("Password must be at least 6 characters")
                    .font(.caption)
                    .foregroundColor(.secondary)
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
                Button(action: changePassword) {
                    if isLoading {
                        HStack {
                            Spacer()
                            ProgressView()
                            Spacer()
                        }
                    } else {
                        HStack {
                            Spacer()
                            Text("Change Password")
                                .fontWeight(.semibold)
                            Spacer()
                        }
                    }
                }
                .disabled(isLoading || !isFormValid)
            }
        }
        .navigationTitle("Change Password")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private var isFormValid: Bool {
        !currentPassword.isEmpty &&
        !newPassword.isEmpty &&
        !confirmPassword.isEmpty &&
        newPassword == confirmPassword &&
        newPassword.count >= 6
    }
    
    private func changePassword() {
        guard let user = Auth.auth().currentUser,
              let email = user.email else { return }
        
        guard newPassword == confirmPassword else {
            errorMessage = "Passwords do not match"
            return
        }
        
        guard newPassword.count >= 6 else {
            errorMessage = "Password must be at least 6 characters"
            return
        }
        
        isLoading = true
        errorMessage = nil
        successMessage = nil
        
        // Re-authenticate user before changing password
        let credential = EmailAuthProvider.credential(withEmail: email, password: currentPassword)
        
        user.reauthenticate(with: credential) { result, error in
            if let error = error {
                isLoading = false
                errorMessage = "Current password is incorrect"
                return
            }
            
            // Update password
            user.updatePassword(to: newPassword) { error in
                isLoading = false
                
                if let error = error {
                    errorMessage = error.localizedDescription
                } else {
                    successMessage = "Password changed successfully!"
                    currentPassword = ""
                    newPassword = ""
                    confirmPassword = ""
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        dismiss()
                    }
                }
            }
        }
    }
}

#Preview {
    NavigationView {
        ChangePasswordView()
    }
}
