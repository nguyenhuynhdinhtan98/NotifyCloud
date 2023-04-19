//
//  AppDelegate.swift
//  PushNotifyCloud
//
//  Created by Tân Nguyễn on 03/04/2023.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        application.registerForRemoteNotifications()
        NotifyService.shared.registerForPushNotifications()
        return true
    }
    
 
    
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        print("Receive notify")
        CKService.shared.handlerPushnotify(with: userInfo)
        completionHandler(.newData)
    }
    
    
    func application(   _ application: UIApplication,       didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data
    ) {
        let tokenParts = deviceToken.map { data in String(format: "%02.2hhx", data) }
        let token = tokenParts.joined()
        print("Device Token: \(token)")
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("failed to register for remote notifications with with error: \(error)")
    }
    
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        print("handling notification")
        if let notification = response.notification.request.content.userInfo as? [String:AnyObject] {
            let message = parseRemoteNotification(notification: notification)
            print(message as Any)
        }
        completionHandler()
    }
     
    private func parseRemoteNotification(notification:[String:AnyObject]) -> String? {
        if let aps = notification["aps"] as? [String:AnyObject] {
            let alert = aps["alert"] as? String
            return alert
        }
        return nil
    }
}

