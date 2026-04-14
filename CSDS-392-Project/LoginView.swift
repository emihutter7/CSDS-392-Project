//
//  LoginView.swift
//  CSDS-392-Project
//
//  Created by Alexandra Twitty on 4/14/26.
//

import SwiftUI

struct LoginView: View {
    @Environment(AuthModel.self) private var authModel
    
    @State var email: String = ""
    @State var password: String = ""
    @State var showPassword: Bool = false
    var isSignInButtonDisabled: Bool {
        [email, password].contains(where: \.isEmpty)
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                Spacer()
                
                TextField("Email", text: $email, prompt: Text("Email").foregroundColor(.blue))
                    .keyboardType(.emailAddress)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
                    .padding(10)
                    .overlay {
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(.blue, lineWidth: 2)
                    }
                    .padding(.horizontal)
                
                HStack {
                    Group {
                        if showPassword {
                            TextField("Password", text: $password, prompt: Text("Password").foregroundColor(.blue))
                        }
                        else {
                            SecureField("Password", text: $password, prompt: Text("Password").foregroundColor(.blue))
                        }
                    }
                    .padding(10)
                    .overlay {
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(.blue, lineWidth:2)
                    }
                    
                    Button {
                        showPassword.toggle()
                    } label: {
                        Image(systemName: showPassword ? "eye.slash" : "eye").foregroundColor(.accentColor)
                    }
                }
                .padding(.horizontal)
                .padding(.vertical)
                
                if !authModel.errorMessage.isEmpty {
                    Text(authModel.errorMessage)
                        .foregroundStyle(Color.red)
                        .font(.footnote)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                }
                Button {
                    Task {
                        await authModel.signIn(email: email, password: password)
                    }
                } label: {
                    if authModel.isLoading {
                        ProgressView()
                            .frame(maxWidth: .infinity, minHeight: 50)
                    } else {
                        Text("Sign In").font(.title2).bold().foregroundColor(.white)
                            .frame(height: 50)
                            .frame(maxWidth: .infinity)
                    }
                }
                .background (
                    isSignInButtonDisabled ? LinearGradient(colors: [.gray, .red], startPoint: .topLeading, endPoint: .bottomTrailing) : LinearGradient(colors: [.blue, .purple], startPoint: .topLeading, endPoint: .bottomTrailing)
                )
                .cornerRadius(20)
                .disabled(isSignInButtonDisabled || authModel.isLoading)
                .padding(.horizontal)
                
                Button {
                    Task {
                        await authModel.createAccount(email: email, password: password)
                    }
                } label: {
                    Text("Create Account")
                        .frame(maxWidth: .infinity, minHeight: 50)
                }
                .buttonStyle(.bordered)
                .disabled(isSignInButtonDisabled || authModel.isLoading)
                .padding()
                
                Spacer()
            }
        }
    }
}

#Preview {
    LoginView()
        .environment(AuthModel())
}
