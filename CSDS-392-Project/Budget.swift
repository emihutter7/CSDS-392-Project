//
//  Budget.swift
//  CSDS-392-Project
//
//  Created by Emi Hutter-DeMarco on 4/14/26.
//

import Foundation
import SwiftData

@Model
final class Budget {
    var total: Double
    var categoryBudgets: [String: Double]
    var remainingBalance: Double //may or may not need

    init(total: Double, categoryBudgets: [String: Double], remainingBalance: Double) {
        self.total = total
        self.categoryBudgets = categoryBudgets
        self.remainingBalance = remainingBalance
    }
}
