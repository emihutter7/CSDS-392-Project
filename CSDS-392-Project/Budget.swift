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
    var income: Double
    var incomePeriod: String

    init(income: Double = 0, incomePeriod: String = "Monthly") {
        self.income = income
        self.incomePeriod = incomePeriod
    }
}
