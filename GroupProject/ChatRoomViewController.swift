//
//  ChatRoomViewController.swift
//  GroupProject
//
//  Created by SiuChun Kung on 10/19/18.
//  Copyright © 2018 SiuChun Kung. All rights reserved.
//

import UIKit
import Parse
class ChatRoomViewController: UIViewController {
    
 
    
    
    var post : PFObject? = nil
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var chatMessageField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func onSend(_ sender: Any) {
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
