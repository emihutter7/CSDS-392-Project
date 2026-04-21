//
//  ExpenseRowView.swift
//  CSDS-392-Project
//
//  Created by Alexandra Twitty on 4/18/26.
//

import SwiftUI

struct ExpenseRowView: View {
    let expense: Expense

    private let secondaryAccent = Color(red: 0.55, green: 0.43, blue: 0.35)
    private let borderColor = Color(red: 0.88, green: 0.80, blue: 0.81)

    private var amountColor: Color {
        expense.type == .income ? .green : .accentColor
    }

    private var iconName: String {
        expense.type == .income ? "arrow.down.circle.fill" : "creditcard.fill"
    }

    private var categoryLabel: String {
        expense.type == .income ? "Deposit" : expense.category
    }

    var body: some View {
        HStack(alignment: .top, spacing: 14) {
            Circle()
                .frame(width: 42, height: 42)
                .foregroundStyle(amountColor.opacity(0.18))
                .overlay {
                    Image(systemName: iconName)
                        .font(.system(size: 16))
                        .foregroundStyle(amountColor)
                }

            VStack(alignment: .leading, spacing: 8) {
                HStack(alignment: .firstTextBaseline) {
                    Text(expense.title)
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundStyle(secondaryAccent)

                    Spacer()

                    Text(
                        expense.type == .income
                        ? "+\(expense.amount.formatted(.number.precision(.fractionLength(2))))"
                        : expense.amount.formatted(.currency(code: "USD"))
                    )
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundStyle(amountColor)
                }

                HStack(spacing: 8) {
                    Text(categoryLabel)
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundStyle(amountColor)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 6)
                        .background(amountColor.opacity(0.12))
                        .clipShape(Capsule())

                    Spacer()
                }

                Text(expense.note.isEmpty ? "No notes added" : expense.note)
                    .font(.system(size: 14))
                    .foregroundStyle(secondaryAccent.opacity(0.72))
                    .lineLimit(2)
            }

            Image(systemName: "square.and.pencil")
                .font(.system(size: 18, weight: .medium))
                .foregroundStyle(secondaryAccent.opacity(0.65))
                .padding(.top, 2)
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
        .overlay {
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .stroke(borderColor, lineWidth: 1)
        }
        .shadow(color: .black.opacity(0.04), radius: 8, y: 4)
    }
}
