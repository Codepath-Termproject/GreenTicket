//
//  ChatCellTableViewCell.swift
//  GroupProject
//
//  Created by SiuChun Kung on 10/19/18.
//  Copyright © 2018 SiuChun Kung. All rights reserved.
//

import UIKit
import Parse
import ParseUI
import AlamofireImage

class ChatTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var chat: UITextView!
    
    
    var chatRoom: PFObject!{
        didSet{
            chat.text = (chatRoom["caption"] as! PFUser).username! as String
            profilePic.af_setImage(withURL: URL(string: "https://api.tumblr.com/v2/blog/humansofnewyork.tumblr.com/avatar")!)
            profilePic.clipsToBounds = true
            profilePic.layer.cornerRadius = 7;
            
       
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
