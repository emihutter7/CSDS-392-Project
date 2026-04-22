//
//  DataFilterHelper.swift
//  CSDS-392-Project
//
//  Created by Alexandra Twitty on 4/22/26.
//

import Foundation

struct DateFilterHelper {

    static func startDate(for period: String) -> Date {
        let calendar = Calendar.current
        let now = Date()

        switch period {
        case "Weekly":
            return calendar.dateInterval(of: .weekOfYear, for: now)?.start ?? now
        case "Yearly":
            return calendar.dateInterval(of: .year, for: now)?.start ?? now
        case "Daily":
            return calendar.startOfDay(for: now)
        default: // "Monthly"
            return calendar.dateInterval(of: .month, for: now)?.start ?? now
        }
    }

    static func filter(_ expenses: [Expense], for period: String) -> [Expense] {
        let start = startDate(for: period)
        return expenses.filter { $0.date >= start }
    }
}
