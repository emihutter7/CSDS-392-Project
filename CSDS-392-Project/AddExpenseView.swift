//
//  AddExpenseView.swift
//  CSDS-392-Project
//
//  Created by Alexandra Twitty on 4/14/26.
//
import SwiftUI
import SwiftData

struct AddExpenseView: View {
    @Environment(\.modelContext) private var modelContext

    @State private var title = ""
    @State private var amount = ""
    @State private var category = ""
    @State private var note = ""

    var body: some View {
        Form {
            TextField("Amount", text: $amount)
                .keyboardType(.decimalPad)

            TextField("Category", text: $category)
            TextField("Note", text: $note)

            Button("Save Expense") {
                guard let amountValue = Double(amount),
                      !category.trimmingCharacters(in: .whitespaces).isEmpty else { return }

                let newExpense = Expense(
                    title: title,
                    amount: amountValue,
                    category: category,
                    date: Date(),
                    note: note
                )

                modelContext.insert(newExpense)

                amount = ""
                category = ""
                note = ""
            }
        }
    }
}

#Preview {
    AddExpenseView()
}
