//
//  ExpenseHistoryView.swift
//  CSDS-392-Project
//
//  Created by Alexandra Twitty on 4/18/26.
//

import SwiftUI
import SwiftData

struct ExpenseHistoryView: View {
    @Query(sort: \Expense.date, order:.reverse) private var expenses: [Expense]
    @State private var viewModel = ExpenseHistoryViewModel()

    private let backgroundColor = Color(red: 0.97, green: 0.95, blue: 0.94)
    private let secondaryAccent = Color(red: 0.55, green: 0.43, blue: 0.35)
    private let cardBackground = Color.white
    private let fieldBorder = Color(red: 0.88, green: 0.80, blue: 0.81)

    var body: some View {
        NavigationStack {
            ZStack {
                backgroundColor.ignoresSafeArea()

                VStack(spacing: 18) {
                    VStack(spacing: 14) {
                        Picker("Transaction Type", selection: $viewModel.selectedFilter) {
                            ForEach(TransactionFilter.allCases) { filter in
                                Text(filter.rawValue).tag(filter)
                            }
                        }.pickerStyle(.segmented)

                        Picker("Category", selection: $viewModel.selectedCategory) {
                            ForEach(viewModel.availableCategories(from: expenses), id: \.self) { category in
                                Text(category).tag(category)
                            }
                        }.pickerStyle(.menu).padding(.horizontal, 14).frame(height: 50).frame(maxWidth:.infinity, alignment:.leading).background(Color.white).clipShape(RoundedRectangle(cornerRadius: 16, style:.continuous)).overlay {
                            RoundedRectangle(cornerRadius: 16, style:.continuous).stroke(fieldBorder, lineWidth: 1.5)
                        }
                    }.padding(.horizontal, 20).padding(.top, 12)

                    let filtered = viewModel.filteredExpenses(from: expenses)

                    if filtered.isEmpty {
                        VStack(spacing: 10) {
                            Image(systemName: "tray").font(.system(size: 34)).foregroundStyle(secondaryAccent.opacity(0.55))
                            Text("No transactions found").font(.headline).foregroundStyle(secondaryAccent)
                            Text("Try changing the filters or add a new transaction.").font(.subheadline).foregroundStyle(secondaryAccent.opacity(0.7)).multilineTextAlignment(.center)
                        }.frame(maxWidth:.infinity, maxHeight:.infinity).padding(.horizontal, 24)
                    } else {
                        ScrollView(showsIndicators: false) {
                            LazyVStack(spacing: 14) {
                                ForEach(filtered) { expense in
                                    NavigationLink {
                                        EditExpenseView(expense: expense)
                                    } label: {
                                        HStack(alignment:.center, spacing: 14) {
                                            ZStack {
                                                Circle().fill(viewModel.iconBackground(for: expense.type)).frame(width: 48, height: 48)
                                                Image(systemName: viewModel.iconName(for: expense.type)).font(.system(size: 20, weight:.semibold)).foregroundStyle(viewModel.iconForeground(for: expense.type))
                                            }

                                            VStack(alignment:.leading, spacing: 6) {
                                                Text(expense.title).font(.system(size: 17, weight:.semibold)).foregroundStyle(.primary).lineLimit(1)

                                                HStack(spacing: 8) {
                                                    Text(expense.category).font(.system(size: 13, weight:.medium)).foregroundStyle(secondaryAccent)
                                                    Text("•").foregroundStyle(secondaryAccent.opacity(0.5))
                                                    Text(expense.date, style:.date).font(.system(size: 13)).foregroundStyle(secondaryAccent.opacity(0.8))
                                                }
                                            }

                                            Spacer()

                                            VStack(alignment:.trailing, spacing: 6) {
                                                Text(viewModel.amountText(for: expense)).font(.system(size: 17, weight:.bold)).foregroundStyle(viewModel.amountColor(for: expense.type))
                                                Text(expense.type.rawValue).font(.system(size: 12, weight:.medium)).foregroundStyle(viewModel.amountColor(for: expense.type).opacity(0.85))
                                            }
                                        }.padding(16).background(cardBackground).clipShape(RoundedRectangle(cornerRadius: 20, style:.continuous)).shadow(color:.black.opacity(0.04), radius: 10, y: 4)
                                    }.buttonStyle(.plain)
                                }
                            }.padding(.horizontal, 20).padding(.bottom, 26)
                        }
                    }
                }
            }.navigationTitle("Transaction History").navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    ExpenseHistoryView().modelContainer(for: [Expense.self, CategoryBudget.self], inMemory: true)
}
