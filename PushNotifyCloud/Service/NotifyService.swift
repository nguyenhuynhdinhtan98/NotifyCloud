//
//  NotifyService.swift
//  PushNotifyCloud
//
//  Created by Tân Nguyễn on 18/04/2023.
//

import Foundation
import UserNotifications
import UIKit

class NotifyService: NSObject {
    
    private override init() {}
    
    static let shared = NotifyService()
    
    
    let unCenter = UNUserNotificationCenter.current()
    
    
    func registerForPushNotifications(_ application: UIApplication) {
        unCenter.delegate = self
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().delegate = self
            let authOptions: UNAuthorizationOptions = [.alert, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in })
        } else {
            let settings: UIUserNotificationSettings =
            UIUserNotificationSettings(types: [.alert, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        self.getNotificationSettings()
        application.registerForRemoteNotifications()
    }
    
    func getNotificationSettings() {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            print("Notification settings: \(settings)")
        }
    }
}

extension NotifyService: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        NotificationCenter.default.post(name: NSNotification.Name("internalNotification.handleAction"), object: userInfo)
        completionHandler()
    }
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let options: UNNotificationPresentationOptions = [.alert,.sound]
        completionHandler(options)
    }
}
