//
//  ReportsView.swift
//  CSDS-392-Project
//
//  Created by Alexandra Twitty on 4/14/26.
//

import SwiftUI
import SwiftData
import Charts

struct ReportsView: View {
    @Query(sort: \Expense.date, order:.reverse) private var expenses: [Expense]
    @Query(sort: \CategoryBudget.name) private var categoryBudgets: [CategoryBudget]
    @Query private var budgets: [Budget]

    private let backgroundColor = Color(red: 0.97, green: 0.95, blue: 0.94)
    private let secondaryAccent = Color(red: 0.55, green: 0.43, blue: 0.35)
    private let softBackground = Color(red: 0.99, green: 0.98, blue: 0.97)

    private let chartColors: [Color] = [
        Color(red: 0.75, green: 0.55, blue: 0.60),
        Color(red: 0.55, green: 0.43, blue: 0.35),
        Color(red: 0.88, green: 0.80, blue: 0.81),
        Color(red: 0.83, green: 0.70, blue: 0.73),
        Color(red: 0.91, green: 0.86, blue: 0.84),
        Color(red: 0.65, green: 0.48, blue: 0.50),
        Color(red: 0.70, green: 0.60, blue: 0.55),
        Color(red: 0.80, green: 0.72, blue: 0.68)
    ]

    private var budgetPeriod: String {
        budgets.first?.incomePeriod ?? "Monthly"
    }

    private var periodExpenses: [Expense] {
        DateFilterHelper.filter(
            expenses.filter { $0.type == .expense },
            for: budgetPeriod
        )
    }

    private var categoryTotals: [String: Double] {
        Dictionary(
            grouping: periodExpenses,
            by: { $0.category }
        ).mapValues { $0.reduce(0) { $0 + $1.amount } }
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

    private var chartData: [(name: String, amount: Double, color: Color)] {
        categoryTotals.filter { $0.value > 0 }.sorted { $0.value > $1.value }.enumerated().map { index, item in
                (
                    name: item.key,
                    amount: item.value,
                    color: chartColors[index % chartColors.count]
                )
            }
    }

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment:.leading, spacing: 22) {

                Text("Reports").font(.system(size: 30, weight:.semibold)).foregroundStyle(secondaryAccent).frame(maxWidth:.infinity, alignment:.center).padding(.top, 10)

                // MARK: — Budget Breakdown
                VStack(alignment:.leading, spacing: 18) {
                    Text("\(budgetPeriod) Budget Breakdown").font(.system(size: 24, weight:.semibold)).foregroundStyle(secondaryAccent).frame(maxWidth:.infinity)

                    if breakdownCategories.isEmpty {
                        Text("No categories set yet").font(.system(size: 17, weight:.medium)).foregroundStyle(secondaryAccent.opacity(0.7)).frame(maxWidth:.infinity)
                    } else {
                        VStack(spacing: 16) {
                            ForEach(breakdownCategories, id: \.name) { item in
                                VStack(alignment:.leading, spacing: 10) {
                                    HStack {
                                        Text(item.name).font(.system(size: 18, weight:.semibold)).foregroundStyle(secondaryAccent)
                                        Spacer()
                                        Text("\(item.spent, format:.currency(code: "USD")) / \(item.budget, format:.currency(code: "USD"))").font(.system(size: 15, weight:.medium)).foregroundStyle(Color.accentColor)
                                    }
                                    ProgressView(value: progressValue(spent: item.spent, budget: item.budget)).progressViewStyle(.linear).scaleEffect(y: 1.6)
                                }.padding(14).background(
                                    RoundedRectangle(cornerRadius: 18, style:.continuous).fill(softBackground)
                                )
                            }
                        }
                    }
                }.padding(18).background(Color.white).clipShape(RoundedRectangle(cornerRadius: 24, style:.continuous)).shadow(color:.black.opacity(0.05), radius: 12, y: 6)

                VStack(alignment:.leading, spacing: 18) {
                    Text("\(budgetPeriod) Report").font(.system(size: 24, weight:.semibold)).foregroundStyle(secondaryAccent)

                    if chartData.isEmpty {
                        Text("No expenses this \(budgetPeriod.lowercased()) yet").font(.system(size: 16, weight:.medium)).foregroundStyle(secondaryAccent.opacity(0.7)).frame(maxWidth:.infinity, alignment:.center).padding(.vertical, 20)
                    } else {

                        Chart(chartData, id: \.name) { item in
                            SectorMark(
                                angle:.value("Amount", item.amount),
                                innerRadius:.ratio(0.5),
                                angularInset: 2
                            ).foregroundStyle(item.color).cornerRadius(4)
                        }.frame(height: 260).padding(.vertical, 8)

                        VStack(alignment:.leading, spacing: 10) {
                            ForEach(chartData, id: \.name) { item in
                                HStack(spacing: 10) {
                                    
                                    RoundedRectangle(cornerRadius: 4).fill(item.color).frame(width: 14, height: 14)

                                    Text(item.name).font(.system(size: 15, weight:.semibold)).foregroundStyle(secondaryAccent)

                                    Spacer()

                                    Text(item.amount, format:.currency(code: "USD")).font(.system(size: 15, weight:.medium)).foregroundStyle(secondaryAccent.opacity(0.8))

                                    let total = chartData.reduce(0) { $0 + $1.amount }
                                    let percent = total > 0 ? (item.amount / total * 100) : 0
                                    Text("(\(Int(percent))%)").font(.system(size: 13, weight:.medium)).foregroundStyle(secondaryAccent.opacity(0.55))
                                }.padding(.horizontal, 4)

                                if item.name != chartData.last?.name {
                                    Divider().background(secondaryAccent.opacity(0.15))
                                }
                            }
                        }.padding(14).background(softBackground).clipShape(RoundedRectangle(cornerRadius: 16, style:.continuous))
                    }
                }.padding(18).background(Color.white).clipShape(RoundedRectangle(cornerRadius: 24, style:.continuous)).shadow(color:.black.opacity(0.05), radius: 12, y: 6)

                Spacer(minLength: 100)
            }.padding(.horizontal, 20).padding(.top, 8).padding(.bottom, 24)
        }.background(backgroundColor.ignoresSafeArea())
    }

    private func progressValue(spent: Double, budget: Double) -> Double {
        guard budget > 0 else { return 0 }
        return min(spent / budget, 1.0)
    }
}

#Preview {
    ReportsView().modelContainer(for: [Expense.self, CategoryBudget.self, Budget.self], inMemory: true)
}
