//
//  HomeView.swift
//  CSDS-392-Project
//
//  Created by Alexandra Twitty on 4/14/26.
//

import SwiftUI
import SwiftData

struct HomeView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var showBankLink = false
    @State private var viewModel = HomeViewModel()

    @Query(sort: \Expense.date, order: .reverse) private var expenses: [Expense]
    @Query private var budgets: [Budget]
    @Query(sort: \CategoryBudget.name) private var categoryBudgets: [CategoryBudget]

    private let backgroundColor = Color(red: 0.97, green: 0.95, blue: 0.94)
    private let secondaryAccent = Color(red: 0.55, green: 0.43, blue: 0.35)
    private let cardColor = Color.white

    var body: some View {
        ZStack {
            backgroundColor.ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 22) {
                    Text("Home")
                        .font(.system(size: 32, weight: .semibold))
                        .foregroundStyle(secondaryAccent)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding(.top, 10)

                    Text("\(viewModel.budgetPeriod(from: budgets)) Summary")
                        .font(.system(size: 24, weight: .semibold))
                        .foregroundStyle(secondaryAccent)

                    SummaryCard(
                        total: viewModel.totalBudget(from: categoryBudgets),
                        spent: viewModel.totalSpent(from: expenses, budgets: budgets)
                    )

                    NavigationLink {
                        AddExpenseView(selectedTab:.constant(2))
                    } label: {
                        HStack {
                            Spacer()
                            Text("Add Transaction")
                                .font(.system(size: 19, weight: .semibold))
                                .foregroundStyle(secondaryAccent)
                            Spacer()
                        }
                        .frame(height: 58)
                        .background(cardColor)
                        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
                    }
                    .buttonStyle(.plain)
                    .padding(.top, 2)

                    Button {
                        showBankLink = true
                    } label: {
                        HStack {
                            Spacer()
                            Text("Import Bank Transactions")
                                .font(.system(size: 19, weight: .semibold))
                                .foregroundStyle(secondaryAccent)
                            Spacer()
                        }
                        .frame(height: 58)
                        .background(cardColor)
                        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
                    }
                    .padding(.top, 2)
                    .sheet(isPresented: $showBankLink) {
                        BankLinkView()
                    }

                    VStack(alignment: .leading, spacing: 16) {
                        Text("Recent Transactions")
                            .font(.system(size: 24, weight: .semibold))
                            .foregroundStyle(secondaryAccent)
                            .frame(maxWidth: .infinity)

                        let recent = viewModel.recentExpenses(from: expenses)

                        if recent.isEmpty {
                            Text("No expenses yet")
                                .font(.system(size: 18, weight: .medium))
                                .foregroundStyle(secondaryAccent.opacity(0.65))
                                .padding(.vertical, 8)
                        } else {
                            VStack(spacing: 12) {
                                ForEach(recent) { expense in
                                    HStack(alignment: .top, spacing: 12) {
                                        Circle()
                                            .frame(width: 42, height: 42)
                                            .foregroundStyle(Color.accentColor)
                                            .overlay {
                                                Image(systemName: viewModel.iconName(for: expense.type))
                                                    .font(.system(size: 16))
                                            }

                                        Text(expense.title)
                                            .font(.system(size: 18, weight: .semibold))
                                            .foregroundStyle(secondaryAccent)

                                        Spacer()

                                        Text(viewModel.amountText(for: expense))
                                            .foregroundStyle(viewModel.amountColor(for: expense.type))
                                            .font(.system(size: 17, weight: .semibold))
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
            .refreshable {
                let viewModel = BankImportViewModel()
                await viewModel.importTransactions(modelContext: modelContext)
            }
        }
    }
}

#Preview {
    HomeView()
}
