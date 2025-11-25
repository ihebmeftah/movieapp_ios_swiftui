//
//  AuthViewModel.swift
//  projectswift
//
//  Created by Maalej Ahmed on 24/11/2025.
//

import Foundation
import SwiftUI
import FirebaseAuth

@MainActor
class AuthViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""
    @Published var confirmPassword = ""
    @Published var isLoggedIn = false
    @Published var errorMessage: String?
    @Published var isLoading = false
    @Published var currentUser: User?
    
    private var authStateHandle: AuthStateDidChangeListenerHandle?
    
    init() {
        authStateHandle = Auth.auth().addStateDidChangeListener { [weak self] _, user in
            DispatchQueue.main.async {
                self?.currentUser = user
                self?.isLoggedIn = user != nil
                if let user = user {
                    self?.email = user.email ?? ""
                }
            }
        }
    }
    
    deinit {
        if let handle = authStateHandle {
            Auth.auth().removeStateDidChangeListener(handle)
        }
    }
    
    func login() async {
        guard validateLogin() else { return }
        
        isLoading = true
        errorMessage = nil
        
        do {
            let result = try await Auth.auth().signIn(withEmail: email, password: password)
            print("✅ User signed in: \(result.user.uid)")
        } catch let error as NSError {
            handleAuthError(error)
        }
        
        isLoading = false
    }
    
    func register() async {
        guard validateRegistration() else { return }
        
        isLoading = true
        errorMessage = nil
        
        do {
            let result = try await Auth.auth().createUser(withEmail: email, password: password)
            print("✅ User registered: \(result.user.uid)")
        } catch let error as NSError {
            handleAuthError(error)
        }
        
        isLoading = false
    }
    
    func logout() {
        do {
            try Auth.auth().signOut()
            email = ""
            password = ""
            confirmPassword = ""
            currentUser = nil
            print("✅ User signed out")
        } catch {
            errorMessage = "Failed to sign out: \(error.localizedDescription)"
        }
    }
    
    private func handleAuthError(_ error: NSError) {
        guard let code = AuthErrorCode(_bridgedNSError: error)?.code else {
            errorMessage = error.localizedDescription
            return
        }
        
        switch code {
        case .emailAlreadyInUse:
            errorMessage = "This email is already registered"
        case .invalidEmail:
            errorMessage = "Invalid email address"
        case .weakPassword:
            errorMessage = "Password is too weak. Use at least 6 characters"
        case .wrongPassword:
            errorMessage = "Incorrect password"
        case .userNotFound:
            errorMessage = "No account found with this email"
        case .networkError:
            errorMessage = "Network error. Check your connection"
        case .tooManyRequests:
            errorMessage = "Too many attempts. Please try again later"
        default:
            errorMessage = error.localizedDescription
        }
    }
    
    private func validateLogin() -> Bool {
        errorMessage = nil
        
        guard !email.isEmpty else {
            errorMessage = "Please enter your email"
            return false
        }
        
        guard email.contains("@") && email.contains(".") else {
            errorMessage = "Please enter a valid email address"
            return false
        }
        
        guard !password.isEmpty else {
            errorMessage = "Please enter your password"
            return false
        }
        
        guard password.count >= 6 else {
            errorMessage = "Password must be at least 6 characters"
            return false
        }
        
        return true
    }
    
    private func validateRegistration() -> Bool {
        errorMessage = nil
        
        guard !email.isEmpty else {
            errorMessage = "Please enter your email"
            return false
        }
        
        guard email.contains("@") && email.contains(".") else {
            errorMessage = "Please enter a valid email address"
            return false
        }
        
        guard !password.isEmpty else {
            errorMessage = "Please enter your password"
            return false
        }
        
        guard password.count >= 6 else {
            errorMessage = "Password must be at least 6 characters"
            return false
        }
        
        guard password == confirmPassword else {
            errorMessage = "Passwords do not match"
            return false
        }
        
        return true
    }
}
