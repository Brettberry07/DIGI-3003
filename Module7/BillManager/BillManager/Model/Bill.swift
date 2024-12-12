// BillManager

import Foundation
import UserNotifications

struct Bill: Codable {
    let id: UUID
    var amount: Double?
    var dueDate: Date?
    var paidDate: Date?
    var payee: String?
    var remindDate: Date?
    var notificationID: String?
    var isPaid: Bool = false
    
    init(id: UUID = UUID()) {
        self.id = id
    }
}

extension Bill: Hashable {}

extension Bill {
    
    static let notificationCategoryID = "billNotificationCategory"
    
    
    mutating func scheduleReminder(for date: Date, completion: @escaping (Bill) -> Void) {
        
        self.remindDate = date
        
        
        let content = UNMutableNotificationContent()
        content.title = "Reminder for \(payee ?? "Bill")"
        content.body = "Your bill of \(amount ?? 0.0) is due on \(dueDate?.description(with: .current) ?? "a due date")."
        content.categoryIdentifier = Bill.notificationCategoryID
        
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: date.timeIntervalSinceNow, repeats: false)
        let request = UNNotificationRequest(identifier: id.uuidString, content: content, trigger: trigger)
        
        
        let updatedBill = self
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Failed to schedule notification: \(error.localizedDescription)")
            } else {
                print("Notification scheduled successfully.")
            }
            
            completion(updatedBill)
        }
    }
        
        
    mutating func removeReminders() {
        
        let notificationID = id.uuidString
        
        
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [notificationID])
        
        
        self.remindDate = nil
        
        print("Reminder removed for notification ID: \(notificationID)")
    }
}



    
    // Private method to check for notification authorization
    private func checkNotificationAuthorization(completion: @escaping (Bool) -> Void) {
        let notificationCenter = UNUserNotificationCenter.current()
        
        notificationCenter.getNotificationSettings { settings in
            switch settings.authorizationStatus {
            case .authorized:
                completion(true)
            case .notDetermined:
                notificationCenter.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
                    if let error = error {
                        print("Failed to request authorization: \(error.localizedDescription)")
                        completion(false)
                    } else {
                        completion(granted)
                    }
                }
            default:
                completion(false)
            }
        }
    }


