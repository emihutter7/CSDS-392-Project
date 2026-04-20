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

    private let backgroundColor = Color(red: 0.97, green: 0.95, blue: 0.94)
    private let accentColor = Color(red: 0.75, green: 0.55, blue: 0.60)
    private let secondaryAccent = Color(red: 0.55, green: 0.43, blue: 0.35)
    private let softBackground = Color(red: 0.99, green: 0.98, blue: 0.97)

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
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 22) {
                Text("Reports")
                    .font(.system(size: 30, weight: .semibold))
                    .foregroundStyle(secondaryAccent)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.top, 10)

                VStack(alignment: .leading, spacing: 18) {
                    Text("Budget Breakdown")
                        .font(.system(size: 24, weight: .semibold))
                        .foregroundStyle(secondaryAccent)

                    if breakdownCategories.isEmpty {
                        Text("No categories set yet")
                            .font(.system(size: 17, weight: .medium))
                            .foregroundStyle(secondaryAccent.opacity(0.7))
                    } else {
                        VStack(spacing: 16) {
                            ForEach(breakdownCategories, id: \.name) { item in
                                VStack(alignment: .leading, spacing: 10) {
                                    HStack {
                                        Text(item.name)
                                            .font(.system(size: 18, weight: .semibold))
                                            .foregroundStyle(secondaryAccent)

                                        Spacer()

                                        Text("\(item.spent, format: .currency(code: "USD")) / \(item.budget, format: .currency(code: "USD"))")
                                            .font(.system(size: 15, weight: .medium))
                                            .foregroundStyle(accentColor)
                                    }

                                    ProgressView(value: progressValue(spent: item.spent, budget: item.budget))
                                        .progressViewStyle(.linear)
                                        .tint(accentColor)
                                        .scaleEffect(y: 1.6)
                                }
                                .padding(14)
                                .background(
                                    RoundedRectangle(cornerRadius: 18, style: .continuous)
                                        .fill(softBackground)
                                )
                            }
                        }
                    }
                }
                .padding(18)
                .background(Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
                .shadow(color: .black.opacity(0.05), radius: 12, y: 6)

                VStack(alignment: .leading, spacing: 18) {
                    Text("Monthly Report")
                        .font(.system(size: 24, weight: .semibold))
                        .foregroundStyle(secondaryAccent)

                    HStack(alignment: .top, spacing: 24) {
                        CircleChartView(
                            values: chartValues,
                            lineWidth: 18
                        )
                        .frame(width: 160, height: 160)

                        VStack(alignment: .leading, spacing: 14) {
                            Text("Top Categories")
                                .font(.system(size: 20, weight: .semibold))
                                .foregroundStyle(secondaryAccent)

                            if topCategories.isEmpty {
                                Text("No expenses yet")
                                    .font(.system(size: 16, weight: .medium))
                                    .foregroundStyle(secondaryAccent.opacity(0.7))
                            } else {
                                ForEach(topCategories.prefix(3), id: \.category) { item in
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text(item.category)
                                            .font(.system(size: 17, weight: .semibold))
                                            .foregroundStyle(secondaryAccent)

                                        Text(item.amount, format: .currency(code: "USD"))
                                            .font(.system(size: 15, weight: .medium))
                                            .foregroundStyle(accentColor)
                                    }
                                }
                            }
                        }

                        Spacer()
                    }
                }
                .padding(18)
                .background(Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
                .shadow(color: .black.opacity(0.05), radius: 12, y: 6)

                Spacer(minLength: 100)
            }
            .padding(.horizontal, 20)
            .padding(.top, 8)
            .padding(.bottom, 24)
        }
        .background(
            backgroundColor
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
