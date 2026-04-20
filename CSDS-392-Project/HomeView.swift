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

    private let backgroundColor = Color(red: 0.97, green: 0.95, blue: 0.94)
    private let accentColor = Color(red: 0.75, green: 0.55, blue: 0.60)
    private let secondaryAccent = Color(red: 0.55, green: 0.43, blue: 0.35)
    private let cardColor = Color.white

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
            backgroundColor
                .ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 22) {
                    Text("Home")
                        .font(.system(size: 32, weight: .semibold))
                        .foregroundStyle(secondaryAccent)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding(.top, 10)

                    Text("Monthly Summary")
                        .font(.system(size: 24, weight: .semibold))
                        .foregroundStyle(secondaryAccent)

                    SummaryCard(total: totalBudget, spent: totalSpent)

                    NavigationLink {
                        AddExpenseView()
                    } label: {
                        HStack {
                            Spacer()

                            Text("Add Expense")
                                .font(.system(size: 19, weight: .semibold))
                                .foregroundStyle(.white)

                            Spacer()
                        }
                        .frame(height: 58)
                        .background(accentColor)
                        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
                        .shadow(color: accentColor.opacity(0.22), radius: 10, y: 6)
                    }
                    .buttonStyle(.plain)
                    .padding(.top, 2)

                    VStack(alignment: .leading, spacing: 16) {
                        Text("Recent Expenses")
                            .font(.system(size: 24, weight: .semibold))
                            .foregroundStyle(secondaryAccent)

                        if recentExpenses.isEmpty {
                            Text("No expenses yet")
                                .font(.system(size: 18, weight: .medium))
                                .foregroundStyle(secondaryAccent.opacity(0.65))
                                .padding(.vertical, 8)
                        } else {
                            VStack(spacing: 12) {
                                ForEach(recentExpenses) { expense in
                                    HStack(alignment: .top, spacing: 12) {
                                        Circle()
                                            .fill(accentColor.opacity(0.14))
                                            .frame(width: 42, height: 42)
                                            .overlay {
                                                Image(systemName: "creditcard.fill")
                                                    .font(.system(size: 16))
                                                    .foregroundStyle(accentColor)
                                            }

                                        VStack(alignment: .leading, spacing: 4) {
                                            Text(expense.title)
                                                .font(.system(size: 18, weight: .semibold))
                                                .foregroundStyle(secondaryAccent)

                                            if !expense.note.isEmpty {
                                                Text(expense.note)
                                                    .font(.system(size: 14))
                                                    .foregroundStyle(secondaryAccent.opacity(0.7))
                                                    .lineLimit(1)
                                            }
                                        }

                                        Spacer()

                                        Text(expense.amount.formatted(.currency(code: "USD")))
                                            .font(.system(size: 17, weight: .semibold))
                                            .foregroundStyle(secondaryAccent)
                                    }
                                    .padding(14)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .background(
                                        RoundedRectangle(cornerRadius: 16, style: .continuous)
                                            .fill(backgroundColor)
                                    )
                                }
                            }
                        }
                    }
                    .padding(18)
                    .background(cardColor)
                    .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
                    .shadow(color: .black.opacity(0.05), radius: 12, y: 6)

                    Spacer(minLength: 110)
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 30)
                .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
    }
}

#Preview {
    HomeView()
}
