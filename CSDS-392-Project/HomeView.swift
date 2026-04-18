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

    private var monthlyBudget: Double {
        budgets.first?.monthlyLimit ?? 2000
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
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                Text("Home")
                    .font(.largeTitle)
                    .frame(maxWidth: .infinity, alignment: .center)
                
                SummaryCard(total: monthlyBudget, spent: totalSpent)
                
                Text("Recent Expenses")
                    .font(.title2)
                
                if recentExpenses.isEmpty {
                    Text("No expenses yet")
                        .foregroundStyle(.secondary)
                } else {
                    ForEach(recentExpenses) { expense in
                        HStack {
                            VStack(alignment: .leading) {
                                Text(expense.category)
                                    .font(.headline)
                                if !expense.note.isEmpty {
                                    Text(expense.note)
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                }
                            }
                            Spacer()
                            Text(expense.amount, format: .currency(code: "USD"))
                        }
                    }
                }
            }
            }
            .padding()
        }
    }
}

#Preview {
    HomeView()
}
