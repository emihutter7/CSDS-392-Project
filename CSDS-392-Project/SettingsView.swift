//
//  SettingsView.swift
//  CSDS-392-Project
//
//  Created by Alexandra Twitty on 4/14/26.
//
import SwiftUI
import SwiftData

struct SettingsView: View {
    @Environment(AuthModel.self) private var authModel
    @AppStorage("darkModeEnabled") private var darkModeEnabled = false
    @AppStorage("notificationsEnabled") private var notificationsEnabled = true

    var body: some View {
        NavigationStack {
            ZStack {
                Color(red: 0.80, green: 0.68, blue: 0.40)
                    .ignoresSafeArea()

                VStack(alignment: .leading, spacing: 28) {
                    Text("Settings")
                        .font(.system(size: 32, weight: .medium))
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding(.top, 10)

                    NavigationLink {
                        BudgetEditorView()
                    } label: {
                        HStack {
                            Text("Edit Budget")
                                .font(.system(size: 22, weight: .medium))
                                .foregroundStyle(.black)

                            Image(systemName: "chevron.right")
                                .foregroundStyle(.black.opacity(0.75))
                        }
                    }
                    .buttonStyle(.plain)

                    HStack {
                        Text("Dark Mode")
                            .font(.system(size: 22, weight: .medium))
                            .foregroundStyle(.black)

                        Spacer()

                        Toggle("", isOn: $darkModeEnabled)
                            .labelsHidden()
                    }

                    HStack {
                        Text("Notifications")
                            .font(.system(size: 22, weight: .medium))
                            .foregroundStyle(.black)

                        Spacer()

                        Toggle("", isOn: $notificationsEnabled)
                            .labelsHidden()
                    }

                    Spacer()

                    Button("Logout") {
                        signOut()
                    }
                    .foregroundStyle(.red)
                    .font(.system(size: 18, weight: .medium))
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.bottom, 50)
                }
                .padding(.horizontal, 32)
            }
            .navigationBarHidden(true)
            .preferredColorScheme(darkModeEnabled ? .dark : .light)
        }
    }

    private func signOut() {
        authModel.signOut()
    }
}

#Preview {
    SettingsView()
        .environment(AuthModel())
}
