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
    
    func nextPay(purchaseDate: Date, freq: String) -> Date {
        let calendar = Calendar.current
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        let currDate = calendar.startOfDay(for: Date.now)
        
        let pDate = calendar.startOfDay(for: purchaseDate)
        let delta = calendar.dateComponents([.year, .month, .day], from: pDate, to: currDate)
        let years = delta.year!
        let months = delta.month!
        let days = delta.day!
        
        var toAdd = DateComponents()

        if freq == "monthly" {
            if months > 0 {
                toAdd.day = days % 30 == 0 ? days % 30 : (30 - (days % 30))
                
                return calendar.date(byAdding: toAdd, to: currDate)!
            } else {
                if 30 - days <= 7 {
                    toAdd.day = 30 - days
                    
                    return calendar.date(byAdding: toAdd, to: currDate)!
                }
            }
        } else if freq == "yearly" {
            if years > 0 {
                toAdd.day = days % 365 == 0 ? days & 365 : (365 - (days % 365))
                
                return calendar.date(byAdding: toAdd, to: currDate)!
            } else {
                if 365 - days <= 7 {
                    toAdd.day = 365 - days
                    
                    return calendar.date(byAdding: toAdd, to: currDate)!
                }
            }
        }
        toAdd.day = 30
        return calendar.date(byAdding: toAdd, to: currDate)!
    }
    
    func scheduleNofitication(id: String, title: String, body: String, date: Date, remindBefore: Int) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = .default
        content.badge = 1
        
        // calendar schedule
        var dateComponents = DateComponents()
        let evaluatedDate = Calendar.current.date(byAdding: .day, value: remindBefore * -1, to: date) ?? date
        let dateSeparated = Calendar.current.dateComponents([.day, .year, .month], from: evaluatedDate)
        dateComponents.year = dateSeparated.year!
        dateComponents.month = dateSeparated.month!
        dateComponents.day = dateSeparated.day!
        dateComponents.hour = 7
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        
        let request = UNNotificationRequest(
            identifier: id,
            content: content,
            trigger: trigger
        )
        
        UNUserNotificationCenter.current().add(request)
    }
    
    func scheduleAllNotifications(subs: [SubItem], remindBefore: Int) {
        for sub in subs {
            let title = sub.name
            let body = "The following subscription is due \(remindBefore > 0 ? "\(remindBefore == 1 ? "tomorrow" : "\(remindBefore) days")" : "today")."
            let date = nextPay(purchaseDate: sub.purchaseDate, freq: sub.freq)
            scheduleNofitication(id: sub.id, title: title, body: body, date: date, remindBefore: remindBefore)
        }
    }
    
    func cancelNotification(id: String) {
        let center = UNUserNotificationCenter.current()
        center.removePendingNotificationRequests(withIdentifiers: [id])
    }
    
    func cancelAllNotifications() {
        let center = UNUserNotificationCenter.current()
        center.removeAllPendingNotificationRequests()
    }
}
