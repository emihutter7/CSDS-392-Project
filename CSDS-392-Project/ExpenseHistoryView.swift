//
//  ExpenseHistoryView.swift
//  CSDS-392-Project
//
//  Created by Alexandra Twitty on 4/14/26.
//
import SwiftUI
import SwiftData

struct ExpenseHistoryView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Expense.date, order: .reverse) private var expenses: [Expense]

    @State private var searchText = ""
    @State private var selectedCategory = "All"

    private let categories = ["All", "Food", "Rent", "Fun", "Transport", "Education"]

    private var filteredExpenses: [Expense] {
        expenses.filter { expense in
            let matchesSearch =
                searchText.isEmpty ||
                expense.title.localizedCaseInsensitiveContains(searchText) ||
                expense.category.localizedCaseInsensitiveContains(searchText) ||
                expense.note.localizedCaseInsensitiveContains(searchText)

            let matchesCategory =
                selectedCategory == "All" || expense.category == selectedCategory

            return matchesSearch && matchesCategory
        }
    }

    var body: some View {
        NavigationStack {
            ZStack {
                Color(red: 0.80, green: 0.68, blue: 0.40)
                    .ignoresSafeArea()

                ScrollView {
                    VStack(alignment: .leading, spacing: 22) {
                        Text("Expense History")
                            .font(.system(size: 28, weight: .medium))
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity, alignment: .center)
                            .padding(.top, 8)

                        Text("Expenses")
                            .font(.system(size: 22, weight: .semibold))
                            .foregroundStyle(.white)

                        HStack(spacing: 12) {
                            HStack {
                                Image(systemName: "magnifyingglass")
                                    .foregroundStyle(.black.opacity(0.65))

                                TextField("Search", text: $searchText)
                                    .foregroundStyle(.black)

                                Image(systemName: "mic.fill")
                                    .foregroundStyle(.black.opacity(0.65))
                            }
                            .padding(.horizontal, 12)
                            .frame(height: 40)
                            .background(Color(red: 0.72, green: 0.60, blue: 0.32))
                            .clipShape(RoundedRectangle(cornerRadius: 12))

                            Menu {
                                Picker("Filter", selection: $selectedCategory) {
                                    ForEach(categories, id: \.self) { category in
                                        Text(category).tag(category)
                                    }
                                }
                            } label: {
                                HStack(spacing: 6) {
                                    Text("Filter")
                                        .foregroundStyle(.white)
                                        .font(.system(size: 16, weight: .medium))

                                    Image(systemName: "line.3.horizontal.decrease")
                                        .foregroundStyle(.white)
                                }
                            }
                        }

                        if filteredExpenses.isEmpty {
                            Text("No expenses found")
                                .foregroundStyle(.white.opacity(0.9))
                                .padding(.top, 20)
                        } else {
                            VStack(alignment: .leading, spacing: 18) {
                                ForEach(filteredExpenses) { expense in
                                    NavigationLink {
                                        EditExpenseView(expense: expense)
                                    } label: {
                                        ExpenseRowView(expense: expense)
                                    }
                                    .buttonStyle(.plain)
                                }
                                .onDelete(perform: deleteExpenses)
                            }
                        }

                        Spacer(minLength: 100)
                    }
                    .padding(.horizontal, 24)
                    .padding(.top, 12)
                }
            }
            .navigationBarHidden(true)
        }
    }

    private func deleteExpenses(at offsets: IndexSet) {
        for index in offsets {
            modelContext.delete(filteredExpenses[index])
        }
    }
}

#Preview {
    ExpenseHistoryView()
}
