//
//  SignOutView.swift
//  CSDS-392-Project
//
//  Created by Alexandra Twitty on 4/14/26.
//

import SwiftUI
import FirebaseAuth

struct SignOutView: View {
    @Environment(AuthModel.self) private var authModel
    
    var body : some View {
        NavigationStack {
            VStack {
                Text("You are signed in")
                    .font(.title)
                
                Text(authModel.user?.email ?? "No email")
                
                Button("Sign Out") {
                    authModel.signOut()
                }
                .buttonStyle(.borderedProminent)
            }
        }
    }
}

#Preview {
    SignOutView()
        .environment(AuthModel())
}
