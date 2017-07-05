//
//  User.swift
//  twitter_alamofire_demo
//
//  Created by Charles Hieger on 6/17/17.
//  Copyright © 2017 Charles Hieger. All rights reserved.
//

import Foundation


class User {
    
    var name: String
    var screenName: String
    static var current: User?
    var profileImageURLString : String
    var profileImageURL: URL
    
    
    init(dictionary: [String: Any]) {
        name = dictionary["name"] as! String
        screenName = dictionary["screen_name"] as! String
        profileImageURLString = dictionary["profile_image_url"] as! String
        profileImageURL = URL(string: profileImageURLString)!
    }
}
