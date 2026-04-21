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

    private let backgroundColor = Color(red: 0.97, green: 0.95, blue: 0.94)
    private let secondaryAccent = Color(red: 0.55, green: 0.43, blue: 0.35)
    private let fieldBorder = Color(red: 0.88, green: 0.80, blue: 0.81)

    var body: some View {
        ZStack {
            backgroundColor
                .ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 22) {
                    Text("Edit Expense")
                        .font(.system(size: 30, weight: .semibold))
                        .foregroundStyle(secondaryAccent)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding(.top, 8)

                    VStack(alignment: .leading, spacing: 18) {
                        sectionLabel("Title")

                        TextField(
                            "",
                            text: $title,
                            prompt: Text("Expense name")
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

                        sectionLabel("Category")

                        Picker("Category", selection: $category) {
                            ForEach(categories, id: \.self) { item in
                                Text(item).tag(item)
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
        }
    }

    @ViewBuilder
    private func sectionLabel(_ text: String) -> some View {
        Text(text)
            .font(.system(size: 17, weight: .semibold))
            .foregroundStyle(secondaryAccent)
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
