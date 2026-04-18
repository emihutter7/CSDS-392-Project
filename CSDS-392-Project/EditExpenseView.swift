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

    let expense: Expense

    @State private var title: String = ""
    @State private var category: String = "Food"
    @State private var date: Date = Date()
    @State private var amount: String = ""
    @State private var note: String = ""

    private let categories = ["Food", "Rent", "Fun", "Transport", "Education"]

    var body: some View {
        ZStack {
            Color(red: 0.80, green: 0.68, blue: 0.40)
                .ignoresSafeArea()

            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    Text("Edit Expense")
                        .font(.system(size: 28, weight: .medium))
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding(.top, 8)

                    Group {
                        Text("Title")
                            .font(.system(size: 18, weight: .medium))
                            .foregroundStyle(.white)

                        TextField("Expense name", text: $title)
                            .padding()
                            .background(.white)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                    }

                    Group {
                        Text("Category")
                            .font(.system(size: 18, weight: .medium))
                            .foregroundStyle(.white)

                        Picker("Category", selection: $category) {
                            ForEach(categories, id: \.self) { item in
                                Text(item).tag(item)
                            }
                        }
                        .pickerStyle(.menu)
                        .padding(.horizontal, 12)
                        .frame(height: 44)
                        .background(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                    }

                    Group {
                        Text("Date")
                            .font(.system(size: 18, weight: .medium))
                            .foregroundStyle(.white)

                        DatePicker(
                            "",
                            selection: $date,
                            displayedComponents: [.date, .hourAndMinute]
                        )
                        .labelsHidden()
                        .tint(.blue)
                    }

                    Group {
                        Text("Amount")
                            .font(.system(size: 18, weight: .medium))
                            .foregroundStyle(.white)

                        TextField("Value", text: $amount)
                            .keyboardType(.decimalPad)
                            .padding()
                            .background(.white)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                    }

                    Group {
                        TextEditor(text: $note)
                            .frame(height: 130)
                            .padding(8)
                            .background(.white)
                            .clipShape(RoundedRectangle(cornerRadius: 18))
                            .overlay(alignment: .topLeading) {
                                if note.isEmpty {
                                    Text("Notes (Optional)")
                                        .foregroundStyle(.gray)
                                        .padding(.top, 18)
                                        .padding(.leading, 14)
                                }
                            }
                    }

                    Button {
                        saveChanges()
                    } label: {
                        Text("Save")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundStyle(.purple)
                            .padding(.horizontal, 28)
                            .padding(.vertical, 10)
                            .background(.white.opacity(0.95))
                            .clipShape(Capsule())
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.top, 18)

                    Spacer(minLength: 80)
                }
                .padding(.horizontal, 24)
                .padding(.top, 12)
            }
        }
        .navigationBarBackButtonHidden(false)
        .onAppear {
            title = expense.title
            category = expense.category
            date = expense.date
            amount = String(format: "%.2f", expense.amount)
            note = expense.note
        }
    }

    private func saveChanges() {
        guard let amountValue = Double(amount),
              !title.trimmingCharacters(in: .whitespaces).isEmpty else {
            return
        }

        expense.title = title
        expense.category = category
        expense.date = date
        expense.amount = amountValue
        expense.note = note

        do {
            try modelContext.save()
            dismiss()
        } catch {
            print("Failed to save edited expense: \(error)")
        }
    }
}
