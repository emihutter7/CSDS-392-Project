//
//  HomeView.swift
//  CSDS-392-Project
//
//  Created by Alexandra Twitty on 4/14/26.
//

import SwiftUI
import SwiftData

struct HomeView: View {
    @Query(sort: \Expense.date, order: .reverse) private var expenses: [Expense]
    @Query private var budgets: [Budget]
    @Query(sort: \CategoryBudget.name) private var categoryBudgets: [CategoryBudget]

    private var totalBudget: Double {
        categoryBudgets.reduce(0) { $0 + $1.budgetAmount }
    }

    private var totalSpent: Double {
        expenses.reduce(0) { $0 + $1.amount }
    }

    private var recentExpenses: [Expense] {
        Array(expenses.prefix(5))
    }

    var body: some View {
        ZStack {
            Color(red: 0.80, green: 0.68, blue: 0.40)
                .ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 28) {
                    Text("Home")
                        .font(.system(size: 34, weight: .medium))
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding(.top, 12)

                    Text("Monthly Summary Card")
                        .font(.system(size: 28, weight: .medium))
                        .foregroundStyle(.white)

                    SummaryCard(total: totalBudget, spent: totalSpent)

                    NavigationLink {
                        AddExpenseView()
                    } label: {
                        Text("Add Expense")
                            .font(.system(size: 20, weight: .medium))
                            .foregroundStyle(.black)
                            .frame(width: 230, height: 64)
                            .background(Color.white.opacity(0.88))
                            .clipShape(Capsule())
                            .shadow(color: .black.opacity(0.15), radius: 10, y: 6)
                    }
                    .buttonStyle(.plain)
                    .padding(.top, 8)

                    Text("Recent Expenses")
                        .font(.system(size: 24, weight: .medium))
                        .foregroundStyle(.white)
                        .padding(.top, 8)

                    if recentExpenses.isEmpty {
                        Text("No expenses yet")
                            .font(.system(size: 20))
                            .foregroundStyle(.white.opacity(0.9))
                    } else {
                        VStack(alignment: .leading, spacing: 14) {
                            ForEach(recentExpenses) { expense in
                                HStack(alignment: .top) {
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text("\(expense.title):")
                                            .font(.system(size: 20, weight: .medium))
                                            .foregroundStyle(.white)

                                        if !expense.note.isEmpty {
                                            Text(expense.note)
                                                .font(.system(size: 14))
                                                .foregroundStyle(.white.opacity(0.85))
                                        }
                                    }

                                    Spacer()

                                    Text(expense.amount.formatted(.currency(code: "USD")))
                                        .font(.system(size: 20, weight: .medium))
                                        .foregroundStyle(.white)
                                }
                            }
                        }
                    }

                    Spacer(minLength: 110)
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 30)
                .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
    }
}

#Preview {
    HomeView()
}
