//
//  Debugging.swift
//  CSDS-392-Project
//
//  Created by Emi Hutter-DeMarco on 4/7/26.
//

import Foundation

enum Category: String, CaseIterable, Codable, Identifiable {
    case gas = "Gas"
    case rent = "Rent"
    case food = "Food"
    case entertainment = "Entertainment"
    case shopping = "Shopping"
    case transportation = "Transportation"
    case utilities = "Utilities"
    case healthcare = "Healthcare"
    case subscriptions = "Subscriptions"
    case other = "Other"

    var id: String { rawValue }
}

