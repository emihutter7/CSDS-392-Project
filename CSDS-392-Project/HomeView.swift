//
//  HomeView.swift
//  CSDS-392-Project
//
//  Created by Alexandra Twitty on 4/14/26.
//
import SwiftUI

struct HomeView: View {
    var body: some View {
        ScrollView {
            VStack (spacing: 40){
                Text("Home")
                    .font(.largeTitle)
                SummaryCard(total: 2000, spent: 1000)
                    .frame(maxWidth: .infinity)
                
            }
            .padding()
        }
    }
}

#Preview {
    HomeView()
}
