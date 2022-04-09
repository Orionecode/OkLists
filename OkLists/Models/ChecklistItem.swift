//
//  ChecklistItem.swift
//  CheckList
//
//  Created by 曾一笑 on 2022/3/26.
//

import Foundation
import NotificationCenter

class ChecklistItem: NSObject, Codable {
    var dueDate = Date()
    var shouldRemind = false
    var itemID = -1
    var text = ""
    var checked = false

    override init() {
        super.init()
        itemID = DataModel.nextChecklistItemID()
    }
    
    deinit {
        removeNotification()
    }

    func scheduleNotification() {
        removeNotification()
        if shouldRemind && dueDate > Date() {
            // 1
            let content = UNMutableNotificationContent()
            content.title = "Reminder:"
            content.body = text
            content.sound = UNNotificationSound.default

            // 2
            let calendar = Calendar(identifier: .gregorian)
            let components = calendar.dateComponents(
                [.year, .month, .day, .hour, .minute],
                from: dueDate)
            // 3
            let trigger = UNCalendarNotificationTrigger(
                dateMatching: components,
                repeats: false)
            // 4
            let request = UNNotificationRequest(
                identifier: "\(itemID)",
                content: content,
                trigger: trigger)
            // 5
            let center = UNUserNotificationCenter.current()
            center.add(request)

            print("Scheduled: \(request) for itemID: \(itemID)")
        }
    }
    
    func removeNotification() {
      let center = UNUserNotificationCenter.current()
      center.removePendingNotificationRequests(withIdentifiers: ["\(itemID)"])
    }
}
