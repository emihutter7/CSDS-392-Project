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

    private let backgroundColor = Color(red: 0.97, green: 0.95, blue: 0.94)
    private let secondaryAccent = Color(red: 0.55, green: 0.43, blue: 0.35)
    private let fieldBorder = Color(red: 0.88, green: 0.80, blue: 0.81)

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
                backgroundColor
                    .ignoresSafeArea()

                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 22) {
                        Text("Expense History")
                            .font(.system(size: 30, weight: .semibold))
                            .foregroundStyle(secondaryAccent)
                            .frame(maxWidth: .infinity, alignment: .center)
                            .padding(.top, 8)

                        VStack(alignment: .leading, spacing: 16) {
                            Text("Expenses")
                                .font(.system(size: 22, weight: .semibold))
                                .foregroundStyle(secondaryAccent)

                            HStack(spacing: 12) {
                                HStack(spacing: 10) {
                                    Image(systemName: "magnifyingglass")
                                        .foregroundStyle(secondaryAccent.opacity(0.65))

                                    TextField(
                                        "",
                                        text: $searchText,
                                        prompt: Text("Search").foregroundColor(secondaryAccent.opacity(0.5))
                                    )
                                    .foregroundStyle(secondaryAccent)
                                }
                                .padding(.horizontal, 14)
                                .frame(height: 48)
                                .background(Color.white)
                                .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                                .overlay {
                                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                                        .stroke(fieldBorder, lineWidth: 1.5)
                                }

                                Menu {
                                    Picker("Filter", selection: $selectedCategory) {
                                        ForEach(categories, id: \.self) { category in
                                            Text(category).tag(category)
                                        }
                                    }
                                } label: {
                                    HStack(spacing: 8) {
                                        Text(selectedCategory == "All" ? "Filter" : selectedCategory)
                                            .font(.system(size: 15, weight: .semibold))

                                        Image(systemName: "line.3.horizontal.decrease")
                                            .font(.system(size: 14, weight: .medium))
                                    }
                                    .foregroundStyle(.white)
                                    .padding(.horizontal, 14)
                                    .frame(height: 48)
                                    .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                                }
                            }

                            if filteredExpenses.isEmpty {
                                VStack(spacing: 10) {
                                    Image(systemName: "tray")
                                        .font(.system(size: 28))
                                        .foregroundStyle(Color.accentColor)

                                    Text("No expenses found")
                                        .font(.system(size: 17, weight: .medium))
                                        .foregroundStyle(secondaryAccent.opacity(0.7))
                                }
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 28)
                            } else {
                                VStack(alignment: .leading, spacing: 14) {
                                    ForEach(filteredExpenses) { expense in
                                        NavigationLink {
                                            EditExpenseView(expense: expense)
                                        } label: {
                                            ExpenseRowView(expense: expense)
                                        }
                                        .buttonStyle(.plain)
                                    }
                                }
                            }
                        }
                        .padding(18)
                        .background(Color.white)
                        .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
                        .shadow(color: .black.opacity(0.05), radius: 12, y: 6)

                        Spacer(minLength: 100)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 12)
                    .padding(.bottom, 24)
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
