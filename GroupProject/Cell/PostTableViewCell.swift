//
//  PostTableViewCell.swift
//  GroupProject
//
//  Created by SiuChun Kung on 10/17/18.
//  Copyright © 2018 SiuChun Kung. All rights reserved.
//

import UIKit
import Parse
import ParseUI
import AlamofireImage

class PostTableViewCell: UITableViewCell {

    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var photoView: PFImageView!
    @IBOutlet weak var profilePic: UIImageView!
    
    @IBOutlet weak var location: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var captionLabel: UILabel!
    
    @IBOutlet weak var timestampLabel: UILabel!

    @IBOutlet weak var favoriteCount: UILabel!
    @IBOutlet weak var heartBtn: UIButton!
    @IBOutlet weak var replyBtn: UIButton!
    
    var favOn: Bool = false
    var numOfLikes: Int = 0
    
    var instagramPost: PFObject!{
        didSet{
            authorLabel.text = (instagramPost["author"] as! PFUser).username! as String
            username.text = (instagramPost["author"] as! PFUser).username! as String
            captionLabel.text = instagramPost["caption"] as? String
            photoView.file = instagramPost["media"] as? PFFile
            photoView.loadInBackground()
            if let cnt = instagramPost["likesCount"] as? String{
                favoriteCount.text = String(cnt)
            }
            profilePic.af_setImage(withURL: URL(string: "https://api.tumblr.com/v2/blog/humansofnewyork.tumblr.com/avatar")!)
            profilePic.clipsToBounds = true
            profilePic.layer.cornerRadius = 7;
            
            if let pastDate = (instagramPost.createdAt){
                timestampLabel.text = pastDate.timeAgoDisplay()
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    @IBAction func tapLove(_ sender: Any) {
        print("like")
        if favOn == false {
            let image = UIImage(named: "favor-icon-red")
            heartBtn.setImage(image, for: UIControlState.normal)
            numOfLikes += 1
            favoriteCount.text = String(numOfLikes)
            favOn = true;
        } else{
                let image = UIImage(named: "favor-icon")
                heartBtn.setImage(image, for: UIControlState.normal)
                numOfLikes -= 1
                favoriteCount.text = String(numOfLikes)
                favOn = false;
        }
    }
    

    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
