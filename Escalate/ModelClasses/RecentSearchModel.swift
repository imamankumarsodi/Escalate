//
//  RecentSearchModel.swift
//  Escalate
//
//  Created by abc on 09/10/18.
//  Copyright © 2018 call soft. All rights reserved.
//

import Foundation
import RealmSwift
class RecentSearchModel: Object{
    @objc dynamic var type = String()
    @objc dynamic var search_name = String()
    @objc dynamic var follower_flag = String()
    @objc dynamic var fullname = String()
    @objc dynamic var number_of_post = String()
    @objc dynamic var topic_match = String()
    @objc dynamic var user_id = String()
    @objc dynamic var user_image = String()
    @objc dynamic var user_name = String()
    @objc dynamic var tag_id = String()
    @objc dynamic var num_of_post = String()
    @objc dynamic var tag_name = String()
    @objc dynamic var icon = String()
    @objc dynamic var created = Date()
}

class RecentSearchModelFilter{
    
    //"num_of_post" = 1;
    //"tag_id" = 8;
    //"tag_name" = "#Grasssmen";
    
    
    var type: String?
    var search_name: String?
    
    var follower_flag: String?
    var fullname: String?
    var number_of_post: String?
    var topic_match: String?
    var user_id: String?
    var user_image: String?
    var user_name: String?
    
    
    var tag_id: String?
    var num_of_post: String?
    var tag_name: String?
    var icon: String?
    var created: Date?
    
    
    
    
    
    init(type:String,search_name:String,follower_flag:String,fullname:String,number_of_post:String,topic_match:String,user_id:String,user_image:String,user_name:String, tag_id:String,num_of_post:String,tag_name:String,icon:String,created:Date){
        
        
        self.type = type
        self.search_name = search_name
        self.follower_flag = follower_flag
        self.fullname = fullname
        self.number_of_post = number_of_post
        self.topic_match = topic_match
        self.user_id = user_id
        self.user_image = user_image
        self.user_name = user_name
        
        self.tag_id = tag_id
        self.num_of_post = num_of_post
        self.tag_name = tag_name
        self.icon = icon
        self.created = created
        
        
        
    }
}
