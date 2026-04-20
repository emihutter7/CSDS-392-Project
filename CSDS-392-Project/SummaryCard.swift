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
        max(total - spent, 0)
    }

    private var progress: Double {
        guard total > 0 else { return 0 }
        return min(spent / total, 1.0)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 22) {
            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    Text("Total Budget:")
                    Spacer()
                    Text(total.formatted(.currency(code: "USD")))
                }

                HStack {
                    Text("Spent:")
                    Spacer()
                    Text(spent.formatted(.currency(code: "USD")))
                }

                HStack {
                    Text("Remaining:")
                    Spacer()
                    Text(remaining.formatted(.currency(code: "USD")))
                }
            }
            .font(.system(size: 20, weight: .medium))
            .foregroundStyle(.white)

            ProgressView(value: progress)
                .progressViewStyle(.linear)
                .tint(.blue)
                .scaleEffect(y: 1.6)
        }
        .padding(.horizontal, 18)
        .padding(.vertical, 22)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.clear)
    }
}

#Preview {
    SummaryCard(total: 0, spent: 0)
}
