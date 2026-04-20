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

    private let backgroundColor = Color(red: 0.97, green: 0.95, blue: 0.94)
    private let accentColor = Color(red: 0.75, green: 0.55, blue: 0.60)
    private let secondaryAccent = Color(red: 0.55, green: 0.43, blue: 0.35)
    private let fieldBorder = Color(red: 0.88, green: 0.80, blue: 0.81)
    private let softBackground = Color(red: 0.99, green: 0.98, blue: 0.97)

    var body: some View {
        NavigationStack {
            ZStack {
                backgroundColor
                    .ignoresSafeArea()

                VStack(alignment: .leading, spacing: 22) {
                    Text("Settings")
                        .font(.system(size: 30, weight: .semibold))
                        .foregroundStyle(secondaryAccent)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding(.top, 10)

                    VStack(spacing: 16) {
                        NavigationLink {
                            BudgetEditorView()
                        } label: {
                            HStack {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("Edit Budget")
                                        .font(.system(size: 18, weight: .semibold))
                                        .foregroundStyle(secondaryAccent)

                                    Text("Update income and category budgets")
                                        .font(.system(size: 14))
                                        .foregroundStyle(secondaryAccent.opacity(0.65))
                                }

                                Spacer()

                                Image(systemName: "chevron.right")
                                    .font(.system(size: 14, weight: .semibold))
                                    .foregroundStyle(accentColor)
                            }
                            .padding(16)
                            .background(
                                RoundedRectangle(cornerRadius: 18, style: .continuous)
                                    .fill(softBackground)
                            )
                            .overlay {
                                RoundedRectangle(cornerRadius: 18, style: .continuous)
                                    .stroke(fieldBorder, lineWidth: 1)
                            }
                        }
                        .buttonStyle(.plain)

                        settingsToggleRow(
                            title: "Dark Mode",
                            subtitle: "Switch between light and dark appearance",
                            isOn: $darkModeEnabled
                        )

                        settingsToggleRow(
                            title: "Notifications",
                            subtitle: "Enable reminders and alerts",
                            isOn: $notificationsEnabled
                        )
                    }
                    .padding(18)
                    .background(Color.white)
                    .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
                    .shadow(color: .black.opacity(0.05), radius: 12, y: 6)

                    Spacer()

                    Button("Log Out") {
                        signOut()
                    }
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 54)
                    .background(
                        RoundedRectangle(cornerRadius: 18, style: .continuous)
                            .fill(accentColor)
                    )
                    .shadow(color: accentColor.opacity(0.22), radius: 10, y: 6)
                    .padding(.bottom, 40)
                }
                .padding(.horizontal, 20)
            }
            .navigationBarHidden(true)
            .preferredColorScheme(darkModeEnabled ? .dark : .light)
            .tint(accentColor)
        }
    }

    @ViewBuilder
    private func settingsToggleRow(title: String, subtitle: String, isOn: Binding<Bool>) -> some View {
        HStack(spacing: 14) {
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundStyle(secondaryAccent)

                Text(subtitle)
                    .font(.system(size: 14))
                    .foregroundStyle(secondaryAccent.opacity(0.65))
            }

            Spacer()

            Toggle("", isOn: isOn)
                .labelsHidden()
                .tint(accentColor)
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .fill(softBackground)
        )
        .overlay {
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .stroke(fieldBorder, lineWidth: 1)
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
