//
//  SettingsView.swift
//  CSDS-392-Project
//
//  Created by Alexandra Twitty on 4/14/26.
//

import SwiftUI

struct SettingsView: View {
    @Environment(AuthModel.self) private var authModel
    @AppStorage("darkModeEnabled") private var darkModeEnabled = false
    @AppStorage("notificationsEnabled") private var notificationsEnabled = false
    @State private var showLogoutAlert = false

    private let backgroundColor = Color("AppBackground")
    private let secondaryAccent = Color("SecondaryAccent")
    private let fieldBorder = Color("FieldBorder")
    private let softBackground = Color("SoftBackground")

    var body: some View {
        NavigationStack {
            ZStack {
                backgroundColor.ignoresSafeArea()

                VStack(alignment:.leading, spacing: 22) {
                    Text("Settings").font(.system(size: 30, weight:.semibold)).foregroundStyle(secondaryAccent).frame(maxWidth:.infinity, alignment:.center).padding(.top, 10)

                    VStack(spacing: 16) {
                        NavigationLink { BudgetEditorView() } label: {
                            HStack {
                                VStack(alignment:.leading, spacing: 4) {
                                    Text("Edit Budget").font(.system(size: 18, weight:.semibold)).foregroundStyle(secondaryAccent)
                                    Text("Update income and category budgets").font(.system(size: 14)).foregroundStyle(secondaryAccent.opacity(0.65))
                                }
                                Spacer()
                                Image(systemName: "chevron.right").font(.system(size: 14, weight:.semibold))
                            }.padding(16).background(RoundedRectangle(cornerRadius: 18, style:.continuous).fill(softBackground)).overlay {
                                RoundedRectangle(cornerRadius: 18, style:.continuous).stroke(fieldBorder, lineWidth: 1)
                            }
                        }.buttonStyle(.plain)

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
                        .onChange(of: notificationsEnabled) { _, newValue in
                            Task {
                                if newValue {
                                    let granted = await NotificationManager.shared.requestPermission()

                                    if granted {
                                        await NotificationManager.shared.scheduleDailyReminder()
                                    } else {
                                        notificationsEnabled = false
                                    }
                                } else {
                                    NotificationManager.shared.removeDailyReminder()
                                }
                            }
                        }
                    }.padding(18).background(Color.white).clipShape(RoundedRectangle(cornerRadius: 24, style:.continuous)).shadow(color:.black.opacity(0.05), radius: 12, y: 6)

                    Spacer()

                    Button("Log Out") {
                        showLogoutAlert = true
                    }.font(.system(size: 17, weight:.semibold)).foregroundStyle(.white).frame(maxWidth:.infinity).frame(height: 54).background(
                        RoundedRectangle(cornerRadius: 18, style:.continuous).fill(Color.accentColor)
                    ).padding(.bottom, 40)
                        .alert("Are you sure?", isPresented: $showLogoutAlert) {
                            Button("Cancel", role: .cancel) { }
                            Button("Log Out", role: .destructive) {
                                authModel.signOut()
                            }
                        } message: {
                            Text("You will need to sign in again to access your account.")
                        }
                }.padding(.horizontal, 20)
            }.navigationBarHidden(true)
        }
    }

    @ViewBuilder
    private func settingsToggleRow(title: String, subtitle: String, isOn: Binding<Bool>) -> some View {
        HStack(spacing: 14) {
            VStack(alignment:.leading, spacing: 4) {
                Text(title).font(.system(size: 18, weight:.semibold)).foregroundStyle(secondaryAccent)
                Text(subtitle).font(.system(size: 14)).foregroundStyle(secondaryAccent.opacity(0.65))
            }
            Spacer()
            Toggle("", isOn: isOn).labelsHidden()
        }.padding(16).background(RoundedRectangle(cornerRadius: 18, style:.continuous).fill(softBackground)).overlay {
            RoundedRectangle(cornerRadius: 18, style:.continuous).stroke(fieldBorder, lineWidth: 1)
        }
    }
}

#Preview {
    SettingsView().environment(AuthModel())
}
