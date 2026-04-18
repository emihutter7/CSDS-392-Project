//
//  Expense.swift
//  CSDS-392-Project
//
//  Created by Emi Hutter-DeMarco on 4/14/26.
//

import Foundation
import SwiftData

@Model
final class Expense {
    var title: String
    var amount: Double
    var category: String
    var date: Date
    var note: String

    init(
        title: String,
        amount: Double,
        category: String,
        date: Date = Date(),
        note: String = ""
    ) {
        self.title = title
        self.amount = amount
        self.category = category
        self.date = date
        self.note = note
    }
}
