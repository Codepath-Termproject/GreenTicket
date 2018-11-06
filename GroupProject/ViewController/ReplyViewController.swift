//
//  ReplyViewController.swift
//  GroupProject
//
//  Created by SiuChun Kung on 11/4/18.
//  Copyright © 2018 SiuChun Kung. All rights reserved.
//

import UIKit
import ParseUI
import AlamofireImage

class ReplyViewController: UIViewController {

    @IBOutlet weak var profilePic: PFImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var messageField: UITextView!
    
    var post : PFObject? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let posts = post {
            //authorLabel.text = (instagramPost["author"] as! PFUser).username! as String
            let username = (posts["author"] as! PFUser).username! as String
            self.navigationItem.title = username
            usernameLabel.text = username
            profilePic.af_setImage(withURL: URL(string: "https://api.tumblr.com/v2/blog/humansofnewyork.tumblr.com/avatar")!)
            profilePic.clipsToBounds = true
            profilePic.layer.cornerRadius = 40;
           
        }
       

        
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
