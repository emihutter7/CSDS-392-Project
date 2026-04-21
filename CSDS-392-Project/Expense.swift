//
//  Expense.swift
//  CSDS-392-Project
//
//  Created by Emi Hutter-DeMarco on 4/14/26.
//

import SwiftUI
import SwiftData

enum TransactionType: String, Codable, CaseIterable {
    case expense = "Expense"
    case income = "Income"
}

@Model
final class Expense {
    var title: String
    var amount: Double
    var category: String
    var date: Date
    var note: String
    var typeRawValue: String

    var type: TransactionType {
        get { TransactionType(rawValue: typeRawValue) ?? .expense }
        set { typeRawValue = newValue.rawValue }
    }

    init(
        title: String,
        amount: Double,
        category: String,
        date: Date = Date(),
        note: String = "",
        type: TransactionType = .expense
    ) {
        self.title = title
        self.amount = amount
        self.category = category
        self.date = date
        self.note = note
        self.typeRawValue = type.rawValue
    }
}
