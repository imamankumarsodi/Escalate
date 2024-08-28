//
//  TagDataModel.swift
//  Escalate
//
//  Created by abc on 31/08/18.
//  Copyright © 2018 call soft. All rights reserved.
//

import Foundation
class TagDataModel{

    var tag_id: String?
    var num_of_post: String?
    var tag_name: String?
    var icon: String?
    
    
    init(tag_id:String,num_of_post:String,tag_name:String,icon:String){
        
        self.tag_id = tag_id
        self.num_of_post = num_of_post
        self.tag_name = tag_name
        self.icon = icon
        
        
    }
}
