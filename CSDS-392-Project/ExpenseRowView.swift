//
//  ExpenseRowView.swift
//  CSDS-392-Project
//
//  Created by Alexandra Twitty on 4/18/26.
//

import SwiftUI

struct ExpenseRowView: View {
    let expense: Expense

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            VStack(alignment: .leading, spacing: 6) {
                HStack(spacing: 10) {
                    Text("-\(expense.title)")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundStyle(.white)

                    Text(expense.amount, format: .currency(code: "USD"))
                        .font(.system(size: 18, weight: .medium))
                        .foregroundStyle(.white)

                    Text(expense.category)
                        .font(.system(size: 18, weight: .medium))
                        .foregroundStyle(.white)
                }

                Text(expense.note.isEmpty ? "Notes" : expense.note)
                    .font(.system(size: 13))
                    .foregroundStyle(.white.opacity(0.9))
            }

            Spacer()

            Image(systemName: "square.and.pencil")
                .font(.system(size: 22))
                .foregroundStyle(.black.opacity(0.7))
                .padding(.top, 2)
        }
    }
}
