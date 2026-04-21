//
//  ExpenseViewModel.swift
//  CSDS-392-Project
//
//  Created by Iciar Sanz on 20/4/26.
//

import Foundation
import SwiftUI
import SwiftData

@Observable
@MainActor
final class ExpenseViewModel {

    //the values that the user writes in addexpenseview and editexpenseview
    var title = ""
    var amountText = ""
    var selectedCategory = "Food"
    var date = Date()
    var note = ""
    var showSavedMessage = false

    // filters for expensehistoryview
    var searchText = ""
    var selectedFilterCategory = "All"

    // categories
    let categories = ["Food", "Rent", "Fun", "Transport", "Education"] //for the picker
    let filterCategories = ["All", "Food", "Rent", "Fun", "Transport", "Education"]

   //everything goes back to blank, used to open the addexpenseview and after saving a new expense
    func resetForm() {
        title = ""
        amountText = ""
        selectedCategory = "Food"
        date = Date()
        note = ""
        showSavedMessage = false
    }

    //used to update expenses
    func loadExpense(_ expense: Expense) {
        title = expense.title
        amountText = String(format: "%.2f", expense.amount) //changes the type to string
        selectedCategory = expense.category
        date = expense.date
        note = expense.note
    }

    // saves new expense

    func saveNew(in context: ModelContext) {
        let trimmedTitle = title.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedNote = note.trimmingCharacters(in: .whitespacesAndNewlines)
        //if the title is empty or the amount is not a number it exits the funtion and doesnt save anything
        guard !trimmedTitle.isEmpty,
              let amount = Double(amountText) else { return }

        let expense = Expense(
            title: trimmedTitle,
            amount: amount,
            category: selectedCategory,
            date: date,
            note: trimmedNote
        )
        context.insert(expense) //adds the expense to swiftdata so its saved in the phone database

        resetForm()
        showSavedMessage = true
        
        //shows "expense saved" in the screen for 1.5s"
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            self.showSavedMessage = false
        }
    }

    // saves edits of an already created expense, returns T/F so the view knows whetn to close the window
    func saveEdit(_ expense: Expense, in context: ModelContext) -> Bool {
        guard let amount = Double(amountText),
              !title.trimmingCharacters(in: .whitespaces).isEmpty else { return false }

        expense.title = title
        expense.amount = amount
        expense.category = selectedCategory
        expense.date = date
        expense.note = note

        do {
            try context.save()
            return true
        } catch {
            print("saving error: \(error)")
            return false
        }
    }

    // deletes an expense form the database with swiftdata
    func delete(_ expense: Expense, from context: ModelContext) {
        context.delete(expense)
    }

    // receives all the expenses and gives only the ones that fullfil the 2 conditions

    func filtered(_ expenses: [Expense]) -> [Expense] {
        expenses.filter { expense in
            let matchesSearch = searchText.isEmpty
                || expense.title.localizedCaseInsensitiveContains(searchText)
                || expense.category.localizedCaseInsensitiveContains(searchText)
                || expense.note.localizedCaseInsensitiveContains(searchText)

            let matchesCategory = selectedFilterCategory == "All"
                || expense.category == selectedFilterCategory

            return matchesSearch && matchesCategory
        }
    }

    // sums up evething to get the total amount
    func totalSpent(_ expenses: [Expense]) -> Double {
        expenses.reduce(0) { $0 + $1.amount }
    }

    // takes the 5 most recent expenses for homeview

    func recent(_ expenses: [Expense]) -> [Expense] {
        Array(expenses.prefix(5))
    }

    // totals by category for reportsview , for top categories

    func totalsByCategory(_ expenses: [Expense]) -> [(category: String, total: Double)] {
        Dictionary(grouping: expenses) { $0.category }
            .map { (category: $0.key, total: $0.value.reduce(0) { $0 + $1.amount }) }
            .sorted { $0.total > $1.total }
    }
}
