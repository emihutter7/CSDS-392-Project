//
//  EditExpenseView.swift
//  CSDS-392-Project
//
//  Created by Alexandra Twitty on 4/18/26.
//

import SwiftUI
import SwiftData

struct EditExpenseView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \CategoryBudget.name) private var categoryBudgets: [CategoryBudget]

    let expense: Expense

    @State private var title: String = ""
    @State private var category: String = ""
    @State private var date: Date = Date()
    @State private var amount: String = ""
    @State private var note: String = ""
    @State private var transactionType: TransactionType = .expense
    @State private var newCategoryTitle = ""
    @State private var showAddCategoryField = false

    private let backgroundColor = Color("AppBackground")
    private let secondaryAccent = Color("SecondaryAccent")
    private let fieldBorder = Color("FieldBorder")

    private var categories: [String] {
        let saved = categoryBudgets.map(\.name)

        if saved.isEmpty {
            return ["Food", "Bills", "Shopping", "Transportation", "Entertainment", "Salary", "Other"]
        }

        return saved
    }

    private var amountColor: Color {
        transactionType == .income ? .green : Color.accentColor
    }

    var body: some View {
        ZStack {
            backgroundColor
                .ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 22) {
                    Text("Edit Transaction")
                        .font(.system(size: 30, weight: .semibold))
                        .foregroundStyle(secondaryAccent)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding(.top, 8)

                    VStack(alignment: .leading, spacing: 18) {
                        sectionLabel("Transaction Type")

                        Picker("Transaction Type", selection: $transactionType) {
                            ForEach(TransactionType.allCases, id: \.self) { type in
                                Text(type.rawValue).tag(type)
                            }
                        }
                        .pickerStyle(.segmented)
                        .tint(amountColor)

                        sectionLabel("Title")

                        TextField(
                            "",
                            text: $title,
                            prompt: Text("Transaction name")
                                .foregroundColor(secondaryAccent.opacity(0.5))
                        )
                        .foregroundStyle(secondaryAccent)
                        .padding(.horizontal, 16)
                        .frame(height: 52)
                        .background(Color.white)
                        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                        .overlay {
                            RoundedRectangle(cornerRadius: 16, style: .continuous)
                                .stroke(fieldBorder, lineWidth: 1.5)
                        }

                        VStack(alignment: .leading, spacing: 10) {
                            HStack {
                                sectionLabel("Category")

                                Spacer()

                                Button {
                                    showAddCategoryField.toggle()
                                } label: {
                                    Image(systemName: showAddCategoryField ? "minus.circle.fill" : "plus.circle.fill")
                                        .font(.system(size: 20))
                                        .foregroundStyle(amountColor)
                                }
                            }

                            Picker("Category", selection: $category) {
                                if categories.isEmpty {
                                    Text("No categories").tag("")
                                } else {
                                    ForEach(categories, id: \.self) { item in
                                        Text(item).tag(item)
                                    }
                                }
                            }
                            .pickerStyle(.menu)
                            .tint(secondaryAccent)
                            .padding(.horizontal, 14)
                            .frame(height: 52)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(Color.white)
                            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                            .overlay {
                                RoundedRectangle(cornerRadius: 16, style: .continuous)
                                    .stroke(fieldBorder, lineWidth: 1.5)
                            }

                            if showAddCategoryField {
                                HStack(spacing: 10) {
                                    TextField("New category", text: $newCategoryTitle)
                                        .foregroundStyle(secondaryAccent)
                                        .padding(.horizontal, 14)
                                        .frame(height: 52)
                                        .background(Color.white)
                                        .clipShape(RoundedRectangle(cornerRadius: 16))
                                        .overlay {
                                            RoundedRectangle(cornerRadius: 16)
                                                .stroke(fieldBorder, lineWidth: 1.5)
                                        }

                                    Button {
                                        addCategory()
                                    } label: {
                                        Image(systemName: "checkmark.circle.fill")
                                            .font(.system(size: 24))
                                            .foregroundStyle(amountColor)
                                    }
                                }
                            }
                        }

                        sectionLabel("Date")

                        DatePicker(
                            "",
                            selection: $date,
                            displayedComponents: [.date, .hourAndMinute]
                        )
                        .labelsHidden()
                        .datePickerStyle(.compact)
                        .padding(.horizontal, 14)
                        .frame(height: 52)
                        .background(Color.white)
                        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                        .overlay {
                            RoundedRectangle(cornerRadius: 16, style: .continuous)
                                .stroke(fieldBorder, lineWidth: 1.5)
                        }

                        sectionLabel("Amount")

                        TextField(
                            "",
                            text: $amount,
                            prompt: Text("Value")
                                .foregroundColor(secondaryAccent.opacity(0.5))
                        )
                        .keyboardType(.decimalPad)
                        .foregroundStyle(secondaryAccent)
                        .padding(.horizontal, 16)
                        .frame(height: 52)
                        .background(Color.white)
                        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                        .overlay {
                            RoundedRectangle(cornerRadius: 16, style: .continuous)
                                .stroke(fieldBorder, lineWidth: 1.5)
                        }

                        sectionLabel("Notes")

                        TextEditor(text: $note)
                            .scrollContentBackground(.hidden)
                            .foregroundStyle(secondaryAccent)
                            .frame(height: 130)
                            .padding(12)
                            .background(Color.white)
                            .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
                            .overlay(alignment: .topLeading) {
                                if note.isEmpty {
                                    Text("Notes (Optional)")
                                        .foregroundStyle(secondaryAccent.opacity(0.45))
                                        .padding(.top, 22)
                                        .padding(.leading, 18)
                                }
                            }
                            .overlay {
                                RoundedRectangle(cornerRadius: 18, style: .continuous)
                                    .stroke(fieldBorder, lineWidth: 1.5)
                            }
                    }
                    .padding(20)
                    .background(Color.white.opacity(0.7))
                    .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
                    .shadow(color: .black.opacity(0.05), radius: 12, y: 6)

                    Button {
                        saveChanges()
                    } label: {
                        Text("Save Changes")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 56)
                            .background(
                                RoundedRectangle(cornerRadius: 18, style: .continuous)
                                    .fill(amountColor)
                            )
                            .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
                    }
                    .padding(.top, 4)

                    Spacer(minLength: 80)
                }
                .padding(.horizontal, 20)
                .padding(.top, 12)
                .padding(.bottom, 24)
            }
        }
        .navigationBarBackButtonHidden(false)
        .onAppear {
            title = expense.title
            category = expense.category
            date = expense.date
            amount = String(format: "%.2f", expense.amount)
            note = expense.note
            transactionType = expense.type

            if category.isEmpty, let firstCategory = categories.first {
                category = firstCategory
            }
        }
    }

    @ViewBuilder
    private func sectionLabel(_ text: String) -> some View {
        Text(text)
            .font(.system(size: 17, weight: .semibold))
            .foregroundStyle(secondaryAccent)
    }

    private func addCategory() {
        let trimmed = newCategoryTitle.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }

        let alreadyExists = categoryBudgets.contains {
            $0.name.localizedCaseInsensitiveCompare(trimmed) == .orderedSame
        }

        if alreadyExists {
            category = trimmed
            newCategoryTitle = ""
            showAddCategoryField = false
            return
        }

        let newCategory = CategoryBudget(name: trimmed)
        modelContext.insert(newCategory)

        do {
            try modelContext.save()
            category = trimmed
            newCategoryTitle = ""
            showAddCategoryField = false
        } catch {
            print("Failed to save category: \(error)")
        }
    }

    private func saveChanges() {
        guard let amountValue = Double(amount),
              amountValue > 0,
              !title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            return
        }

        expense.title = title.trimmingCharacters(in: .whitespacesAndNewlines)
        expense.category = category.isEmpty ? "Other" : category
        expense.date = date
        expense.amount = amountValue
        expense.note = note.trimmingCharacters(in: .whitespacesAndNewlines)
        expense.type = transactionType

        do {
            try modelContext.save()
            dismiss()
        } catch {
            print("Failed to save edited expense: \(error)")
        }
    }
}

