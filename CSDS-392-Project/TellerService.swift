//
//  TellerService.swift
//  CSDS-392-Project
//
//  Created by Emi Hutter-DeMarco on 4/21/26.
//
import Foundation

struct MockTellerTransaction: Identifiable {
    let id: UUID
    let description: String
    let amount: Double
    let date: Date

    init(id: UUID = UUID(), description: String, amount: Double, date: Date) {
        self.id = id
        self.description = description
        self.amount = amount
        self.date = date
    }

    func mappedCategory() -> String {
        let text = description.lowercased()

        if text.contains("uber") || text.contains("lyft") || text.contains("bus") || text.contains("train") {
            return "Transportation"
        } else if text.contains("shell") || text.contains("bp") || text.contains("exxon") || text.contains("gas") {
            return "Gas"
        } else if text.contains("rent") || text.contains("lease") || text.contains("apartment") {
            return "Rent"
        } else if text.contains("restaurant") || text.contains("cafe") || text.contains("doordash") || text.contains("ubereats") || text.contains("grocery") {
            return "Food"
        } else if text.contains("spotify") || text.contains("netflix") || text.contains("subscription") {
            return "Subscriptions"
        } else if text.contains("hospital") || text.contains("pharmacy") || text.contains("cvs") || text.contains("walgreens") {
            return "Healthcare"
        } else if text.contains("electric") || text.contains("water") || text.contains("internet") || text.contains("utility") {
            return "Utilities"
        } else if text.contains("amazon") || text.contains("target") || text.contains("walmart") {
            return "Shopping"
        } else if text.contains("movie") || text.contains("bar") || text.contains("concert") {
            return "Entertainment"
        } else {
            return "Other"
        }
    }
}

final class MockTellerService {
    static let shared = MockTellerService()

    private init() {}

    func fetchTransactions() async -> [MockTellerTransaction] {
        try? await Task.sleep(nanoseconds: 1_000_000_000)

        return [
            MockTellerTransaction(description: "Uber Ride", amount: 18.75, date: Date()),
            MockTellerTransaction(description: "Shell Gas", amount: 42.10, date: Date().addingTimeInterval(-86400)),
            MockTellerTransaction(description: "Spotify Subscription", amount: 10.99, date: Date().addingTimeInterval(-172800)),
            MockTellerTransaction(description: "Grocery Store", amount: 84.32, date: Date().addingTimeInterval(-259200)),
            MockTellerTransaction(description: "Target Purchase", amount: 36.45, date: Date().addingTimeInterval(-345600))
        ]
    }
}
