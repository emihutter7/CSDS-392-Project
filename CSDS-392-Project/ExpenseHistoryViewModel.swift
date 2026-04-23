//
//  ExpenseHistoryViewModel.swift
//  CSDS-392-Project
//
//  Created by Alexandra Twitty on 4/22/26.
//

import Foundation
import SwiftUI
import SwiftData

enum TransactionFilter: String, CaseIterable, Identifiable {
    case all = "All"
    case expenses = "Expenses"
    case income = "Income"
    var id: String { rawValue }
}

@Observable
@MainActor
final class ExpenseHistoryViewModel {

    var selectedFilter: TransactionFilter = .all
    var selectedCategory: String = "All"

    func availableCategories(from expenses: [Expense]) -> [String] {
        let names = Set(expenses.map(\.category).filter { !$0.isEmpty })
        return ["All"] + names.sorted()
    }

    func filteredExpenses(from expenses: [Expense]) -> [Expense] {
        expenses.filter { expense in
            let matchesType: Bool
            switch selectedFilter {
            case .all:      matchesType = true
            case .expenses: matchesType = expense.type == .expense
            case .income:   matchesType = expense.type == .income
            }
            let matchesCategory = selectedCategory == "All"
                || expense.category == selectedCategory
            return matchesType && matchesCategory
        }
    }

    func delete(_ expense: Expense, context: ModelContext) {
        context.delete(expense)
        try? context.save()
    }
    
    func amountText(for expense: Expense) -> String {
        let prefix = expense.type == .income ? "+" : "-"
        return "\(prefix)$\(String(format: "%.2f", expense.amount))"
    }

    func amountColor(for type: TransactionType) -> Color {
        type == .income ? .green : Color.accentColor
    }

    func iconName(for type: TransactionType) -> String {
        type == .income ? "arrow.up.circle.fill" : "arrow.down.circle.fill"
    }

    func iconBackground(for type: TransactionType) -> Color {
        type == .income ? Color.green.opacity(0.14) : Color.accentColor.opacity(0.14)
    }

    func iconForeground(for type: TransactionType) -> Color {
        type == .income ? .green : Color.accentColor
    }
}
