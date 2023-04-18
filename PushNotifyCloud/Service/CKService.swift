//
//  CKService.swift
//  PushNotifyCloud
//
//  Created by Tân Nguyễn on 03/04/2023.
//

import Foundation
import CloudKit
import UserNotifications

class CKService {
    private init() {}
    static let shared = CKService()
    
    let privateDataBase = CKContainer.default().privateCloudDatabase
    
    
    let unCenter = UNUserNotificationCenter.current()
    
    func authorize() {
        let options: UNAuthorizationOptions = [.alert,.badge,.sound,.carPlay]
        unCenter.requestAuthorization(options: options) { (granted,error) in
            guard granted else {
                print("USER GRANTED")
                return
            }
        }
    }
    
    func save(record: CKRecord) {
        privateDataBase.save(record) { record, error in
            print(error ?? "No CK Record save error")
            print(record ?? "No CK Record saved")
        }
    }
    
    func query(queryType: String, completion: @escaping ([CKRecord]) -> Void) {
        let query  = CKQuery(recordType: queryType, predicate: NSPredicate(value: true))
        privateDataBase.perform(query, inZoneWith: nil) { (record, error) in
            guard let record = record else { return  }
            DispatchQueue.main.async {
                completion(record)
            }
            
        }
    }
    
    
    func subcribe() {
        let subcription =  CKQuerySubscription(recordType: Note.recordType, predicate: NSPredicate(value: true), options: .firesOnRecordCreation)
        
        let notificationInfo = CKQuerySubscription.NotificationInfo()
        notificationInfo.shouldSendContentAvailable = true
        subcription.notificationInfo = notificationInfo
        
        privateDataBase.save(subcription) { (record, error) in
            print(error ?? "No CK")
            print(record ?? "unable subcription")
        }
    }
    
    func fetchRecord(withRecordId: CKRecord.ID) {
        privateDataBase.fetch(withRecordID: withRecordId) { record, error in
            print(error ?? "no record fetch error")
            guard let record = record else { return
             NotificationCenter.default.post(name: NSNotification.Name("internalNotifycation.fetchedRecord"), object: record)
            }
        }
    }
     
    func handlerPushnotify(with user: [AnyHashable:Any]) {
        let notify = CKNotification(fromRemoteNotificationDictionary: user)
        switch notify?.notificationType {
        case .query:
            guard let queryNotify = notify as? CKQueryNotification, let recordId =  queryNotify.recordID else { return }
            fetchRecord(withRecordId: recordId)
        default : return
        }
    }
}
