//
//  NotifyService.swift
//  PushNotifyCloud
//
//  Created by Tân Nguyễn on 18/04/2023.
//

import Foundation
import UserNotifications

class NotifyService: NSObject {
    
    //9RBPF7QFGU
    //8PXK453PV3
    //aa85b089df6e3d882a1bc7c973aa1787d7b91b06e8ce4e60ffbbf537a769103c
    
    private override init() {}
    
    static let shared = NotifyService()
    
    
    let unCenter = UNUserNotificationCenter.current()
    
    
    func registerForPushNotifications() {
        
        unCenter.delegate = self
        UNUserNotificationCenter.current()
            .requestAuthorization(
                options: [.alert, .sound, .badge]) {  granted, _ in
                    print("Permission granted: \(granted)")
                    self.getNotificationSettings()
                }
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
