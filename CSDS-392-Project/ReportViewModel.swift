//
//  ReportViewModel.swift
//  CSDS-392-Project
//
//  Created by Iciar Sanz on 20/4/26.
//


import Foundation
import SwiftUI

@Observable
@MainActor
final class ReportViewModel {

    // MARK: - Cuánto se gastó por categoría

    func categoryTotals(_ expenses: [Expense]) -> [String: Double] {
        Dictionary(grouping: expenses) { $0.category }
            .mapValues { $0.reduce(0) { $0 + $1.amount } }
    }

    // MARK: - Desglose: gastado vs presupuestado por categoría

    func breakdown(
        categories: [CategoryBudget],
        expenses: [Expense]
    ) -> [(name: String, spent: Double, budget: Double)] {
        let totals = categoryTotals(expenses)
        return categories.map { cat in
            (name: cat.name, spent: totals[cat.name] ?? 0, budget: cat.budgetAmount)
        }
    }

    // MARK: - Top 3 categorías con más gasto

    func topCategories(_ expenses: [Expense]) -> [(category: String, amount: Double)] {
        categoryTotals(expenses)
            .map { (category: $0.key, amount: $0.value) }
            .sorted { $0.amount > $1.amount }
            .prefix(3)
            .map { $0 }
    }

    // MARK: - Valores para el CircleChartView

    func chartValues(categories: [CategoryBudget], expenses: [Expense]) -> [Double] {
        let bd = breakdown(categories: categories, expenses: expenses)
        let values = bd.map { $0.spent }.filter { $0 > 0 }
        return values.isEmpty ? [1] : values
    }

    // MARK: - Progreso (para las barras de progreso)

    func progressValue(spent: Double, budget: Double) -> Double {
        guard budget > 0 else { return 0 }
        return min(spent / budget, 1.0)
    }
}
