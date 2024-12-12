//  AppDelegate.swift
//  BillManager
//

import UIKit
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {

    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
    ) {
        completionHandler([.banner, .sound]) 
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if let error = error {
                print("Failed to request authorization: \(error.localizedDescription)")
            } else if granted {
                print("Notification authorization granted.")
            } else {
                print("Notification authorization denied.")
            }
        }
        
        
        let remindInAnHourAction = UNNotificationAction(
            identifier: "REMIND_IN_AN_HOUR",
            title: "Remind me in an hour",
            options: []
        )
        
        let markAsPaidAction = UNNotificationAction(
            identifier: "MARK_AS_PAID",
            title: "Mark as Paid",
            options: [.authenticationRequired]
        )
        
        
        let billCategory = UNNotificationCategory(
            identifier: Bill.notificationCategoryID,
            actions: [remindInAnHourAction, markAsPaidAction],
            intentIdentifiers: [],
            options: []
        )
        
        
        notificationCenter.setNotificationCategories([billCategory])
        
        
        notificationCenter.delegate = self
        
        return true
    }
    
    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {}
    
    // MARK: UNUserNotificationCenterDelegate
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        let actionIdentifier = response.actionIdentifier
        let requestIdentifier = response.notification.request.identifier
        
        
        if let billID = UUID(uuidString: requestIdentifier), var bill = Database.shared.getBill(withID: billID) {
            switch actionIdentifier {
            case "REMIND_IN_AN_HOUR":
                
                let newTrigger = UNTimeIntervalNotificationTrigger(timeInterval: 3600, repeats: false)
                let newRequest = UNNotificationRequest(identifier: requestIdentifier, content: response.notification.request.content, trigger: newTrigger)
                UNUserNotificationCenter.current().add(newRequest) { error in
                    if let error = error {
                        print("Failed to reschedule notification: \(error.localizedDescription)")
                    } else {
                        print("Notification rescheduled for one hour later.")
                    }
                }
            case "MARK_AS_PAID":
                
                bill.paidDate = Date()
                bill.isPaid = true
                Database.shared.updateAndSave(bill)
                print("Bill marked as paid: \(bill.id)")
            default:
                break
            }
        } else {
            print("No bill found for notification ID: \(requestIdentifier)")
        }
        
        
        completionHandler()
    }

}
