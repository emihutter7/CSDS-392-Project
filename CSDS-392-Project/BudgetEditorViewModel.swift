//
//  BudgetEditorViewModel.swift
//  CSDS-392-Project
//
//  Created by Alexandra Twitty on 4/22/26.
//

import Foundation
import SwiftData

@Observable
@MainActor
final class BudgetEditorViewModel {

    var income = ""
    var incomePeriod = "Monthly"
    var newCategoryTitle = ""
    var showSavedMessage = false

    let periods = ["Monthly", "Yearly", "Weekly", "Daily"]

    func load(from budgets: [Budget]) {
        if let budget = budgets.first {
            income = budget.income == 0 ? "" : String(budget.income)
            incomePeriod = budget.incomePeriod
        }
    }

    func save(budgets: [Budget], context: ModelContext, completion: @escaping () -> Void) {
        let budget: Budget

        if let existing = budgets.first {
            budget = existing
        } else {
            let newBudget = Budget()
            context.insert(newBudget)
            budget = newBudget
        }

        budget.income = Double(income) ?? 0
        budget.incomePeriod = incomePeriod

        do {
            try context.save()
            showSavedMessage = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                self.showSavedMessage = false
                completion()
            }
        } catch {
            print("Failed to save budget: \(error)")
        }
    }

    func addCategory(context: ModelContext) {
        let trimmed = newCategoryTitle.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }
        context.insert(CategoryBudget(name: trimmed))
        newCategoryTitle = ""
        try? context.save()
    }
}
