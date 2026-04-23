//
//  BankImportViewModel.swift
//  CSDS-392-Project
//
//  Created by Alexandra Twitty on 4/21/26.
//

import Foundation
import SwiftData

@MainActor
@Observable
final class BankImportViewModel {
    var isImporting = false
    var statusMessage = ""
    var linkedInstitutionName: String?

    func handleEnrollment(accessToken: String, institutionName: String?) {
        TellerService.shared.saveAccessToken(accessToken)
        linkedInstitutionName = institutionName
        statusMessage = "Bank linked successfully."
    }

    func importTransactions(modelContext: ModelContext) async {
        guard let accessToken = TellerService.shared.loadAccessToken() else {
            statusMessage = "No bank linked yet."
            return
        }

        isImporting = true
        defer { isImporting = false }

        do {
            try remapExistingTransactions(modelContext: modelContext)

            let existingDescriptor = FetchDescriptor<Expense>()
            let allExpenses = try modelContext.fetch(existingDescriptor)
            let importedIDs = Set(allExpenses.compactMap { $0.tellerTransactionId })

            let accounts = try await TellerService.shared.fetchAccounts(accessToken: accessToken)
            var importedCount = 0
            var skippedCount = 0

            for account in accounts {
                let transactions = try await TellerService.shared.fetchTransactions(
                    accountId: account.id,
                    accessToken: accessToken
                )

                for transaction in transactions {

                    guard !importedIDs.contains(transaction.id) else {
                        skippedCount += 1
                        continue
                    }

                    guard let amount = Double(transaction.amount) else { continue }

                    let transactionType: TransactionType = amount < 0 ?.expense :.income

                    let mappedCategory = mapTellerCategory(
                        transaction.details?.category,
                        type: transactionType
                    )

                    let importedTransaction = Expense(
                        title: transaction.description,
                        amount: abs(amount),
                        category: mappedCategory,
                        date: parsedDate(transaction.date) ?? Date(),
                        note: transaction.description,
                        type: transactionType,
                        tellerTransactionId: transaction.id
                    )

                    modelContext.insert(importedTransaction)
                    importedCount += 1
                }
            }

            try modelContext.save()

            if importedCount == 0 && skippedCount > 0 {
                statusMessage = "All transactions already up to date."
            } else if importedCount == 0 {
                statusMessage = "No transactions found."
            } else {
                statusMessage = "Imported \(importedCount) new transactions."
            }

        } catch {
            statusMessage = "Import failed: \(error.localizedDescription)"
        }
    }

    func remapExistingTransactions(modelContext: ModelContext) throws {
        let tellerRawCategories: Set<String> = [
            "accommodation", "advertising", "bar", "charity", "clothing",
            "dining", "education", "electronics", "entertainment", "fuel",
            "general", "groceries", "health", "home", "insurance",
            "investment", "loan", "office", "phone", "service", "shopping",
            "software", "sport", "tax", "transport", "transportation",
            "utilities", "imported"
        ]

        let descriptor = FetchDescriptor<Expense>()
        let allExpenses = try modelContext.fetch(descriptor)

        for expense in allExpenses {
            if tellerRawCategories.contains(expense.category.lowercased()) {
                expense.category = mapTellerCategory(expense.category, type: expense.type)
            }
        }

        try modelContext.save()
    }

    private func mapTellerCategory(_ tellerCategory: String?, type: TransactionType) -> String {
        if type == .income { return "Income" }

        guard let category = tellerCategory?.lowercased() else { return "General" }

        switch category {
        case "dining", "bar", "groceries":
            return "Food"
        case "utilities", "phone", "insurance", "loan", "service", "tax":
            return "Bills"
        case "entertainment", "sport", "software":
            return "Entertainment"
        case "shopping", "clothing", "electronics":
            return "Shopping"
        case "transport", "transportation", "fuel":
            return "Transportation"
        default:
            return "General"
        }
    }

    private func parsedDate(_ string: String) -> Date? {
        let isoFormatter = ISO8601DateFormatter()
        if let date = isoFormatter.date(from: string) { return date }

        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        return formatter.date(from: string)
    }
}
