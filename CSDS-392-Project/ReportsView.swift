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
    @Environment(\.modelContext) private var modelContext
    
    @Query(sort: \Expense.date, order: .reverse) private var expenses: [Expense]
    @Query(sort: \CategoryBudget.name) private var categoryBudgets: [CategoryBudget]
    @Query private var budgets: [Budget]

    @State private var viewModel = ReportsViewModel()

    private let backgroundColor = Color("AppBackground")
    private let secondaryAccent = Color("SecondaryAccent")
    private let softBackground = Color("SoftBackground")

    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 22) {

                    let period = viewModel.periodLabel(from: budgets)
                    let breakdown = viewModel.breakdownItems(
                        expenses: expenses,
                        categoryBudgets: categoryBudgets,
                        budgets: budgets
                    )
                    let chart = viewModel.chartData(from: expenses, budgets: budgets)

                    HStack {
                        Spacer()
                        Text("Reports")
                            .font(.system(size: 30, weight: .semibold))
                            .foregroundStyle(secondaryAccent)
                        Spacer()
                        NavigationLink(destination: BudgetEditorView()) {
                            HStack(spacing: 4) {
                                Image(systemName: "slider.horizontal.3")
                                Text("Edit")
                            }
                            .font(.system(size: 15, weight: .semibold))
                            .foregroundStyle(Color.accentColor)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 7)
                            .background(Color.accentColor.opacity(0.12))
                            .clipShape(Capsule())
                        }
                    }
                    .padding(.top, 10)

                    VStack(alignment: .leading, spacing: 18) {
                        Text("\(period) Budget Breakdown")
                            .font(.system(size: 24, weight: .semibold))
                            .foregroundStyle(secondaryAccent)
                            .frame(maxWidth: .infinity)

                        if breakdown.isEmpty {
                            VStack(spacing: 12) {
                                Text("No budget set up yet")
                                    .font(.system(size: 17, weight: .medium))
                                    .foregroundStyle(secondaryAccent.opacity(0.7))
                                NavigationLink(destination: BudgetEditorView()) {
                                    Text("Set Up Budget")
                                        .font(.system(size: 16, weight: .semibold))
                                        .foregroundStyle(.white)
                                        .padding(.horizontal, 24)
                                        .padding(.vertical, 10)
                                        .background(Color.accentColor)
                                        .clipShape(Capsule())
                                }
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 10)
                        } else {
                            VStack(spacing: 16) {
                                ForEach(breakdown, id: \.name) { item in
                                    VStack(alignment: .leading, spacing: 10) {
                                        HStack {
                                            Text(item.name)
                                                .font(.system(size: 18, weight: .semibold))
                                                .foregroundStyle(secondaryAccent)
                                            Spacer()
                                            Text("\(item.spent, format: .currency(code: "USD")) / \(item.budget, format: .currency(code: "USD"))")
                                                .font(.system(size: 15, weight: .medium))
                                                .foregroundStyle(Color.accentColor)
                                        }
                                        ProgressView(value: viewModel.progressValue(spent: item.spent, budget: item.budget))
                                            .progressViewStyle(.linear)
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
                        Text("\(period) Report")
                            .font(.system(size: 24, weight: .semibold))
                            .foregroundStyle(secondaryAccent)

                        if chart.isEmpty {
                            Text("No expenses this \(period.lowercased()) yet")
                                .font(.system(size: 16, weight: .medium))
                                .foregroundStyle(secondaryAccent.opacity(0.7))
                                .frame(maxWidth: .infinity, alignment: .center)
                                .padding(.vertical, 20)
                        } else {
                            Chart(chart, id: \.name) { item in
                                SectorMark(
                                    angle: .value("Amount", item.amount),
                                    innerRadius: .ratio(0.5),
                                    angularInset: 2
                                )
                                .foregroundStyle(item.color)
                                .cornerRadius(4)
                            }
                            .frame(height: 260)
                            .padding(.vertical, 8)

                            VStack(alignment: .leading, spacing: 10) {
                                ForEach(chart, id: \.name) { item in
                                    HStack(spacing: 10) {
                                        RoundedRectangle(cornerRadius: 4)
                                            .fill(item.color)
                                            .frame(width: 14, height: 14)

                                        Text(item.name)
                                            .font(.system(size: 15, weight: .semibold))
                                            .foregroundStyle(secondaryAccent)

                                        Spacer()

                                        Text(item.amount, format: .currency(code: "USD"))
                                            .font(.system(size: 15, weight: .medium))
                                            .foregroundStyle(secondaryAccent.opacity(0.8))

                                        Text("(\(viewModel.percentage(for: item, in: chart))%)")
                                            .font(.system(size: 13, weight: .medium))
                                            .foregroundStyle(secondaryAccent.opacity(0.55))
                                    }
                                    .padding(.horizontal, 4)

                                    if item.name != chart.last?.name {
                                        Divider()
                                            .background(secondaryAccent.opacity(0.15))
                                    }
                                }
                            }
                            .padding(14)
                            .background(softBackground)
                            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
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
            .refreshable {
                let viewModel = BankImportViewModel()
                await viewModel.importTransactions(modelContext: modelContext)
            }
            .background(backgroundColor).ignoresSafeArea(.container, edges: .bottom)
        }
    }
}

#Preview {
    ReportsView()
        .modelContainer(for: [Expense.self, CategoryBudget.self, Budget.self], inMemory: true)
}
