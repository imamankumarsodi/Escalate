//
//  PeopleSearchDataModel.swift
//  Escalate
//
//  Created by abc on 30/08/18.
//  Copyright © 2018 call soft. All rights reserved.
//


import Foundation
import SwiftyJSON

class PeopleSearchDataModel{
//    "user_image": "http://mobulous.app/escalate/public/users-photos/90ed887c4bd7915.jpg",
//    "user_name": "ambalika",
//    "fullname": "ambalika ghosh",
//    "number_of_post": "2",
//    "topic_match": "2",
//    "follower_flag": "0"
    
    
    
    var user_id: String?
    var user_image: String?
    var fullname: String?
    var user_name: String?
    var topic_match: String?
    var follower_flag: String?
    var number_of_post: String?
    
    init(user_id:String,user_image:String,fullname:String,user_name:String,topic_match:String,follower_flag:String,number_of_post:String){
        
        self.user_id = user_id
        self.user_image = user_image
        self.fullname = fullname
        self.topic_match = topic_match
        self.follower_flag = follower_flag
        self.user_name = user_name
        self.number_of_post = number_of_post
        
    }
}
