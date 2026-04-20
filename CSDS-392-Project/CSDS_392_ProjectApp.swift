//
//  CSDS_392_ProjectApp.swift
//  CSDS-392-Project
//
//  Created by Emi Hutter-DeMarco on 4/7/26.
//

import SwiftUI
import SwiftData
import FirebaseCore

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()
    return true
  }
}

@main
struct CSDS_392_ProjectApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @State private var authModel = AuthModel()
    
    var body: some Scene {
        WindowGroup {
            Group {
                if authModel.user != nil {
                    ContentView()
                } else {
                    LoginView()
                }
            }
            .environment(authModel)
        }
        .modelContainer(for: [Expense.self, Budget.self, CategoryBudget.self])
    }
}
