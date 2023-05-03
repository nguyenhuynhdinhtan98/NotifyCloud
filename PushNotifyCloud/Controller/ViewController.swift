//
//  ViewController.swift
//  PushNotifyCloud
//
//  Created by Tân Nguyễn on 03/04/2023.
//

import UIKit
import CloudKit

class ViewController: UIViewController {

    
    @IBOutlet weak var titleLbl: UILabel!
    
    @IBOutlet weak var contentLbl: UILabel!
    
    @IBOutlet weak var tokenLbl: UILabel!
    
    @IBOutlet weak var linkBTN: UIButton!
    
    @IBOutlet weak var linkLBL: UILabel!
    
    var link:String?

    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(handleAction), name: NSNotification.Name("internalNotification.handleAction"), object: nil)
    }

    
    @objc func handleAction(_ sender: Notification) {
        guard let notify = sender.object as? NSDictionary else { return }
        print(notify)
        let title = notify["title"] as? String
        let body = notify["body"] as? String
        let link = notify["link"] as? String
        self.titleLbl.text = title
        self.contentLbl.text = body
        self.linkLBL.text = link
        self.link = link ?? ""
    }
    
    @IBAction func handleDeviceToken() {
        let token = UserDefaults.standard.string(forKey: "token") ?? ""
        print(token)
        UIPasteboard.general.string = token
        tokenLbl.text = token
    }

    @IBAction func openWebsite() {
        if let urlDecode = link {
            guard let url = URL(string: urlDecode) else { return }
            UIApplication.shared.open(url)
        }
    }
}

