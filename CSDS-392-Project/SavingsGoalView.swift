//
//  SavingsGoalView.swift
//  CSDS-392-Project
//
//  Created by Iciar on 4/21/26.
//

import SwiftUI
import SwiftData

struct SavingsGoalView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \SavingsGoal.name) private var goals: [SavingsGoal]

    @State private var showAddSheet = false
    @State private var newName = ""
    @State private var newTargetText = ""
    @State private var hasDeadline = false
    @State private var newDeadline = Date()

    @State private var addAmountText = ""
    @State private var goalToAddTo: SavingsGoal?

    private let backgroundColor = Color(red: 0.97, green: 0.95, blue: 0.94)
    private let accentColor = Color(red: 0.75, green: 0.55, blue: 0.60)
    private let secondaryAccent = Color(red: 0.55, green: 0.43, blue: 0.35)
    private let softBackground = Color(red: 0.99, green: 0.98, blue: 0.97)
    private let fieldBorder = Color(red: 0.88, green: 0.80, blue: 0.81)

    var body: some View {
        ZStack {
            backgroundColor.ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 22) {
                    Text("Savings Goals")
                        .font(.system(size: 30, weight: .semibold))
                        .foregroundStyle(secondaryAccent)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding(.top, 10)

                    if goals.isEmpty {
                        VStack(spacing: 10) {
                            Image(systemName: "banknote")
                                .font(.system(size: 28))
                                .foregroundStyle(secondaryAccent.opacity(0.5))

                            Text("No goals yet")
                                .font(.system(size: 17, weight: .medium))
                                .foregroundStyle(secondaryAccent.opacity(0.7))
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 28)
                    } else {
                        ForEach(goals) { goal in
                            goalCard(goal)
                        }
                    }

                    Button {
                        showAddSheet = true
                    } label: {
                        HStack {
                            Spacer()
                            Image(systemName: "plus")
                            Text("New Goal")
                                .font(.system(size: 18, weight: .semibold))
                            Spacer()
                        }
                        .foregroundStyle(.white)
                        .frame(height: 54)
                        .background(accentColor)
                        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
                    }

                    Spacer(minLength: 100)
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 24)
            }
        }
        .sheet(isPresented: $showAddSheet) {
            addGoalSheet
        }
        .sheet(item: $goalToAddTo) { goal in
            addSavingsSheet(goal: goal)
        }
    }

    // MARK: - Goal card

    @ViewBuilder
    private func goalCard(_ goal: SavingsGoal) -> some View {
        let progress = goal.targetAmount > 0
            ? min(goal.savedAmount / goal.targetAmount, 1.0)
            : 0.0

        VStack(alignment: .leading, spacing: 14) {
            HStack {
                Text(goal.name)
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundStyle(secondaryAccent)

                Spacer()

                Button(role: .destructive) {
                    modelContext.delete(goal)
                    try? modelContext.save()
                } label: {
                    Image(systemName: "trash")
                        .font(.system(size: 14, weight: .medium))
                }
            }

            HStack {
                Text("\(goal.savedAmount, format: .currency(code: "USD"))")
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundStyle(accentColor)

                Text("of \(goal.targetAmount, format: .currency(code: "USD"))")
                    .font(.system(size: 15, weight: .medium))
                    .foregroundStyle(secondaryAccent.opacity(0.7))

                Spacer()

                Text("\(Int(progress * 100))%")
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundStyle(accentColor)
            }

            ProgressView(value: progress)
                .progressViewStyle(.linear)
                .tint(accentColor)
                .scaleEffect(y: 1.6)

            if let deadline = goal.deadline {
                HStack(spacing: 4) {
                    Image(systemName: "calendar")
                        .font(.system(size: 13))
                    Text("Goal: \(deadline, format: .dateTime.month().day().year())")
                        .font(.system(size: 14, weight: .medium))
                }
                .foregroundStyle(secondaryAccent.opacity(0.65))
            }

            if progress >= 1.0 {
                HStack(spacing: 6) {
                    Image(systemName: "checkmark.circle.fill")
                    Text("Goal reached!")
                }
                .font(.system(size: 15, weight: .semibold))
                .foregroundStyle(.green)
            } else {
                Button {
                    addAmountText = ""
                    goalToAddTo = goal
                } label: {
                    HStack {
                        Spacer()
                        Text("Add Savings")
                            .font(.system(size: 16, weight: .semibold))
                        Spacer()
                    }
                    .foregroundStyle(accentColor)
                    .frame(height: 44)
                    .background(
                        RoundedRectangle(cornerRadius: 14, style: .continuous)
                            .stroke(accentColor, lineWidth: 1.5)
                    )
                }
            }
        }
        .padding(18)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
        .shadow(color: .black.opacity(0.05), radius: 12, y: 6)
    }

    // MARK: - Sheet: crear goal nuevo

    private var addGoalSheet: some View {
        NavigationStack {
            ZStack {
                backgroundColor.ignoresSafeArea()

                VStack(spacing: 20) {
                    TextField("", text: $newName,
                              prompt: Text("Goal name").foregroundColor(secondaryAccent.opacity(0.5)))
                        .foregroundStyle(secondaryAccent)
                        .padding(.horizontal, 16)
                        .frame(height: 52)
                        .background(Color.white)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                        .overlay {
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(fieldBorder, lineWidth: 1.5)
                        }

                    TextField("", text: $newTargetText,
                              prompt: Text("Target amount").foregroundColor(secondaryAccent.opacity(0.5)))
                        .keyboardType(.decimalPad)
                        .foregroundStyle(secondaryAccent)
                        .padding(.horizontal, 16)
                        .frame(height: 52)
                        .background(Color.white)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                        .overlay {
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(fieldBorder, lineWidth: 1.5)
                        }

                    Toggle(isOn: $hasDeadline) {
                        Text("Set a deadline")
                            .font(.system(size: 17, weight: .medium))
                            .foregroundStyle(secondaryAccent)
                    }
                    .padding(.horizontal, 4)

                    if hasDeadline {
                        DatePicker("Deadline", selection: $newDeadline, displayedComponents: .date)
                            .foregroundStyle(secondaryAccent)
                            .padding(.horizontal, 4)
                    }

                    Spacer()

                    Button {
                        saveNewGoal()
                    } label: {
                        Text("Create Goal")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 54)
                            .background(accentColor)
                            .clipShape(RoundedRectangle(cornerRadius: 18))
                    }
                }
                .padding(20)
            }
            .navigationTitle("New Goal")
            .navigationBarTitleDisplayMode(.inline)
        }
        .presentationDetents([.medium])
    }

    // MARK: - Sheet: agregar ahorro a un goal

    private func addSavingsSheet(goal: SavingsGoal) -> some View {
        NavigationStack {
            ZStack {
                backgroundColor.ignoresSafeArea()

                VStack(spacing: 20) {
                    Text("Add to \"\(goal.name)\"")
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundStyle(secondaryAccent)

                    TextField("", text: $addAmountText,
                              prompt: Text("Amount").foregroundColor(secondaryAccent.opacity(0.5)))
                        .keyboardType(.decimalPad)
                        .foregroundStyle(secondaryAccent)
                        .padding(.horizontal, 16)
                        .frame(height: 52)
                        .background(Color.white)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                        .overlay {
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(fieldBorder, lineWidth: 1.5)
                        }

                    Spacer()

                    Button {
                        if let amount = Double(addAmountText), amount > 0 {
                            goal.savedAmount += amount
                            try? modelContext.save()
                            goalToAddTo = nil
                        }
                    } label: {
                        Text("Add Savings")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 54)
                            .background(accentColor)
                            .clipShape(RoundedRectangle(cornerRadius: 18))
                    }
                }
                .padding(20)
            }
            .presentationDetents([.medium])
        }
    }

    // MARK: - Guardar goal nuevo

    private func saveNewGoal() {
        let trimmed = newName.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty, let target = Double(newTargetText), target > 0 else { return }

        let goal = SavingsGoal(
            name: trimmed,
            targetAmount: target,
            deadline: hasDeadline ? newDeadline : nil
        )
        modelContext.insert(goal)
        try? modelContext.save()

        newName = ""
        newTargetText = ""
        hasDeadline = false
        newDeadline = Date()
        showAddSheet = false
    }
}

#Preview {
    SavingsGoalView()
}