//
//  ViewController.swift
//  PushNotifyCloud
//
//  Created by Tân Nguyễn on 03/04/2023.
//

import UIKit
import CloudKit

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var notes =  [Note]()
    override func viewDidLoad() {
        super.viewDidLoad()
        CKService.shared.subcribe()
        NotificationCenter.default.addObserver(self, selector: #selector(handlerFetching), name: Notification.Name("internalNotifycation.fetchedRecord"), object: nil)
        getNote()
    }
    
    func getNote() {
        NoteService.getNotes { notes in
            self.notes =  notes
            self.tableView.reloadData()
        }
    }
    
    @IBAction func onComposePressed() {
        AlertService.composeNote(in: self) { note in
            CKService.shared.save(record: note.noteRecord())
            self.insert(note: note)
        }
    }

    func insert(note: Note) {
        notes.insert(note, at: 0)
        let indexPath = IndexPath(row: 0, section: 0)
        tableView.insertRows(at: [indexPath], with: .automatic)
    }
    
    @objc
    func handlerFetching(_ sender: Notification) {
        guard let record = sender.object as? CKRecord,   let note = Note(record: record) else { return }
            insert(note: note)
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tableViewCell = UITableViewCell()
        tableViewCell.textLabel?.text = notes[indexPath.row].title
        return tableViewCell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return notes.count
    }
}

