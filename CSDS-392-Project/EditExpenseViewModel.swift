//
//  EditExpenseViewModel.swift
//  CSDS-392-Project
//
//  Created by Alexandra Twitty on 4/22/26.
//

import Foundation
import SwiftUI
import SwiftData

@Observable
@MainActor
final class EditExpenseViewModel {

    var title = ""
    var category = ""
    var date = Date()
    var amount = ""
    var note = ""
    var transactionType: TransactionType = .expense
    var newCategoryTitle = ""
    var showAddCategoryField = false

    func availableCategories(from categoryBudgets: [CategoryBudget]) -> [String] {
        let saved = categoryBudgets.map(\.name)
        return saved.isEmpty
            ? ["Food", "Bills", "Shopping", "Transportation", "Entertainment", "Salary", "Other"]
            : saved
    }

    func load(from expense: Expense, categories: [CategoryBudget]) {
        title = expense.title
        category = expense.category
        date = expense.date
        amount = String(format: "%.2f", expense.amount)
        note = expense.note
        transactionType = expense.type

        if category.isEmpty {
            category = availableCategories(from: categories).first ?? "Other"
        }
    }

    func saveChanges(
        to expense: Expense,
        categoryBudgets: [CategoryBudget],
        context: ModelContext
    ) -> Bool {
        guard let amountValue = Double(amount),
              amountValue > 0,
              !title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            return false
        }

        expense.title = title.trimmingCharacters(in: .whitespacesAndNewlines)
        expense.category = category.isEmpty ? "Other" : category
        expense.date = date
        expense.amount = amountValue
        expense.note = note.trimmingCharacters(in: .whitespacesAndNewlines)
        expense.type = transactionType

        do {
            try context.save()
            return true
        } catch {
            print("Failed to save edited expense: \(error)")
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
}
