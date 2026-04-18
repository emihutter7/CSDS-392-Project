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
    var monthlyLimit: Double

    init(monthlyLimit: Double = 2000) {
        self.monthlyLimit = monthlyLimit
    }
}
