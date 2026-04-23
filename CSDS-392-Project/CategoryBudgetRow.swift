//
//  CategoryBudgetRow.swift
//  CSDS-392-Project
//
//  Created by Alexandra Twitty on 4/18/26.
//

import SwiftUI
import SwiftData

struct CategoryBudgetRow: View {
    @Environment(\.modelContext) private var modelContext
    let category: CategoryBudget

    @State private var amountText = ""

    private let secondaryAccent = Color("SecondaryAccent")
    private let fieldBorder = Color("FieldBorder")

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text(category.name)
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundStyle(secondaryAccent)

                Spacer()

                Button(role: .destructive) {
                    deleteCategory()
                } label: {
                    Image(systemName: "trash")
                        .font(.system(size: 16, weight: .medium))
                }
            }

            TextField("Value", text: $amountText)
                .keyboardType(.decimalPad)
                .foregroundStyle(secondaryAccent)
                .padding(.horizontal, 14)
                .frame(height: 48)
                .background(Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                .overlay {
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .stroke(fieldBorder, lineWidth: 1.5)
                }
                .onChange(of: amountText) { _, newValue in
                    category.budgetAmount = Double(newValue) ?? 0
                    try? modelContext.save()
                }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .fill(Color(red: 0.99, green: 0.98, blue: 0.97))
        )
        .onAppear {
            amountText = category.budgetAmount == 0 ? "" : String(category.budgetAmount)
        }
    }

    private func deleteCategory() {
        modelContext.delete(category)
        try? modelContext.save()
    }
}
