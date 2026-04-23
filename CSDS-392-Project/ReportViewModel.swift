//
//  ReportViewModel.swift
//  CSDS-392-Project
//
//  Created by Iciar Sanz on 20/4/26.
//

import Foundation
import SwiftUI

struct ChartSlice {
    let name: String
    let amount: Double
    let color: Color
}

struct BudgetBreakdownItem {
    let name: String
    let spent: Double
    let budget: Double
}

@Observable
@MainActor
final class ReportsViewModel {

    let chartColors: [Color] = [
        Color(red: 0.75, green: 0.55, blue: 0.60),
        Color(red: 0.55, green: 0.43, blue: 0.35),
        Color(red: 0.88, green: 0.80, blue: 0.81),
        Color(red: 0.83, green: 0.70, blue: 0.73),
        Color(red: 0.91, green: 0.86, blue: 0.84),
        Color(red: 0.65, green: 0.48, blue: 0.50),
        Color(red: 0.70, green: 0.60, blue: 0.55),
        Color(red: 0.80, green: 0.72, blue: 0.68)
    ]

    func budgetPeriod(from budgets: [Budget]) -> String {
        budgets.first?.incomePeriod ?? "Monthly"
    }

    func periodLabel(from budgets: [Budget]) -> String {
        let period = budgetPeriod(from: budgets)
        let formatter = DateFormatter()
        let now = Date()

        switch period {
        case "Weekly":
            formatter.dateFormat = "MMM d"
            let start = DateFilterHelper.startDate(for: "Weekly")
            return "Week of \(formatter.string(from: start))"
        case "Yearly":
            formatter.dateFormat = "yyyy"
            return formatter.string(from: now)
        case "Daily":
            formatter.dateFormat = "MMM d, yyyy"
            return formatter.string(from: now)
        default:
            formatter.dateFormat = "MMMM yyyy"
            return formatter.string(from: now)
        }
    }

    func periodExpenses(from expenses: [Expense], budgets: [Budget]) -> [Expense] {
        DateFilterHelper.filter(
            expenses.filter { $0.type == .expense },
            for: budgetPeriod(from: budgets)
        )
    }

    func categoryTotals(from expenses: [Expense], budgets: [Budget]) -> [String: Double] {
        Dictionary(
            grouping: periodExpenses(from: expenses, budgets: budgets),
            by: { $0.category }
        ).mapValues { $0.reduce(0) { $0 + $1.amount } }
    }

    func breakdownItems(
        expenses: [Expense],
        categoryBudgets: [CategoryBudget],
        budgets: [Budget]
    ) -> [BudgetBreakdownItem] {
        let totals = categoryTotals(from: expenses, budgets: budgets)
        return categoryBudgets.map { category in
            BudgetBreakdownItem(
                name: category.name,
                spent: totals[category.name] ?? 0,
                budget: category.budgetAmount
            )
        }
    }

    func chartData(from expenses: [Expense], budgets: [Budget]) -> [ChartSlice] {
        categoryTotals(from: expenses, budgets: budgets).filter { $0.value > 0 }.sorted { $0.value > $1.value }.enumerated().map { index, item in
                ChartSlice(
                    name: item.key,
                    amount: item.value,
                    color: chartColors[index % chartColors.count]
                )
            }
    }

    func progressValue(spent: Double, budget: Double) -> Double {
        guard budget > 0 else { return 0 }
        return min(spent / budget, 1.0)
    }

    func totalChartAmount(from slices: [ChartSlice]) -> Double {
        slices.reduce(0) { $0 + $1.amount }
    }

    func percentage(for slice: ChartSlice, in slices: [ChartSlice]) -> Int {
        let total = totalChartAmount(from: slices)
        guard total > 0 else { return 0 }
        return Int(slice.amount / total * 100)
    }
}
