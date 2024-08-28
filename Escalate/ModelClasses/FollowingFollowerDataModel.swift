//
//  FollowingFollowerDataModel.swift
//  Escalate
//
//  Created by abc on 10/08/18.
//  Copyright © 2018 call soft. All rights reserved.
//

import Foundation
import SwiftyJSON

class FollowingFollowerDataModel{
//    "user_id": "2",
//    "user_image": "http://mobulous.app/escalate/public/users-photos/90ed887c4bd7915.jpg",
//    "fullname": "ambalika ghosh",
//    "username": "ambalika",
//    "bio": "http://mobulous.app/escalate/public/user_bio/61e0a346b842d24.mp3",
//    "follower_flag": "0"
    
    
    
    var user_id: String?
    var user_image: String?
    var fullname: String?
    var username: String?
    var bio: String?
    var follower_flag: String?
    
    init(user_id:String,user_image:String,fullname:String,username:String,bio:String,follower_flag:String){
        
        self.user_id = user_id
        self.user_image = user_image
        self.fullname = fullname
        self.bio = bio
        self.follower_flag = follower_flag
        
    }
}
