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

    private let backgroundColor = Color(red: 0.97, green: 0.95, blue: 0.94)
    private let accentColor = Color(red: 0.75, green: 0.55, blue: 0.60)
    private let secondaryAccent = Color(red: 0.55, green: 0.43, blue: 0.35)
    private let fieldBorder = Color(red: 0.88, green: 0.80, blue: 0.81)

    var body: some View {
        ZStack {
            backgroundColor.ignoresSafeArea()

            ScrollView {
                VStack(alignment:.leading, spacing: 22) {

                    Text("Budget Editor").font(.system(size: 30, weight:.semibold)).foregroundStyle(secondaryAccent).frame(maxWidth:.infinity, alignment:.center)

                    VStack(spacing: 18) {

                        Picker("Period", selection: $incomePeriod) {
                            ForEach(periods, id: \.self) { Text($0) }
                        }.pickerStyle(.menu).padding().background(Color.white).frame(maxWidth:.infinity).clipShape(RoundedRectangle(cornerRadius: 16)).overlay {
                            RoundedRectangle(cornerRadius: 16).stroke(fieldBorder, lineWidth: 1.5)
                        }

                        ForEach(categories) { category in
                            CategoryBudgetRow(category: category)
                        }

                        HStack {
                            TextField("New Category", text: $newCategoryTitle).padding().background(Color.white).clipShape(RoundedRectangle(cornerRadius: 16))

                            Button {
                                addCategory()
                            } label: {
                                Image(systemName: "plus.circle.fill").foregroundStyle(accentColor).font(.system(size: 26))
                            }
                        }
                    }.padding(20).background(Color.white).clipShape(RoundedRectangle(cornerRadius: 24)).shadow(color:.black.opacity(0.05), radius: 12, y: 6)

                    Button("Save Changes") {
                        saveBudget()
                    }.font(.system(size: 18, weight:.semibold)).foregroundStyle(.white).frame(maxWidth:.infinity).frame(height: 56).background(accentColor).clipShape(RoundedRectangle(cornerRadius: 18))

                    if showSavedMessage {
                        Text("Budget saved!").font(.system(size: 16, weight:.medium)).foregroundStyle(secondaryAccent).frame(maxWidth:.infinity, alignment:.center)
                    }

                    Spacer(minLength: 100)
                }.padding(.horizontal, 20)
            }
        }.onAppear {
            loadBudget()
        }.onChange(of: budgets) {
            loadBudget()
        }
    }

    private func loadBudget() {
        if let budget = budgets.first {
            income = budget.income == 0 ? "" : String(budget.income)
            incomePeriod = budget.incomePeriod
        }
    }

    private func saveBudget() {
        let budget: Budget

        if let existing = budgets.first {
            budget = existing
        } else {
            let newBudget = Budget()
            modelContext.insert(newBudget)
            budget = newBudget
        }

        budget.income = Double(income) ?? 0
        budget.incomePeriod = incomePeriod

        do {
            try modelContext.save()
            showSavedMessage = true
            DispatchQueue.main.asyncAfter(deadline:.now() + 1.5) {
                showSavedMessage = false
            }
        } catch {
            print("Failed to save budget: \(error)")
        }
    }

    private func addCategory() {
        guard !newCategoryTitle.isEmpty else { return }
        modelContext.insert(CategoryBudget(name: newCategoryTitle))
        newCategoryTitle = ""
        try? modelContext.save()
    }
}

#Preview {
    BudgetEditorView().modelContainer(for: [Budget.self, CategoryBudget.self], inMemory: true)
}
