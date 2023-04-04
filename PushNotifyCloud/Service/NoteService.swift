//
//  NoteService.swift
//  PushNotifyCloud
//
//  Created by Tân Nguyễn on 04/04/2023.
//

import Foundation

class NoteService {
    private init () {}
    static func getNotes(completion: @escaping ([Note]) -> Void) {
        CKService.shared.query(queryType: Note.recordType) { records in
            var notes = [Note]()
            for record in records {
                guard let note = Note(record: record) else { continue }
                notes.append(note)
            }
            completion(notes)
        }
    }
}
