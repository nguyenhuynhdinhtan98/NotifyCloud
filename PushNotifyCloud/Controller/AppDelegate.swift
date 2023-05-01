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
        configApplePush(application)
        NotifyService.shared.registerForPushNotifications()
        return true
    }

    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        completionHandler(.newData)
    }
    
    
    func application(  _ application: UIApplication,  didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let tokenParts = deviceToken.map { data in String(format: "%02.2hhx", data) }
        let token = tokenParts.joined()
        NotificationCenter.default.post(name: NSNotification.Name("internalNotification.handleDeviceToken"), object: token)
        let defaults = UserDefaults.standard
        Messaging.messaging().apnsToken = deviceToken
        Messaging.messaging().subscribe(toTopic: "ChatBot")
        Messaging.messaging().token { token, error in
            if let error = error {
                print("Error fetching FCM registration token: \(error)")
            } else if let token = token {
                print("FCM registration token: \(token)")
                Messaging.messaging().apnsToken = deviceToken
                Messaging.messaging().subscribe(toTopic: "ChatBot")
                defaults.set((token), forKey: "token")
            }
        }
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("failed to register for remote notifications with with error: \(error)")
    }
    
    func configApplePush(_ application: UIApplication) {
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
           
           application.registerForRemoteNotifications()
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

