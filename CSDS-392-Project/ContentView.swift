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
            HomeView()
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("Home")
                }
                .tag(0)
            
            ExpenseHistoryView()
                .tabItem {
                    Image(systemName: "dollarsign.circle")
                        .renderingMode(.template)
                    Text("Expenses")
                }
                .tag(1)
            
            AddExpenseView()
                .tabItem {
                    Image(systemName: "square.and.pencil")
                    Text("Add")
                }
                .tag(2)
            
            ReportsView()
                .tabItem {
                    Image(systemName: "chart.bar")
                        .renderingMode(.template)
                    Text("Reports")
                }
                .tag(3)
            
            SettingsView()
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
