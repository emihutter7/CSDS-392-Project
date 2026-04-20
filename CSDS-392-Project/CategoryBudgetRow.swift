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

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text(category.name)
                    .font(.system(size: 24, weight: .medium))
                    .foregroundStyle(.white)

                Spacer()

                Button(role: .destructive) {
                    deleteCategory()
                } label: {
                    Image(systemName: "trash")
                        .foregroundStyle(.white)
                }
            }

            TextField("Value", text: $amountText)
                .keyboardType(.decimalPad)
                .padding(.horizontal, 12)
                .frame(width: 240, height: 42)
                .background(.white)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .onChange(of: amountText) { _, newValue in
                    category.budgetAmount = Double(newValue) ?? 0
                    try? modelContext.save()
                }
        }
        .onAppear {
            amountText = category.budgetAmount == 0 ? "" : String(category.budgetAmount)
        }
    }

    private func deleteCategory() {
        modelContext.delete(category)
        try? modelContext.save()
    }
}
