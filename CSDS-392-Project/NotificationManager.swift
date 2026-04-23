//
//  NotificationManager.swift
//  CSDS-392-Project
//
//  Created by Emi Hutter-DeMarco on 4/22/26.
//

import Foundation
import UserNotifications

final class NotificationManager {
    static let shared = NotificationManager()

    private init() {}

    func requestPermission() async -> Bool {
        do {
            return try await UNUserNotificationCenter.current().requestAuthorization(
                options: [.alert, .sound, .badge]
            )
        } catch {
            print("Notification permission error: \(error)")
            return false
        }
    }

    func scheduleDailyReminder() async {
        let content = UNMutableNotificationContent()
        content.title = "Budget Reminder"
        content.body = "Don't forget to log today's expenses."
        content.sound = .default

        var dateComponents = DateComponents()
        dateComponents.hour = 7
        dateComponents.minute = 0

        let trigger = UNCalendarNotificationTrigger(
            dateMatching: dateComponents,
            repeats: true
        )

        let request = UNNotificationRequest(
            identifier: "daily-budget-reminder",
            content: content,
            trigger: trigger
        )

        do {
            try await UNUserNotificationCenter.current().add(request)
        } catch {
            print("Failed to schedule reminder: \(error)")
        }
    }

    func removeDailyReminder() {
        UNUserNotificationCenter.current()
            .removePendingNotificationRequests(withIdentifiers: ["daily-budget-reminder"])
    }
}
