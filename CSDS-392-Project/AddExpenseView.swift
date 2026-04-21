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
    @State private var transactionType: TransactionType = .expense
    @State private var showSavedMessage = false
    @State private var showAddCategoryField = false
    @State private var newCategoryTitle = ""
    
    private let backgroundColor = Color(red: 0.97, green: 0.95, blue: 0.94)
    private let secondaryAccent = Color(red: 0.55, green: 0.43, blue: 0.35)
    private let fieldBorder = Color(red: 0.88, green: 0.80, blue: 0.81)
    
    private var categories: [String] {
        let savedCategories = categoryBudgets.map(\.name)

        if savedCategories.isEmpty {
            return ["Food", "Bills", "Shopping", "Transportation", "Entertainment", "Salary", "Other"]
        }

        return savedCategories
    }
    
    private var amountColor: Color {
        transactionType == .income ? .green : Color.accentColor
    }
    
    private var buttonTitle: String {
        transactionType == .income ? "Add Income" : "Add Expense"
    }
    
    var body: some View {
        ZStack {
            backgroundColor.ignoresSafeArea()
            
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 22) {
                    Text("Add Transaction")
                        .font(.system(size: 30, weight: .semibold))
                        .foregroundStyle(secondaryAccent)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding(.top, 10)
                    
                    VStack(alignment: .leading, spacing: 18) {
                        VStack(alignment: .leading, spacing: 10){
                            Text("Transaction Type")
                                .font(.system(size: 17, weight: .semibold))
                                .foregroundStyle(secondaryAccent)
                            
                            Picker("Transaction Type", selection: $transactionType) {
                                ForEach(TransactionType.allCases, id: \.self) { type in
                                    Text(type.rawValue).tag(type)
                                }
                            }
                            .pickerStyle(.segmented)
                            .tint(amountColor)
                        }
                    }
                    inputField(transactionType == .income ? "Income title" : "Expense title", text: $title)
                    
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Category")
                            .font(.system(size: 17, weight: .semibold))
                            .foregroundStyle(secondaryAccent)

                        Picker("Category", selection: $category) {
                            ForEach(categories, id: \.self) { item in
                                Text(item).tag(item)
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

                        TextField("Or enter new category", text: $newCategoryTitle)
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
                    saveTransaction()
                } label: {
                    Text(buttonTitle)
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 56)
                        .background(
                            RoundedRectangle(cornerRadius: 18, style: .continuous)
                                .fill(Color.accentColor)
                        )
                }
                
                if showSavedMessage {
                    Text("\(transactionType.rawValue) saved")
                        .foregroundStyle(secondaryAccent)
                        .frame(maxWidth: .infinity, alignment: .center)
                }
                
                Spacer(minLength: 100)
            }
            .padding(.horizontal, 20)
            .padding(.top, 12)
        }
        .onAppear {
            seedDefaultCategories()

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
    
    private func seedDefaultCategories() {
        guard categoryBudgets.isEmpty else { return }

        let defaults = ["Food", "Bills", "Shopping", "Transportation", "Entertainment", "Salary", "Other"]

        for item in defaults {
            modelContext.insert(CategoryBudget(name: item))
        }

        do {
            try modelContext.save()
        } catch {
            print("Failed to seed categories: \(error)")
        }
    }
    
    
    
    private func saveTransaction() {
        let trimmedTitle = title.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedNote = note.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard !trimmedTitle.isEmpty,
              let amountValue = Double(amount),
              amountValue > 0 else {
            return
        }
        
        let finalCategory = !newCategoryTitle.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
            ? newCategoryTitle.trimmingCharacters(in: .whitespacesAndNewlines)
            : category

        let alreadyExists = categoryBudgets.contains {
            $0.name.localizedCaseInsensitiveCompare(finalCategory) == .orderedSame
        }

        if !finalCategory.isEmpty && !alreadyExists {
            let newCategory = CategoryBudget(name: finalCategory)
            modelContext.insert(newCategory)
        }

        let transaction = Expense(
            title: trimmedTitle,
            amount: amountValue,
            category: finalCategory.isEmpty ? "Other" : finalCategory,
            date: date,
            note: trimmedNote,
            type: transactionType
        )
        
        modelContext.insert(transaction)
        
        do {
            try modelContext.save()
            showSavedMessage = true
            title = ""
            amount = ""
            newCategoryTitle = ""
            note = ""
            date = Date()
            transactionType = .expense
            if let firstCategory = categories.first {
                category = firstCategory
            }
        } catch {
            print("Failed to save transaction: \(error)")
        }
    }
}


#Preview {
    AddExpenseView()
}
