//
//  AuthModel.swift
//  CSDS-392-Project
//
//  Created by Alexandra Twitty on 4/14/26.
//

import FirebaseAuth
import FirebaseCore

@Observable
@MainActor
final class AuthModel {
    var user: User?
    var errorMessage = ""
    var isLoading = false

    init() {
        if FirebaseApp.app() != nil {
                user = Auth.auth().currentUser
            } else {
                user = nil
            }
    }

    func signIn(email: String, password: String) async {
        errorMessage = ""
        isLoading = true
        defer { isLoading = false }

        do {
            let result = try await Auth.auth().signIn(withEmail: email, password: password)
            user = result.user
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func createAccount(email: String, password: String) async {
        errorMessage = ""
        isLoading = true
        defer { isLoading = false }

        do {
            let result = try await Auth.auth().createUser(withEmail: email, password: password)
            user = result.user
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func signOut() {
        errorMessage = ""

        do {
            try Auth.auth().signOut()
            user = nil
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
