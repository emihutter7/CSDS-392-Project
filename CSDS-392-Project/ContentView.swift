//
//  ContentView.swift
//  CSDS-392-Project
//
//  Created by Emi Hutter-DeMarco on 4/7/26.
//

import SwiftUI

struct ContentView: View {
    @Environment(AuthModel.self) private var authModel
    @State private var showSignOut = false
    
    var body: some View {
        NavigationStack {
            Text("Welcome!")
            Spacer()
            
            
            }
        .navigationDestination(isPresented: $showSignOut) {
                        SignOutView()
                    }
        .toolbar {
            ToolbarItem(placement: .bottomBar) {
                Button (action: {}){
                    Image(systemName: "house.fill")
                        .resizable()
                        .scaledToFit()
                }
            }
            ToolbarItem(placement: .bottomBar) {
                Button (action: {}){
                    Image("ExpensesIcon")
                        .resizable()
                        .scaledToFit()
                }
            }
            ToolbarItem(placement: .bottomBar) {
                Button (action: {}){
                    Image(systemName: "square.and.pencil")
                        .resizable()
                        .scaledToFit()
                }
            }
            ToolbarItem(placement: .bottomBar) {
                Button (action: {}){
                    Image("ReportsIcon")
                        .resizable()
                        .scaledToFit()
                }
            }
            ToolbarItem(placement: .bottomBar) {
                Button(action: {
                    showSignOut = true
                }) {
                    Image(systemName: "gearshape.fill")
                        .resizable()
                        .scaledToFit()
                }
            }
        }
        .padding()
    }
}

#Preview {
    ContentView()
        .environment(AuthModel())
}
