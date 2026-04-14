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
    var amount: Double
    var category: Category
    var date: Date
    var note: String

    init(amount: Double, category: Category, date: Date, note: String) {
        self.amount = amount
        self.category = category
        self.date = date
        self.note = note
    }
}
