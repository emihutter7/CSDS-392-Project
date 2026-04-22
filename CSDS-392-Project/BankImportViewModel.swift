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

                    if amount < 0 {
                        let expense = Expense(
                            title: transaction.description,
                            amount: abs(amount),
                            category: transaction.details?.category ?? "Imported",
                            date: isoDate(transaction.date) ?? Date()
                        )
                        modelContext.insert(expense)
                    } else if amount > 0 {
                        let income = Income(
                            amount: amount,
                            source: transaction.description,
                            date: isoDate(transaction.date) ?? Date()
                        )
                        modelContext.insert(income)
                    }

                    importedCount += 1
                }
            }

            try modelContext.save()
            statusMessage = "Imported \(importedCount) transactions."
        } catch {
            statusMessage = "Import failed: \(error.localizedDescription)"
        }
    }

    private func isoDate(_ string: String) -> Date? {
        let formatter = ISO8601DateFormatter()
        return formatter.date(from: string)
    }
}
