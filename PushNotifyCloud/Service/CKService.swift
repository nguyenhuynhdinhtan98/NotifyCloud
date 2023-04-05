//
//  CKService.swift
//  PushNotifyCloud
//
//  Created by Tân Nguyễn on 03/04/2023.
//

import Foundation
import CloudKit

class CKService {
    private init() {}
    static let shared = CKService()
    
    let privateDataBase = CKContainer.default().privateCloudDatabase
    
    let subcription =  CKQuerySubscription(recordType: Note.recordType, predicate: NSPredicate(value: true), options: .firesOnRecordCreation)

    
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
        
        let notificationInfo = CKQuerySubscription.NotificationInfo()
        notificationInfo.shouldSendContentAvailable = true
        subcription.notificationInfo = notificationInfo
        
        privateDataBase.save(subcription) { (record, error) in
//           print(error ?? "No CK")
            print(record ?? "unable subcription")
        }
    }
}
