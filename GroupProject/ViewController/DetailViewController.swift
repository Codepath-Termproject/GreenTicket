//
//  DetailViewController.swift
//  GroupProject
//
//  Created by SiuChun Kung on 10/18/18.
//  Copyright © 2018 SiuChun Kung. All rights reserved.
//

import UIKit
import ParseUI

class DetailViewController: UIViewController {
    @IBOutlet weak var postImageView: PFImageView!
    @IBOutlet weak var captionLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    var post : PFObject? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        if let post = post {
            
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MMM-dd"
            let myString = formatter.string(from: post.createdAt!)
            timeLabel.text = myString
            
            captionLabel.text = post["caption"] as! String?
            postImageView.file = post["media"] as? PFFile
            postImageView.loadInBackground()
        }

        // Do any additional setup after loading the view.
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
