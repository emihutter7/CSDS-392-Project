//
//  CategoryBudget.swift
//  CSDS-392-Project
//
//  Created by Alexandra Twitty on 4/18/26.
//

import SwiftUI
import SwiftData

@Model
final class CategoryBudget {
    var name: String
    var budgetAmount: Double

    init(name: String, budgetAmount: Double = 0) {
        self.name = name
        self.budgetAmount = budgetAmount
    }
}
