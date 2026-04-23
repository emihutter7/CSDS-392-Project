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

    private let backgroundColor = Color.white
    private let secondaryAccent = Color("SecondaryAccent")
    private let softBackground = Color("SoftBackground")

    private var remaining: Double {
        max(total - spent, 0)
    }

    private var progress: Double {
        guard total > 0 else { return 0 }
        return min(spent / total, 1.0)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            VStack(spacing: 14) {
                summaryRow(title: "Total Budget", value: total)
                summaryRow(title: "Spent", value: spent)
                summaryRow(title: "Remaining", value: remaining)
            }

            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text("Spending Progress")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundStyle(secondaryAccent.opacity(0.8))

                    Spacer()

                    Text("\(Int(progress * 100))%")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundStyle(Color.accentColor)
                }

                ProgressView(value: progress)
                    .progressViewStyle(.linear)
                    .scaleEffect(y: 1.8)
            }
        }
        .padding(.horizontal, 18)
        .padding(.vertical, 20)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(backgroundColor)
        .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
        .shadow(color: .black.opacity(0.05), radius: 12, y: 6)
    }

    @ViewBuilder
    private func summaryRow(title: String, value: Double) -> some View {
        HStack {
            Text(title)
                .font(.system(size: 17, weight: .medium))
                .foregroundStyle(secondaryAccent)

            Spacer()

            Text(value.formatted(.currency(code: "USD")))
                .font(.system(size: 17, weight: .semibold))
                .foregroundStyle(Color.accentColor)
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(softBackground)
        )
    }
}

#Preview {
    SummaryCard(total: 1200, spent: 450)
        .padding()
        .background(Color(red: 0.97, green: 0.95, blue: 0.94))
}
