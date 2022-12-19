//
//  NotificationManager.swift
//  TrackYourSubs
//
//  Created by Max Shelepov on 12/18/22.
//

import Foundation
import SwiftUI
import UserNotifications

class NotificationManager: ObservableObject {
    func requestAuthorization() {
        let options: UNAuthorizationOptions = [.alert, .sound, .badge]
        UNUserNotificationCenter.current().requestAuthorization(options: options) { (success, error) in
            if let error = error {
                print("Error: \(error)")
            } else {
                print("Success!")
            }
        }
    }
    func scheduleNofitication(title: String, subtitle: String) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.subtitle = subtitle
        content.sound = .default
        content.badge = 1
        
        // calendar schedule
        var dateComponents = DateComponents()
        dateComponents.hour = 19
        dateComponents.minute = 19
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        
        let request = UNNotificationRequest(
            identifier: UUID().uuidString,
            content: content,
            trigger: trigger
        )
        
        UNUserNotificationCenter.current().add(request)
    }
}
