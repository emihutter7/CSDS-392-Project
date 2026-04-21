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

    private let backgroundColor = Color(red: 0.97, green: 0.95, blue: 0.94)
    private let secondaryAccent = Color(red: 0.55, green: 0.43, blue: 0.35)
    private let fieldBorder = Color(red: 0.88, green: 0.80, blue: 0.81)

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

                    VStack(spacing: 18) {

                        inputField("Title", text: $title)

                        PickerField(
                            label: "Category",
                            selection: $category,
                            options: categories
                        )

                        DatePicker(
                            "Date",
                            selection: $date,
                            displayedComponents: [.date, .hourAndMinute]
                        )
                        .datePickerStyle(.compact)

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
                            .background(Color.white)
                            .clipShape(RoundedRectangle(cornerRadius: 18))
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

    private func PickerField(label: String, selection: Binding<String>, options: [String]) -> some View {
        Picker(label, selection: selection) {
            ForEach(options, id: \.self) { item in
                Text(item).tag(item)
            }
        }
        .pickerStyle(.menu)
        .padding(.horizontal, 14)
        .frame(height: 52)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .overlay {
            RoundedRectangle(cornerRadius: 16)
                .stroke(fieldBorder, lineWidth: 1.5)
        }
    }

    private func saveExpense() {
        guard let amountValue = Double(amount),
              !title.trimmingCharacters(in: .whitespaces).isEmpty else { return }

        modelContext.insert(Expense(
            title: title,
            amount: amountValue,
            category: category,
            date: date,
            note: note
        ))

        title = ""
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
