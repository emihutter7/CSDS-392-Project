//
//  ReportsView.swift
//  CSDS-392-Project
//
//  Created by Alexandra Twitty on 4/14/26.
//

import SwiftUI
import SwiftData

struct ReportsView: View {
    @Query(sort: \Expense.date, order: .reverse) private var expenses: [Expense]
    @Query(sort: \CategoryBudget.name) private var categoryBudgets: [CategoryBudget]

    private var categoryTotals: [String: Double] {
        Dictionary(grouping: expenses, by: { $0.category })
            .mapValues { items in
                items.reduce(0) { $0 + $1.amount }
            }
    }

    private var breakdownCategories: [(name: String, spent: Double, budget: Double)] {
        categoryBudgets.map { category in
            (
                name: category.name,
                spent: categoryTotals[category.name] ?? 0,
                budget: category.budgetAmount
            )
        }
    }

    private var topCategories: [(category: String, amount: Double)] {
        categoryTotals
            .map { (category: $0.key, amount: $0.value) }
            .sorted { $0.amount > $1.amount }
    }

    private var chartValues: [Double] {
        let values = breakdownCategories.map { $0.spent }.filter { $0 > 0 }
        return values.isEmpty ? [1] : values
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 28) {
                Text("Reports")
                    .font(.system(size: 30, weight: .medium))
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.top, 10)

                VStack(alignment: .leading, spacing: 18) {
                    Text("Budget Breakdown")
                        .font(.system(size: 24, weight: .semibold))
                        .foregroundStyle(.white)

                    if breakdownCategories.isEmpty {
                        Text("No categories set yet")
                            .foregroundStyle(.white.opacity(0.9))
                    } else {
                        ForEach(breakdownCategories, id: \.name) { item in
                            VStack(alignment: .leading, spacing: 8) {
                                Text("\(item.name): \(item.spent, format: .currency(code: "USD"))/\(item.budget, format: .currency(code: "USD"))")
                                    .font(.system(size: 18, weight: .medium))
                                    .foregroundStyle(.white)

                                ProgressView(value: progressValue(spent: item.spent, budget: item.budget))
                                    .progressViewStyle(.linear)
                                    .tint(.blue)
                                    .frame(width: 300)
                            }
                        }
                    }
                }

                HStack(alignment: .top, spacing: 40) {
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Monthly Report")
                            .font(.system(size: 24, weight: .semibold))
                            .foregroundStyle(.white)

                        CircleChartView(
                            values: chartValues,
                            lineWidth: 18
                        )
                        .frame(width: 160, height: 160)
                    }

                    VStack(alignment: .leading, spacing: 16) {
                        Text("Top Categories")
                            .font(.system(size: 24, weight: .semibold))
                            .foregroundStyle(.white)

                        if topCategories.isEmpty {
                            Text("No expenses yet")
                                .foregroundStyle(.white.opacity(0.9))
                        } else {
                            ForEach(topCategories.prefix(3), id: \.category) { item in
                                Text("\(item.category): \(item.amount, format: .currency(code: "USD"))")
                                    .font(.system(size: 18, weight: .medium))
                                    .foregroundStyle(.white)
                            }
                        }
                    }
                }

                Spacer(minLength: 100)
            }
            .padding(.horizontal, 28)
            .padding(.top, 8)
        }
        .background(
            Color(red: 0.80, green: 0.68, blue: 0.40)
                .ignoresSafeArea()
        )
    }

    private func progressValue(spent: Double, budget: Double) -> Double {
        guard budget > 0 else { return 0 }
        return min(spent / budget, 1.0)
    }
}

#Preview {
    ReportsView()
}
