
//  SavingsGoal.swift
//  CSDS-392-Project
//
//  Created by Iciar on 21/4/26.
//

import Foundation
import SwiftData

@Model
final class SavingsGoal {
    var name: String
    var targetAmount: Double
    var savedAmount: Double
    var deadline: Date?

    init(name: String, targetAmount: Double, savedAmount: Double = 0, deadline: Date? = nil) {
        self.name = name
        self.targetAmount = targetAmount
        self.savedAmount = savedAmount
        self.deadline = deadline
    }
}
