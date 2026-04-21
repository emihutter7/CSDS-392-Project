//
//  Income.swift
//  CSDS-392-Project
//
//  Created by Emi Hutter-DeMarco on 4/14/26.
//

import Foundation
import SwiftData

@Model
final class Income {
    var amount: Double
    var source: String
    var date: Date
    
    init(amount: Double, source: String, date: Date) {
        self.amount = amount
        self.source = source
        self.date = date
    }
}
 

