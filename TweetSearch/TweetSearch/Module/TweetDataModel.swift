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

/*
 "search_metadata": {
 "completed_in": 0.055,
 "max_id": 806764287205064705,
 "max_id_str": "806764287205064705",
 "query": "rivsat",
 "refresh_url": "?since_id=806764287205064705&q=rivsat&include_entities=1",
 "count": 15,
 "since_id": 0,
 "since_id_str": "0"
 }

 */
struct TweetMetaData {
    let completedIn: Double
    let maxIdStr: String
    let query: String
    let nextResultUrl: String
    let refreshUrl: String
    let sinceIdStr: String
    
    init?(withJSON json: [String: AnyObject]) {
            guard let _completedIn = json["completed_in"] as? Double,
                let _maxIdStr = json["max_id_str"] as? String,
                let _query = json["query"] as? String,
                let _nextResultUrl = json["next_results"] as? String,
                let _refreshUrl = json["refresh_url"] as? String,
                let _sinceIdStr = json["since_id_str"] as? String
                else {
                    return nil
            }
        completedIn = _completedIn
        maxIdStr = _maxIdStr
        query = _query
        nextResultUrl = _nextResultUrl
        refreshUrl = _refreshUrl
        sinceIdStr = _sinceIdStr
    }
}
