//
//  AppDelegate.swift
//  PushNotifyCloud
//
//  Created by Tân Nguyễn on 03/04/2023.
//

import UIKit
import Firebase
import FirebaseMessaging
import UserNotifications

@main
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate, MessagingDelegate  {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        Messaging.messaging().delegate = self
        NotifyService.shared.registerForPushNotifications(application)
        return true
    }

    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        completionHandler(.newData)
    }
    
    
    func application(  _ application: UIApplication,  didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let tokenParts = deviceToken.map { data in String(format: "%02.2hhx", data) }
        let token = tokenParts.joined()
        NotificationCenter.default.post(name: NSNotification.Name("internalNotification.handleDeviceToken"), object: token)
        let defaultChatBot = UserDefaults.standard
        Messaging.messaging().apnsToken = deviceToken
        Messaging.messaging().subscribe(toTopic: "ChatBot")
        defaultChatBot.set((token), forKey: "token")
        let defaultCrawData = UserDefaults.standard
        Messaging.messaging().apnsToken = deviceToken
        Messaging.messaging().subscribe(toTopic: "CrawData")
        defaultCrawData.set((token), forKey: "token")
        
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("failed to register for remote notifications with with error: \(error)")
    }
    
    func userNotificationCenter(
          _ center: UNUserNotificationCenter,
          willPresent notification: UNNotification,
          withCompletionHandler completionHandler:
          @escaping (UNNotificationPresentationOptions) -> Void
      ) {
          completionHandler([[.banner, .sound]])
      }
}

