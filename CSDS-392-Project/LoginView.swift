//
//  LoginView.swift
//  CSDS-392-Project
//
//  Created by Alexandra Twitty on 4/14/26.
//

import SwiftUI

struct LoginView: View {
    @Environment(AuthModel.self) private var authModel

    @State private var email: String = ""
    @State private var password: String = ""
    @State private var showPassword: Bool = false

    private let backgroundColor = Color("AppBackground")
    private let secondaryAccent = Color("SecondaryAccent")
    private let softFieldBackground = Color.white
    private let fieldBorder = Color("FieldBorder")

    private var isSignInButtonDisabled: Bool {
        [email, password].contains(where: \.isEmpty)
    }

    var body: some View {
        NavigationStack {
            ZStack {
                backgroundColor
                    .ignoresSafeArea()

                VStack(spacing: 24) {
                    Spacer()

                    VStack(spacing: 12) {
                        Text("Welcome!")
                            .font(.system(size: 30, weight: .semibold))
                            .foregroundStyle(secondaryAccent)

                        Text("Sign in to manage your budget")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundStyle(secondaryAccent.opacity(0.7))
                    }

                    VStack(spacing: 16) {
                        TextField("", text: $email, prompt: Text("Email").foregroundColor(secondaryAccent.opacity(0.55)))
                            .keyboardType(.emailAddress)
                            .textInputAutocapitalization(.never)
                            .autocorrectionDisabled()
                            .foregroundStyle(secondaryAccent)
                            .padding(.horizontal, 16)
                            .frame(height: 56)
                            .background(softFieldBackground)
                            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                            .overlay {
                                RoundedRectangle(cornerRadius: 16, style: .continuous)
                                    .stroke(fieldBorder, lineWidth: 1.5)
                            }

                        HStack(spacing: 10) {
                            Group {
                                if showPassword {
                                    TextField("", text: $password, prompt: Text("Password").foregroundColor(secondaryAccent.opacity(0.55)))
                                } else {
                                    SecureField("", text: $password, prompt: Text("Password").foregroundColor(secondaryAccent.opacity(0.55)))
                                }
                            }
                            .foregroundStyle(secondaryAccent)

                            Button {
                                showPassword.toggle()
                            } label: {
                                Image(systemName: showPassword ? "eye.slash" : "eye")
                                    .font(.system(size: 18, weight: .medium))
                            }
                        }
                        .padding(.horizontal, 16)
                        .frame(height: 56)
                        .background(softFieldBackground)
                        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                        .overlay {
                            RoundedRectangle(cornerRadius: 16, style: .continuous)
                                .stroke(fieldBorder, lineWidth: 1.5)
                        }

                        if !authModel.errorMessage.isEmpty {
                            Text(authModel.errorMessage)
                                .foregroundStyle(.red.opacity(0.85))
                                .font(.footnote)
                                .multilineTextAlignment(.center)
                                .padding(.top, 4)
                        }
                    }

                    VStack(spacing: 14) {
                        Button {
                            Task {
                                await authModel.signIn(email: email, password: password)
                            }
                        } label: {
                            if authModel.isLoading {
                                ProgressView()
                                    .tint(.white)
                                    .frame(maxWidth: .infinity, minHeight: 56)
                            } else {
                                Text("Sign In")
                                    .font(.system(size: 18, weight: .semibold))
                                    .foregroundStyle(.white)
                                    .frame(maxWidth: .infinity, minHeight: 56)
                            }
                        }
                        .background(
                            isSignInButtonDisabled
                            ? Color.gray.opacity(0.45)
                            : Color.accentColor
                        )
                        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
                        .disabled(isSignInButtonDisabled || authModel.isLoading)

                        Button {
                            Task {
                                await authModel.createAccount(email: email, password: password)
                            }
                        } label: {
                            Text("Create Account")
                                .font(.system(size: 17, weight: .semibold))
                                .frame(maxWidth: .infinity, minHeight: 56)
                                .background(Color.white)
                                .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
                                .overlay {
                                    RoundedRectangle(cornerRadius: 18, style: .continuous)
                                        .stroke(fieldBorder, lineWidth: 1.5)
                                }
                        }
                        .disabled(isSignInButtonDisabled || authModel.isLoading)
                    }

                    Spacer()
                }
                .padding(.horizontal, 24)
            }
        }
    }
}

#Preview {
    LoginView()
        .environment(AuthModel())
}
