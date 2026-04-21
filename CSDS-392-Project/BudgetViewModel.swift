//
//  BudgetViewModel.swift
//  CSDS-392-Project
//
//  Created by Iciar Sanz on 20/4/26.
//

import Foundation
import SwiftUI
import SwiftData

@Observable
@MainActor
final class BudgetViewModel {

    var incomeText = ""
    var incomePeriod = "Monthly" // picker: monthly, weekly, dayly, yearly..
    var newCategoryTitle = ""
    var showSavedMessage = false
   
    // alerts for deleting categories when it is assinged to some budget
    var showDeleteAlert = false
    var alertCategoryName = ""
    
    let periods = ["Monthly", "Yearly", "Weekly", "Daily"]
    
    //given categories, the user can add more
    let defaultCategoryNames = [
        "Food", "Rent", "Transportation", "Fun",
        "Education", "Shopping", "Health", "Subscriptions"
    ]

    // loads the budged to the formulary, its called by the onappear on the budgeteditorview
    func load(from budget: Budget?) {
        guard let budget = budget else {
            incomeText = ""
            incomePeriod = "Monthly"
            return
        }
        if budget.income == 0 {
            incomeText = ""
        } else if budget.income == floor(budget.income) {
            incomeText = String(Int(budget.income))
        } else {
            incomeText = String(budget.income)
        }
        incomePeriod = budget.incomePeriod
    }

    // creates budget if it doesnt exist, used when the user first opens the app
    func ensureBudgetExists(budgets: [Budget], context: ModelContext) {
        if budgets.isEmpty {
            context.insert(Budget())
            try? context.save() //tries to save, if it gives an error it continues so the app doesnt crash
        }
    }

    // it creates the default categories if they dont exist already
    func seedCategoriesIfNeeded(existing: [CategoryBudget], context: ModelContext) {
        if existing.isEmpty {
            for name in defaultCategoryNames {
                context.insert(CategoryBudget(name: name))
            }
            try? context.save()
        }
    }

    // saves the budget
    func saveBudget(_ budget: Budget?, in context: ModelContext) {
        guard let budget = budget else { return } //checks if theres budget

        budget.income = Double(incomeText) ?? 0
        budget.incomePeriod = incomePeriod
        
        //saves the changes to the disc
        do {
            try context.save()
            showSavedMessage = true
            //shows "budget saved" for 1.5s
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                self.showSavedMessage = false
            }
        } catch {
            print("saving error : \(error)")
        }
    }

    // adds new category for budget

    func addCategory(in context: ModelContext) {
        let trimmed = newCategoryTitle.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return } //prevents from adding blank categories

        context.insert(CategoryBudget(name: trimmed)) //creates new category and insters it to swift data
        newCategoryTitle = ""
        try? context.save()
    }
    // gives true if the category has expenses
    func tryDeleteCategory(_ category: CategoryBudget, expenses: [Expense], from context: ModelContext) {
        // it goes through all the data and searches for any one with that category, if it finds one it stops and gives true
            if expenses.contains(where: { $0.category == category.name }) {
                alertCategoryName = category.name
                showDeleteAlert = true
                return //exits the function without deleting
            }

            context.delete(category)
            try? context.save()
        }
   

    // calculates total budget for the summary card in home

    func totalBudget(_ categories: [CategoryBudget]) -> Double {
        categories.reduce(0) { $0 + $1.budgetAmount }
    }

    // how mucha money is left, if its negative it says 0
    func remaining(categories: [CategoryBudget], spent: Double) -> Double {
        max(totalBudget(categories) - spent, 0)
    }
}
