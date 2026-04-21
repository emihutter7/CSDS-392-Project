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

    private let periods = ["Monthly", "Yearly", "Weekly", "Daily"]

    private let backgroundColor = Color(red: 0.97, green: 0.95, blue: 0.94)
    private let accentColor = Color(red: 0.75, green: 0.55, blue: 0.60)
    private let secondaryAccent = Color(red: 0.55, green: 0.43, blue: 0.35)
    private let fieldBorder = Color(red: 0.88, green: 0.80, blue: 0.81)

    var body: some View {
        ZStack {
            backgroundColor.ignoresSafeArea()

            ScrollView {
                VStack(alignment: .leading, spacing: 22) {

                    Text("Budget Editor")
                        .font(.system(size: 30, weight: .semibold))
                        .foregroundStyle(secondaryAccent)
                        .frame(maxWidth: .infinity, alignment: .center)

                    VStack(spacing: 18) {

                        TextField("Income", text: $income)
                            .keyboardType(.decimalPad)
                            .padding()
                            .background(Color.white)
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                            .overlay {
                                RoundedRectangle(cornerRadius: 16)
                                    .stroke(fieldBorder, lineWidth: 1.5)
                            }

                        Picker("Period", selection: $incomePeriod) {
                            ForEach(periods, id: \.self) { Text($0) }
                        }
                        .pickerStyle(.menu)
                        .padding()
                        .background(Color.white)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                        .overlay {
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(fieldBorder, lineWidth: 1.5)
                        }

                        ForEach(categories) { category in
                            CategoryBudgetRow(category: category)
                        }

                        HStack {
                            TextField("New Category", text: $newCategoryTitle)
                                .padding()
                                .background(Color.white)
                                .clipShape(RoundedRectangle(cornerRadius: 16))

                            Button {
                                addCategory()
                            } label: {
                                Image(systemName: "plus.circle.fill")
                                    .foregroundStyle(accentColor)
                                    .font(.system(size: 26))
                            }
                        }

                    }
                    .padding(20)
                    .background(Color.white)
                    .clipShape(RoundedRectangle(cornerRadius: 24))
                    .shadow(color: .black.opacity(0.05), radius: 12, y: 6)

                    Button("Save Changes") {
                        saveBudget()
                    }
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 56)
                    .background(accentColor)
                    .clipShape(RoundedRectangle(cornerRadius: 18))

                    Spacer(minLength: 100)
                }
                .padding(.horizontal, 20)
            }
        }
    }

    private func saveBudget() {
        guard let budget = budgets.first else { return }
        budget.income = Double(income) ?? 0
        budget.incomePeriod = incomePeriod
        try? modelContext.save()
    }

    private func addCategory() {
        guard !newCategoryTitle.isEmpty else { return }
        modelContext.insert(CategoryBudget(name: newCategoryTitle))
        newCategoryTitle = ""
        try? modelContext.save()
    }
}

#Preview {
    BudgetEditorView()
}
