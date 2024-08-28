//
//  SavedPostsDataModel.swift
//  Escalate
//
//  Created by abc on 08/08/18.
//  Copyright © 2018 call soft. All rights reserved.
//

import Foundation
import SwiftyJSON

class SavedPostsDataModel{
    var user_id: String?
    var user_image: String?
    var fullname: String?
    var username: String?
    var audio_url: String?
    var otherurl: String?
    var description: String?
    var topic_name: String?
    var duration: String?
    var post_id: String?
    var like_flag: String?
    var like_count: String?
    var reply_count: String?
    var tag_list: String?
    init(user_id:String,user_image:String,fullname:String,username:String,audio_url:String,description:String,topic_name:String,duration:String,post_id:String,like_flag:String,like_count:String,reply_count:String,tag_list:String,otherurl:String) {
        self.user_id = user_id
        self.user_image = user_image
        self.fullname = fullname
        self.username = username
        self.audio_url = audio_url
        self.otherurl = otherurl
        self.description = description
        self.topic_name = topic_name
        self.duration = duration
        self.post_id = post_id
        self.like_flag = like_flag
        self.like_count = like_count
        self.reply_count = reply_count
        self.tag_list = tag_list
        
    }
}
