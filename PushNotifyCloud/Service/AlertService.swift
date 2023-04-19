//
//  AlertService.swift
//  PushNotifyCloud
//
//  Created by Tân Nguyễn on 03/04/2023.
//

import Foundation
import UIKit

class AlertService {
    private init() {}
    
    static func composeNote(in view: UIViewController,completion:@escaping (Note) -> Void) {
        let alert = UIAlertController(title: "New Note", message: "What's on your mind ?",preferredStyle: .alert)
        alert.addTextField { tf in
            tf.placeholder = "Title"
            
        }
        let post = UIAlertAction(title: "Post", style: .default) {_ in
            guard let title = alert.textFields?.first?.text else { return }
            let  note = Note(title: title)
            completion(note)
        }
        alert.addAction(post)
        view.present(alert, animated: true)
    }
}
