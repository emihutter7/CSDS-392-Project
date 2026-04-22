//
//  HomeViewModel.swift
//  CSDS-392-Project
//
//  Created by Alexandra Twitty on 4/22/26.
//

import Foundation
import SwiftUI

@Observable
@MainActor
final class HomeViewModel {

    // MARK: - Computed from injected data

    func budgetPeriod(from budgets: [Budget]) -> String {
        budgets.first?.incomePeriod ?? "Monthly"
    }

    func totalBudget(from categoryBudgets: [CategoryBudget]) -> Double {
        categoryBudgets.reduce(0) { $0 + $1.budgetAmount }
    }

    func totalSpent(from expenses: [Expense], budgets: [Budget]) -> Double {
        let period = budgetPeriod(from: budgets)
        return DateFilterHelper.filter(
            expenses.filter { $0.type == .expense },
            for: period
        ).reduce(0) { $0 + $1.amount }
    }

    func totalIncome(from expenses: [Expense], budgets: [Budget]) -> Double {
        let period = budgetPeriod(from: budgets)
        return DateFilterHelper.filter(
            expenses.filter { $0.type == .income },
            for: period
        ).reduce(0) { $0 + $1.amount }
    }

    func recentExpenses(from expenses: [Expense]) -> [Expense] {
        Array(expenses.prefix(5))
    }

    // MARK: - Formatting helpers

    func amountText(for expense: Expense) -> String {
        let prefix = expense.type == .income ? "+" : "-"
        return "\(prefix)$\(String(format: "%.2f", expense.amount))"
    }

    func amountColor(for type: TransactionType) -> Color {
        type == .income ? .green : Color(red: 0.55, green: 0.43, blue: 0.35)
    }

    func iconName(for type: TransactionType) -> String {
        type == .income ? "arrow.up.circle.fill" : "arrow.down.circle.fill"
    }
}
