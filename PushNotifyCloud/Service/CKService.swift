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
    
    func save(record: CKRecord) {
        privateDataBase.save(record) { record, error in
            print(error ?? "No CK Record save error")
            print(record ?? "No CK Record saved")
        }
    }
    
    func query(queryType: String, completion: @escaping ([CKRecord]) -> Void) {
        let query  = CKQuery(recordType: queryType, predicate: NSPredicate(value: true))
        privateDataBase.perform(query, inZoneWith: nil) { (record, error) in
            print(error)
            guard let record = record else { return  }
            DispatchQueue.main.async {
                completion(record)
            }
          
        }
    }
}
