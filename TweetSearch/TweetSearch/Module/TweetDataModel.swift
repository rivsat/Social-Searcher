//
//  TweetDataModel.swift
//  TweetSearch
//
//  Created by Tasvir H Rohila on 08/12/16.
//  Copyright © 2016 Tasvir H Rohila. All rights reserved.
//

import Foundation


struct User {
    let idStr: String
    let name: String
    let screenName: String
    let profileImageUrl: String
    var profileImageData: Data?
    
    init?(withJSON json:[String: AnyObject]) {
        guard let _idStr = json["id_str"] as? String,
                  let _name = json["name"] as? String,
                  let _screenName = json["screen_name"] as? String,
                  let _profileImageUrl = json["profile_image_url"] as? String
             else {
                return nil
        }
        idStr           = _idStr
        name            = _name
        screenName      = _screenName
        profileImageUrl = _profileImageUrl
    }
}

struct Tweet {
    let idStr: String
    let createdAt: String
    let text: String
    var user: User
    
    init?(withJSON json:[String: AnyObject]) {
        guard let _idStr = json["id_str"] as? String,
            let _createdAt = json["created_at"] as? String,
            let _text = json["text"] as? String,
            let _user = User(withJSON: json["user"] as! [String : AnyObject])
        else {
                return nil
        }
        idStr       = _idStr
        createdAt = _createdAt
        text = _text
        user = _user
    }
}
