//
//  ExpenseRowView.swift
//  CSDS-392-Project
//
//  Created by Alexandra Twitty on 4/18/26.
//

import SwiftUI

struct ExpenseRowView: View {
    let expense: Expense

    private let backgroundColor = Color(red: 0.97, green: 0.95, blue: 0.94)
    private let accentColor = Color(red: 0.75, green: 0.55, blue: 0.60)
    private let secondaryAccent = Color(red: 0.55, green: 0.43, blue: 0.35)
    private let borderColor = Color(red: 0.88, green: 0.80, blue: 0.81)

    var body: some View {
        HStack(alignment: .top, spacing: 14) {
            Circle()
                .fill(accentColor.opacity(0.14))
                .frame(width: 42, height: 42)
                .overlay {
                    Image(systemName: "creditcard.fill")
                        .font(.system(size: 16))
                        .foregroundStyle(accentColor)
                }

            VStack(alignment: .leading, spacing: 8) {
                HStack(alignment: .firstTextBaseline) {
                    Text(expense.title)
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundStyle(secondaryAccent)

                    Spacer()

                    Text(expense.amount, format: .currency(code: "USD"))
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundStyle(accentColor)
                }

                HStack(spacing: 8) {
                    Text(expense.category)
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundStyle(accentColor)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 6)
                        .background(accentColor.opacity(0.12))
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
