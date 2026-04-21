//
//  SettingViewModel.swift
//  CSDS-392-Project
//
//  Created by Iciar Sanz on 20/4/26.
//


import Foundation
import SwiftUI

@Observable
@MainActor
final class SettingsViewModel {
    //when toggle happens it automatically saves in user defaults
    var isDarkMode: Bool {
        didSet { UserDefaults.standard.set(isDarkMode, forKey: "darkModeEnabled") }
    }

    var notificationsEnabled: Bool {
        didSet { UserDefaults.standard.set(notificationsEnabled, forKey: "notificationsEnabled") }
    }

    init() {
        let defaults = UserDefaults.standard
        self.isDarkMode = defaults.bool(forKey: "darkModeEnabled")
        if defaults.object(forKey: "notificationsEnabled") == nil {
            self.notificationsEnabled = true
        } else {
            self.notificationsEnabled = defaults.bool(forKey: "notificationsEnabled")
        }
    }
    //changes the preferrences to dark or light
    var preferredColorScheme: ColorScheme? {
        isDarkMode ? .dark : .light
    }
    //tells authmodel to sign out, this way settings view only tallks with settingsviewmodel and it doesnt have to import the logic directly
    func signOut(using auth: AuthModel) {
        auth.signOut()
    }
}
