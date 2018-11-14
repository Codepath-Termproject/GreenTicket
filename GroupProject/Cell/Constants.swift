//
//  Constants.swift
//  Chat
//
//  Created by SiuChun Kung on 11/7/18.
//  Copyright © 2018 SiuChun Kung. All rights reserved.


import Foundation
import Firebase


struct Constants
{

    struct refs
    {
        static let databaseRoot = Database.database().reference()
        static let databaseChats = databaseRoot.child("chats")
    }
}
