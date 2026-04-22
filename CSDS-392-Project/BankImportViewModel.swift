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
            let accounts = try await TellerService.shared.fetchAccounts(accessToken: accessToken)
            var importedCount = 0

            for account in accounts {
                let transactions = try await TellerService.shared.fetchTransactions(
                    accountId: account.id,
                    accessToken: accessToken
                )

                for transaction in transactions {
                    guard let amount = Double(transaction.amount) else { continue }

                    let transactionType: TransactionType = amount < 0 ? .expense : .income

                    let importedTransaction = Expense(
                        title: transaction.description,
                        amount: abs(amount),
                        category: transaction.details?.category ?? (transactionType == .income ? "Income" : "Imported"),
                        date: parsedDate(transaction.date) ?? Date(),
                        note: transaction.description,
                        type: transactionType
                    )

                    modelContext.insert(importedTransaction)
                    importedCount += 1
                }
            }

            try modelContext.save()
            statusMessage = "Imported \(importedCount) transactions."
        } catch {
            statusMessage = "Import failed: \(error.localizedDescription)"
        }
    }

    private func parsedDate(_ string: String) -> Date? {
        let isoFormatter = ISO8601DateFormatter()
        if let date = isoFormatter.date(from: string) {
            return date
        }

        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        return formatter.date(from: string)
    }
}
