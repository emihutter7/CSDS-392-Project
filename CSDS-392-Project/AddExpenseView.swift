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

    @State private var title = ""
    @State private var category = "Food"
    @State private var date = Date()
    @State private var amount = ""
    @State private var note = ""
    @State private var showSavedMessage = false

    private let categories = ["Food", "Rent", "Fun", "Transport", "Education"]

    var body: some View {
        ZStack {
            Color(red: 0.80, green: 0.68, blue: 0.40)
                .ignoresSafeArea()

            ScrollView {
                VStack(alignment: .leading, spacing: 22) {
                    Text("Add Expense")
                        .font(.system(size: 30, weight: .medium))
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding(.top, 10)

                    VStack(alignment: .leading, spacing: 10) {
                        Text("Title")
                            .font(.system(size: 24, weight: .medium))
                            .foregroundStyle(.white)

                        TextField("Title", text: $title)
                            .padding(.horizontal, 14)
                            .frame(width: 280, height: 48)
                            .background(.white)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                    }

                    VStack(alignment: .leading, spacing: 10) {
                        Text("Category")
                            .font(.system(size: 24, weight: .medium))
                            .foregroundStyle(.white)

                        Picker("Category", selection: $category) {
                            ForEach(categories, id: \.self) { item in
                                Text(item).tag(item)
                            }
                        }
                        .pickerStyle(.menu)
                        .padding(.horizontal, 12)
                        .frame(width: 170, height: 42)
                        .background(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                    }

                    VStack(alignment: .leading, spacing: 10) {
                        Text("Date")
                            .font(.system(size: 24, weight: .medium))
                            .foregroundStyle(.white)

                        DatePicker(
                            "",
                            selection: $date,
                            displayedComponents: [.date, .hourAndMinute]
                        )
                        .labelsHidden()
                        .tint(.blue)
                    }

                    VStack(alignment: .leading, spacing: 10) {
                        Text("Amount")
                            .font(.system(size: 24, weight: .medium))
                            .foregroundStyle(.white)

                        TextField("Value", text: $amount)
                            .keyboardType(.decimalPad)
                            .padding(.horizontal, 14)
                            .frame(width: 280, height: 48)
                            .background(.white)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                    }

                    VStack(alignment: .leading, spacing: 10) {
                        TextEditor(text: $note)
                            .frame(width: 280, height: 130)
                            .padding(10)
                            .background(.white)
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                            .overlay(
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(Color.black.opacity(0.15), lineWidth: 1)
                            )
                            .overlay(alignment: .topLeading) {
                                if note.isEmpty {
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text("Notes (Optional)")
                                            .foregroundStyle(.gray)
                                        Text("...")
                                            .foregroundStyle(.gray)
                                    }
                                    .padding(.top, 18)
                                    .padding(.leading, 16)
                                }
                            }
                    }

                    Button {
                        saveExpense()
                    } label: {
                        Text("Add Expense")
                            .font(.system(size: 20, weight: .medium))
                            .foregroundStyle(.purple)
                            .padding(.horizontal, 28)
                            .padding(.vertical, 10)
                            .background(.white.opacity(0.95))
                            .clipShape(Capsule())
                            .shadow(radius: 2, y: 1)
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.top, 18)

                    if showSavedMessage {
                        Text("Expense saved")
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity, alignment: .center)
                    }

                    Spacer(minLength: 100)
                }
                .padding(.horizontal, 28)
                .padding(.top, 8)
            }
        }
    }

    private func saveExpense() {
        let trimmedTitle = title.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedNote = note.trimmingCharacters(in: .whitespacesAndNewlines)

        guard !trimmedTitle.isEmpty,
              let amountValue = Double(amount) else {
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
        category = "Food"
        date = Date()
        amount = ""
        note = ""

        showSavedMessage = true

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            showSavedMessage = false
        }
    }
}

#Preview {
    AddExpenseView()
}
