//
//  SummaryCard.swift
//  CSDS-392-Project
//
//  Created by Alexandra Twitty on 4/16/26.
//
import SwiftUI

struct SummaryCard: View {
    let total: Double
    let spent: Double

    private var remaining: Double {
        total - spent
    }

    private var progress: Double {
        guard total > 0 else { return 0 }
        return min(spent / total, 1.0)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Monthly Summary")
                .font(.title2)
                .fontWeight(.semibold)

            VStack(alignment: .leading, spacing: 8) {
                Text("Total: \(total, format: .currency(code: "USD"))")
                Text("Spent: \(spent, format: .currency(code: "USD"))")
                Text("Remaining: \(remaining, format: .currency(code: "USD"))")
            }
            .font(.title3)

            ProgressView(value: progress)
                .progressViewStyle(.linear)
        }
        .padding(24)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(.systemGray6))
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }
}

#Preview {
    SummaryCard(total: 0, spent: 0)
}
