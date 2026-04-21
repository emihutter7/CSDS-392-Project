//
//  AuthManager.swift
//  CSDS-392-Project
//
//  Created by Emi Hutter-DeMarco on 4/15/26.
//
import SwiftUI
import Combine
import FirebaseAuth

@MainActor
final class AuthManager: ObservableObject {
    @Published var user: User?
    @Published var isAuthenticated: Bool = false
    @Published var errorMessage: String = ""
    
    init() {
        self.user = Auth.auth().currentUser
        self.isAuthenticated = Auth.auth().currentUser != nil
    }
    
    func signUp(email: String, password: String) async {
        do {
            let result = try await Auth.auth().createUser(withEmail: email, password: password)
            self.user = result.user
            self.isAuthenticated = true
            self.errorMessage = ""
        } catch {
            self.errorMessage = error.localizedDescription
            self.isAuthenticated = false
        }
    }
    
    func logIn(email: String, password: String) async {
        do {
            let result = try await Auth.auth().signIn(withEmail: email, password: password)
            self.user = result.user
            self.isAuthenticated = true
            self.errorMessage = ""
        } catch {
            self.errorMessage = error.localizedDescription
            self.isAuthenticated = false
        }
    }
    
    func logOut() {
        do {
            try Auth.auth().signOut()
            self.user = nil
            self.isAuthenticated = false
            self.errorMessage = ""
        } catch {
            self.errorMessage = error.localizedDescription
        }
    }
}
