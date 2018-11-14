//
//  ProfileViewController.swift
//  GroupProject
//
//  Created by Ka Lee on 11/5/18.
//  Copyright © 2018 SiuChun Kung. All rights reserved.
//

import UIKit
import Parse
import AlamofireImage

class ProfileViewController: UIViewController {

    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var profilePic: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        username.text = PFUser.current()?.username
        profilePic.af_setImage(withURL: URL(string: "https://api.tumblr.com/v2/blog/humansofnewyork.tumblr.com/avatar")!)
        profilePic.clipsToBounds = true
        profilePic.layer.cornerRadius = 40;
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
