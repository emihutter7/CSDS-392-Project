//
//  BudgetEditorView.swift
//  CSDS-392-Project
//
//  Created by Alexandra Twitty on 4/18/26.
//

import SwiftUI
import SwiftData

struct BudgetEditorView: View {
    @Environment(\.modelContext) private var modelContext

    @Query private var budgets: [Budget]
    @Query(sort: \CategoryBudget.name) private var categories: [CategoryBudget]

    @State private var income = ""
    @State private var incomePeriod = "Monthly"
    @State private var newCategoryTitle = ""
    @State private var showSavedMessage = false

    private let periods = ["Monthly", "Yearly", "Weekly", "Daily"]

    var body: some View {
        ZStack {
            Color(red: 0.80, green: 0.68, blue: 0.40)
                .ignoresSafeArea()

            ScrollView {
                VStack(alignment: .leading, spacing: 22) {

                    // Title
                    Text("Budget Editor")
                        .font(.system(size: 32, weight: .medium))
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding(.top, 10)

                    // Income Section
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Income")
                            .font(.system(size: 24, weight: .medium))
                            .foregroundStyle(.white)

                        HStack(spacing: 12) {
                            TextField("Value", text: $income)
                                .keyboardType(.decimalPad)
                                .padding(.horizontal, 12)
                                .frame(width: 150, height: 42)
                                .background(.white)
                                .clipShape(RoundedRectangle(cornerRadius: 10))

                            Picker("Period", selection: $incomePeriod) {
                                ForEach(periods, id: \.self) { p in
                                    Text(p).tag(p)
                                }
                            }
                            .pickerStyle(.menu)
                            .padding(.horizontal, 12)
                            .frame(width: 120, height: 42)
                            .background(.white)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                        }
                    }

                    // Categories Section (Dynamic)
                    VStack(alignment: .leading, spacing: 14) {
                        ForEach(categories) { category in
                            CategoryBudgetRow(category: category)
                        }

                        // Add new category
                        HStack(spacing: 12) {
                            Button {
                                addCategory()
                            } label: {
                                Image(systemName: "plus.circle")
                                    .font(.system(size: 28))
                                    .foregroundStyle(.white)
                            }

                            TextField("Add Category Title", text: $newCategoryTitle)
                                .padding(.horizontal, 12)
                                .frame(height: 42)
                                .background(.white)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                        }
                    }

                    // Save Button
                    Button {
                        saveBudget()
                    } label: {
                        Text("Save")
                            .font(.system(size: 20, weight: .medium))
                            .foregroundStyle(.purple)
                            .padding(.horizontal, 34)
                            .padding(.vertical, 10)
                            .background(.white.opacity(0.95))
                            .clipShape(Capsule())
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.top, 14)

                    if showSavedMessage {
                        Text("Budget saved")
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity, alignment: .center)
                    }

                    Spacer(minLength: 100)
                }
                .padding(.horizontal, 30)
                .padding(.top, 8)
            }
        }
        .navigationBarBackButtonHidden(false)
        .onAppear {
            ensureBudgetExists()
            seedCategoriesIfNeeded()
            loadBudgetIntoFields()
        }
    }

    // MARK: - Setup

    private func ensureBudgetExists() {
        if budgets.isEmpty {
            let newBudget = Budget()
            modelContext.insert(newBudget)
            try? modelContext.save()
        }
    }

    private func seedCategoriesIfNeeded() {
        if categories.isEmpty {
            let defaults = [
                "Food",
                "Rent",
                "Transportation",
                "Fun",
                "Education",
                "Shopping",
                "Health",
                "Subscriptions"
            ]

            for name in defaults {
                modelContext.insert(CategoryBudget(name: name))
            }

            try? modelContext.save()
        }
    }

    private func loadBudgetIntoFields() {
        guard let budget = budgets.first else { return }

        income = budget.income == 0 ? "" : formatNumber(budget.income)
        incomePeriod = budget.incomePeriod
    }

    // MARK: - Actions

    private func saveBudget() {
        guard let budget = budgets.first else { return }

        budget.income = Double(income) ?? 0
        budget.incomePeriod = incomePeriod

        do {
            try modelContext.save()
            showSavedMessage = true

            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                showSavedMessage = false
            }
        } catch {
            print("Save failed: \(error)")
        }
    }

    private func addCategory() {
        let trimmed = newCategoryTitle.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }

        let new = CategoryBudget(name: trimmed)
        modelContext.insert(new)
        newCategoryTitle = ""

        try? modelContext.save()
    }

    private func formatNumber(_ value: Double) -> String {
        if value == floor(value) {
            return String(Int(value))
        }
        return String(value)
    }
}

#Preview {
    BudgetEditorView()
}
