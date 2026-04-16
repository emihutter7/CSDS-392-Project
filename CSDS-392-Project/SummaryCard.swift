//
//  SummaryCard.swift
//  CSDS-392-Project
//
//  Created by Alexandra Twitty on 4/16/26.
//
import SwiftUI

struct SummaryCard: View {
    let total: Int
    let spent: Int
    
    var remaining: Int { total - spent }
    
    var body: some View {
        VStack (spacing: 6) {
            Text("Monthly Summary")
                .font(.headline)
                .fontWeight(.semibold)
            Text("Total: $\(total)")
            Text("Spent: $\(spent)")
            Text("Remaining: $\(remaining)")
            
        }
        .font(.body)
        .padding(30)
        .background(Color(.systemGray6))
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y:2)
    }
}

#Preview {
    SummaryCard(total: 2000, spent: 1000)
}
