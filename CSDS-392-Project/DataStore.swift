//
//  DataStore.swift
//  CSDS-392-Project
//
//  Created by Emi Hutter-DeMarco on 4/14/26.
//

import Foundation
import SwiftData

final class DataStore {
    
    func addExpense(amount: Double, category: Category, date: Date, note: String, context: ModelContext) {
        let expense = Expense(amount: amount, category: category, date: date, note: note)
        context.insert(expense)
    }
    
    func deleteExpense(_ expense: Expense, context: ModelContext) {
        context.delete(expense)
    }
    
    func updateExpense(_ expense: Expense, amount: Double, category: Category, date: Date, note: String) {
        expense.amount = amount
        expense.category = category
        expense.date = date
        expense.note = note
    }
    
    func addIncome(amount: Double, source: String, date: Date, context: ModelContext) {
        let income = Income(amount: amount, source: source, date: date)
        context.insert(income)
    }
    
    func deleteIncome(_ income: Income, context: ModelContext) {
        context.delete(income)
    }
    
    func updateIncome(_ income: Income, amount: Double, source: String, date: Date) {
        income.amount = amount
        income.source = source
        income.date = date
    }
}
