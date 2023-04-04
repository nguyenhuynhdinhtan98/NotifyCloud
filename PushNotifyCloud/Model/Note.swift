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
    
    init(title: String) {
        self.title = title
    }
    
    init?(record: CKRecord) {
        guard let title = record.value(forKey: "title") as? String else { return nil }
        self.title = title
    }
    
    func noteRecord() -> CKRecord {
        let record =  CKRecord(recordType: Note.recordType)
        record.setValue(title, forKey: "title")
        return record
    }
}
