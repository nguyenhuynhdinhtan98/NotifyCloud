//
//  Note.swift
//  PushNotifyCloud
//
//  Created by Tân Nguyễn on 03/04/2023.
//

import Foundation
import CloudKit

struct Note {
    static let recordType = "Note"
    var title: String
    
    func noteRecord() -> CKRecord {
        let record =  CKRecord(recordType: Note.recordType)
        record.setValue(title, forKey: "title")
        return record
    }
}
