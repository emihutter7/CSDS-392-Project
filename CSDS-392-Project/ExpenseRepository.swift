//
//  ExpenseRepository.swift
//  CSDS-392-Project
//
//  Created by Emi Hutter-DeMarco on 4/15/26.
//

import Foundation
import SwiftData

final class ExpenseRepository {
    
    func createExpense(
        amount: Double,
        category: Category,
        date: Date,
        note: String,
        context: ModelContext
    ) {
        let expense = Expense(amount: amount, category: category, date: date, note: note)
        context.insert(expense)
    }
    
    func updateExpense(
        _ expense: Expense,
        amount: Double,
        category: Category,
        date: Date,
        note: String
    ) {
        expense.amount = amount
        expense.category = category
        expense.date = date
        expense.note = note
    }
    
    func deleteExpense(_ expense: Expense, context: ModelContext) {
        context.delete(expense)
    }
    
    func fetchExpenses(context: ModelContext) -> [Expense] {
        let descriptor = FetchDescriptor<Expense>(
            sortBy: [SortDescriptor(\Expense.date, order: .reverse)]
        )
        
        do {
            return try context.fetch(descriptor)
        } catch {
            print("Error fetching expenses: \(error.localizedDescription)")
            return []
        }
    }
}
