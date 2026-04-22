//
//  AddExpenseViewModel.swift
//  CSDS-392-Project
//
//  Created by Alexandra Twitty on 4/22/26.
//

import SwiftUI
import SwiftData

@Observable
@MainActor
final class AddExpenseViewModel {

    var title = ""
    var category = "Food"
    var date = Date()
    var amount = ""
    var note = ""
    var transactionType: TransactionType = .expense
    var showSavedMessage = false
    var newCategoryTitle = ""

    var buttonTitle: String {
        transactionType == .income ? "Add Income" : "Add Expense"
    }

    var inputPlaceholder: String {
        transactionType == .income ? "Income title" : "Expense title"
    }

    func availableCategories(from categoryBudgets: [CategoryBudget]) -> [String] {
        let saved = categoryBudgets.map(\.name)
        return saved.isEmpty
            ? ["Food", "Bills", "Shopping", "Transportation", "Entertainment", "General", "Other"]
            : saved
    }

    func seedDefaultCategories(existing: [CategoryBudget], context: ModelContext) {
        guard existing.isEmpty else { return }
        let defaults = ["Food", "Bills", "Shopping", "Transportation",
                        "Entertainment", "General", "Other"]
        for item in defaults {
            context.insert(CategoryBudget(name: item))
        }
        try? context.save()
    }

    func saveTransaction(categoryBudgets: [CategoryBudget], context: ModelContext) -> Bool {
        let trimmedTitle = title.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedNote = note.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedNewCategory = newCategoryTitle.trimmingCharacters(in: .whitespacesAndNewlines)

        guard !trimmedTitle.isEmpty,
              let amountValue = Double(amount),
              amountValue > 0 else { return false }

        let finalCategory = trimmedNewCategory.isEmpty ? category : trimmedNewCategory

        let alreadyExists = categoryBudgets.contains {
            $0.name.localizedCaseInsensitiveCompare(finalCategory) == .orderedSame
        }

        if !finalCategory.isEmpty && !alreadyExists {
            context.insert(CategoryBudget(name: finalCategory))
        }

        let transaction = Expense(
            title: trimmedTitle,
            amount: amountValue,
            category: finalCategory.isEmpty ? "Other" : finalCategory,
            date: date,
            note: trimmedNote,
            type: transactionType
        )

        context.insert(transaction)

        do {
            try context.save()
            resetForm(categories: categoryBudgets)
            showSavedMessage = true
            return true
        } catch {
            print("Failed to save transaction: \(error)")
            return false
        }
    }

    func addCategory(
        newTitle: String,
        categoryBudgets: [CategoryBudget],
        context: ModelContext
    ) -> String? {
        let trimmed = newTitle.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return nil }

        let alreadyExists = categoryBudgets.contains {
            $0.name.localizedCaseInsensitiveCompare(trimmed) == .orderedSame
        }

        if !alreadyExists {
            context.insert(CategoryBudget(name: trimmed))
            try? context.save()
        }

        return trimmed
    }

    private func resetForm(categories: [CategoryBudget]) {
        title = ""
        amount = ""
        newCategoryTitle = ""
        note = ""
        date = Date()
        transactionType = .expense
        category = categories.first?.name ?? "Food"
    }
}
