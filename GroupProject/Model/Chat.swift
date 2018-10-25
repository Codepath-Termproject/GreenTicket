//
//  Chat.swift
//  GroupProject
//
//  Created by SiuChun Kung on 10/24/18.
//  Copyright © 2018 SiuChun Kung. All rights reserved.
//

import UIKit
import Parse

class Chat: PFObject,  PFSubclassing {
    static func parseClassName() -> String {
        return "Chat"
    }
    
    @NSManaged var Seller: PFUser
    @NSManaged var Buyer: PFUser
    @NSManaged var caption: String?
    
    class func PostChat(seller: PFUser!, withCaption caption: String?, withCompletion completion: PFBooleanResultBlock?) {
        // use subclass approach
        let post = Chat()
        
        post.Seller = seller
        post.Buyer = PFUser.current()! // Pointer column type that points to PFUser
        post.caption = caption!
        // Save object (following function will save the object in Parse asynchronously)
        post.saveInBackground(block: completion)
    }

    
}

