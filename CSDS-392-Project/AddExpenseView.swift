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

    @State private var title = ""
    @State private var category = ""
    @State private var date = Date()
    @State private var amount = ""
    @State private var note = ""
    @State private var showSavedMessage = false

    @State private var newCategoryTitle = ""
    @State private var showAddCategoryField = false

    private let backgroundColor = Color(red: 0.97, green: 0.95, blue: 0.94)
    private let secondaryAccent = Color(red: 0.55, green: 0.43, blue: 0.35)
    private let fieldBorder = Color(red: 0.88, green: 0.80, blue: 0.81)

    private var categories: [String] {
        categoryBudgets.map(\.name)
    }

    var body: some View {
        ZStack {
            backgroundColor.ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 22) {
                    Text("Add Expense")
                        .font(.system(size: 30, weight: .semibold))
                        .foregroundStyle(secondaryAccent)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding(.top, 10)

                    VStack(alignment: .leading, spacing: 18) {
                        inputField("Title", text: $title)

                        VStack(alignment: .leading, spacing: 10) {
                            HStack {
                                Text("Category")
                                    .font(.system(size: 17, weight: .semibold))
                                    .foregroundStyle(secondaryAccent)

                                Spacer()

                                Button {
                                    showAddCategoryField.toggle()
                                } label: {
                                    Image(systemName: showAddCategoryField ? "minus.circle.fill" : "plus.circle.fill")
                                        .font(.system(size: 20))
                                        .foregroundStyle(Color.accentColor)
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
                            .padding(.horizontal, 14)
                            .frame(height: 52)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(Color.white)
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                            .overlay {
                                RoundedRectangle(cornerRadius: 16)
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
                                            .foregroundStyle(Color.accentColor)
                                    }
                                }
                            }
                        }

                        VStack(alignment: .leading, spacing: 10) {
                            Text("Date")
                                .font(.system(size: 17, weight: .semibold))
                                .foregroundStyle(Color.accentColor)

                            DatePicker(
                                "",
                                selection: $date,
                                displayedComponents: [.date, .hourAndMinute]
                            )
                            .labelsHidden()
                            .datePickerStyle(.compact)
                            .tint(.accentColor)
                            .padding(.horizontal, 14)
                            .frame(height: 52)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(Color.white)
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                            .overlay {
                                RoundedRectangle(cornerRadius: 16)
                                    .stroke(Color.accentColor.opacity(0.25), lineWidth: 1.5)
                            }
                        }

                        inputField("Amount", text: $amount, keyboard: .decimalPad)

                        TextEditor(text: $note)
                            .frame(height: 130)
                            .padding(12)
                            .background(Color.white)
                            .clipShape(RoundedRectangle(cornerRadius: 18))
                            .overlay {
                                RoundedRectangle(cornerRadius: 18)
                                    .stroke(fieldBorder, lineWidth: 1.5)
                            }
                            .overlay(alignment: .topLeading) {
                                if note.isEmpty {
                                    Text("Notes (Optional)")
                                        .foregroundStyle(secondaryAccent.opacity(0.45))
                                        .padding(.top, 18)
                                        .padding(.leading, 16)
                                }
                            }
                    }
                    .padding(20)
                    .background(Color.white)
                    .clipShape(RoundedRectangle(cornerRadius: 24))
                    .shadow(color: .black.opacity(0.05), radius: 12, y: 6)

                    Button {
                        saveExpense()
                    } label: {
                        Text("Add Expense")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundStyle(secondaryAccent)
                            .frame(maxWidth: .infinity)
                            .frame(height: 56)
                            .background(
                                RoundedRectangle(cornerRadius: 18, style: .continuous)
                                    .fill(Color.accentColor)
                            )
                    }

                    if showSavedMessage {
                        Text("Expense saved")
                            .foregroundStyle(secondaryAccent)
                            .frame(maxWidth: .infinity, alignment: .center)
                    }

                    Spacer(minLength: 100)
                }
                .padding(.horizontal, 20)
                .padding(.top, 12)
            }
        }
        .onAppear {
            if category.isEmpty, let firstCategory = categories.first {
                category = firstCategory
            }
        }
    }

    private func inputField(_ label: String, text: Binding<String>, keyboard: UIKeyboardType = .default) -> some View {
        TextField(label, text: text)
            .keyboardType(keyboard)
            .foregroundStyle(secondaryAccent)
            .padding(.horizontal, 14)
            .frame(height: 52)
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .overlay {
                RoundedRectangle(cornerRadius: 16)
                    .stroke(fieldBorder, lineWidth: 1.5)
            }
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

    private func saveExpense() {
        let trimmedTitle = title.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedNote = note.trimmingCharacters(in: .whitespacesAndNewlines)

        guard !trimmedTitle.isEmpty,
              let amountValue = Double(amount),
              !category.isEmpty else {
            return
        }

        let newExpense = Expense(
            title: trimmedTitle,
            amount: amountValue,
            category: category,
            date: date,
            note: trimmedNote
        )

        modelContext.insert(newExpense)

        title = ""
        amount = ""
        note = ""
        date = Date()
        showSavedMessage = true

        if let firstCategory = categories.first {
            category = firstCategory
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            showSavedMessage = false
        }
    }
}

#Preview {
    AddExpenseView()
}
