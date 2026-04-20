//
//  ContentView.swift
//  CSDS-392-Project
//
//  Created by Emi Hutter-DeMarco on 4/7/26.
//

import SwiftUI

struct ContentView: View {
    @Environment(AuthModel.self) private var authModel
    @State private var selectedTab = 0

    var body: some View {
        TabView(selection: $selectedTab) {
            NavigationStack {
                HomeView()
            }
            .tabItem {
                Image(systemName: "house.fill")
                Text("Home")
            }
            .tag(0)

            NavigationStack {
                ExpenseHistoryView()
            }
            .tabItem {
                Image(systemName: "dollarsign.circle")
                Text("Expenses")
            }
            .tag(1)

            NavigationStack {
                AddExpenseView()
            }
            .tabItem {
                Image(systemName: "plus.circle.fill")
                Text("Add")
            }
            .tag(2)

            NavigationStack {
                ReportsView()
            }
            .tabItem {
                Image(systemName: "chart.bar")
                Text("Reports")
            }
            .tag(3)

            NavigationStack {
                SettingsView()
            }
            .tabItem {
                Image(systemName: "gearshape.fill")
                Text("Settings")
            }
            .tag(4)
        }
    }
}

#Preview {
    ContentView()
        .environment(AuthModel())
}
