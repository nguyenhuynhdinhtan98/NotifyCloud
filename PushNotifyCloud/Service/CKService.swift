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
            print(error ?? "No CK Record")
        
        }
    }
}
