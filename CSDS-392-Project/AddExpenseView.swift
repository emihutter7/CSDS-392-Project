//
//  AddExpenseView.swift
//  CSDS-392-Project
//
//  Created by Alexandra Twitty on 4/14/26.
//

import SwiftUI
import SwiftData

struct AddExpenseView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \CategoryBudget.name) private var categoryBudgets: [CategoryBudget]

    @Binding var selectedTab: Int
    @State private var viewModel = AddExpenseViewModel()

    private let backgroundColor = Color(red: 0.97, green: 0.95, blue: 0.94)
    private let secondaryAccent = Color(red: 0.55, green: 0.43, blue: 0.35)
    private let fieldBorder = Color(red: 0.88, green: 0.80, blue: 0.81)

    private var amountColor: Color {
        viewModel.transactionType == .income ?.green : Color.accentColor
    }

    var body: some View {
        ZStack {
            backgroundColor.ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(alignment:.leading, spacing: 22) {

                    Text("Add Transaction").font(.system(size: 30, weight:.semibold)).foregroundStyle(secondaryAccent).frame(maxWidth:.infinity, alignment:.center).padding(.top, 10)

                    VStack(alignment:.leading, spacing: 18) {
                        VStack(alignment:.leading, spacing: 10) {
                            Text("Transaction Type").font(.system(size: 17, weight:.semibold)).foregroundStyle(secondaryAccent)

                            Picker("Transaction Type", selection: $viewModel.transactionType) {
                                ForEach(TransactionType.allCases, id: \.self) { type in
                                    Text(type.rawValue).tag(type)
                                }
                            }.pickerStyle(.segmented).tint(amountColor)
                        }
                    }

                    inputField(viewModel.inputPlaceholder, text: $viewModel.title)

                    VStack(alignment:.leading, spacing: 10) {
                        Text("Category").font(.system(size: 17, weight:.semibold)).foregroundStyle(secondaryAccent)

                        Picker("Category", selection: $viewModel.category) {
                            ForEach(viewModel.availableCategories(from: categoryBudgets), id: \.self) { item in
                                Text(item).tag(item)
                            }
                        }.pickerStyle(.menu).padding(.horizontal, 14).frame(height: 52).frame(maxWidth:.infinity, alignment:.leading).background(Color.white).clipShape(RoundedRectangle(cornerRadius: 16)).overlay {
                            RoundedRectangle(cornerRadius: 16).stroke(fieldBorder, lineWidth: 1.5)
                        }

                        TextField("Or enter new category", text: $viewModel.newCategoryTitle).foregroundStyle(secondaryAccent).padding(.horizontal, 14).frame(height: 52).background(Color.white).clipShape(RoundedRectangle(cornerRadius: 16)).overlay {
                                RoundedRectangle(cornerRadius: 16).stroke(fieldBorder, lineWidth: 1.5)
                            }
                    }

                    VStack(alignment:.leading, spacing: 10) {
                        Text("Date").font(.system(size: 17, weight:.semibold)).foregroundStyle(Color.accentColor)

                        DatePicker("", selection: $viewModel.date,
                                   displayedComponents: [.date,.hourAndMinute]).labelsHidden().datePickerStyle(.compact).tint(.accentColor).padding(.horizontal, 14).frame(height: 52).frame(maxWidth:.infinity, alignment:.leading).background(Color.white).clipShape(RoundedRectangle(cornerRadius: 16)).overlay {
                                RoundedRectangle(cornerRadius: 16).stroke(Color.accentColor.opacity(0.25), lineWidth: 1.5)
                            }
                    }

                    inputField("Amount", text: $viewModel.amount, keyboard:.decimalPad)

                    TextEditor(text: $viewModel.note).frame(height: 130).padding(12).background(Color.white).clipShape(RoundedRectangle(cornerRadius: 18)).overlay {
                            RoundedRectangle(cornerRadius: 18).stroke(fieldBorder, lineWidth: 1.5)
                        }.overlay(alignment:.topLeading) {
                            if viewModel.note.isEmpty {
                                Text("Notes (Optional)").foregroundStyle(secondaryAccent.opacity(0.45)).padding(.top, 18).padding(.leading, 16)
                            }
                        }
                }.padding(20).background(Color.white).clipShape(RoundedRectangle(cornerRadius: 24)).shadow(color:.black.opacity(0.05), radius: 12, y: 6)

                Button {
                    let saved = viewModel.saveTransaction(
                        categoryBudgets: categoryBudgets,
                        context: modelContext
                    )

                    if saved {
                        DispatchQueue.main.asyncAfter(deadline:.now() + 0.6) {
                            selectedTab = 1
                        }
                    }
                } label: {
                    Text(viewModel.buttonTitle).font(.system(size: 18, weight:.semibold)).foregroundStyle(.white).frame(maxWidth:.infinity).frame(height: 56).background(
                            RoundedRectangle(cornerRadius: 18, style:.continuous).fill(Color.accentColor)
                        )
                }

                if viewModel.showSavedMessage {
                    Text("\(viewModel.transactionType.rawValue) saved").foregroundStyle(secondaryAccent).frame(maxWidth:.infinity, alignment:.center)
                }

                Spacer(minLength: 100)
            }.padding(.horizontal, 20).padding(.top, 12)
        }.onAppear {
            viewModel.seedDefaultCategories(
                existing: categoryBudgets,
                context: modelContext
            )
            if viewModel.category.isEmpty,
               let first = viewModel.availableCategories(from: categoryBudgets).first {
                viewModel.category = first
            }
        }
    }

    private func inputField(
        _ label: String,
        text: Binding<String>,
        keyboard: UIKeyboardType = .default
    ) -> some View {
        TextField(label, text: text).keyboardType(keyboard).foregroundStyle(secondaryAccent).padding(.horizontal, 14).frame(height: 52).background(Color.white).clipShape(RoundedRectangle(cornerRadius: 16)).overlay {
                RoundedRectangle(cornerRadius: 16).stroke(fieldBorder, lineWidth: 1.5)
            }
    }
}

#Preview {
    AddExpenseView(selectedTab:.constant(2))
}
