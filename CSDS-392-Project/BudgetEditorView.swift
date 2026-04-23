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
    @Environment(\.dismiss) private var dismiss

    @Query private var budgets: [Budget]
    @Query(sort: \CategoryBudget.name) private var categories: [CategoryBudget]

    @State private var viewModel = BudgetEditorViewModel()

    private let backgroundColor = Color(red: 0.97, green: 0.95, blue: 0.94)
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

                        Picker("Period", selection: $viewModel.incomePeriod) {
                            ForEach(viewModel.periods, id: \.self) { Text($0) }
                        }
                        .pickerStyle(.menu)
                        .padding()
                        .background(Color.white)
                        .frame(maxWidth: .infinity)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                        .overlay {
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(fieldBorder, lineWidth: 1.5)
                        }

                        ForEach(categories) { category in
                            CategoryBudgetRow(category: category)
                        }

                        HStack {
                            TextField("New Category", text: $viewModel.newCategoryTitle)
                                .padding()
                                .background(Color.white)
                                .clipShape(RoundedRectangle(cornerRadius: 16))

                            Button {
                                viewModel.addCategory(context: modelContext)
                            } label: {
                                Image(systemName: "plus.circle.fill")
                                    .foregroundStyle(Color.accentColor)
                                    .font(.system(size: 26))
                            }
                        }
                    }
                    .padding(20)
                    .background(Color.white)
                    .clipShape(RoundedRectangle(cornerRadius: 24))
                    .shadow(color: .black.opacity(0.05), radius: 12, y: 6)

                    Button("Save Changes") {
                        viewModel.save(budgets: budgets, context: modelContext) {
                            dismiss()
                        }
                    }
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 56)
                    .background(Color.accentColor)
                    .clipShape(RoundedRectangle(cornerRadius: 18))

                    if viewModel.showSavedMessage {
                        Text("Budget saved!")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundStyle(secondaryAccent)
                            .frame(maxWidth: .infinity, alignment: .center)
                    }

                    Spacer(minLength: 100)
                }
                .padding(.horizontal, 20)
            }
        }
        .onAppear {
            viewModel.seedCategories(existing: categories, context: modelContext)
            viewModel.load(from: budgets)
        }
        .onChange(of: budgets) {
            viewModel.load(from: budgets)
        }
    }
}

