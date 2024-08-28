//
//  CategoriesModel.swift
//  Escalate
//
//  Created by abc on 04/08/18.
//  Copyright © 2018 call soft. All rights reserved.
//

import Foundation
import SwiftyJSON
class CategoriesModel {
    

    var name: String?
    var topic_id: String?
    var isSelected: Bool?
    var icon: String?
    
    
    
    
    init(name:String,topic_id:String,isSelected:Bool,icon:String) {
        
        
        
        self.name = name
        
        self.topic_id = topic_id
        
        self.isSelected = isSelected
        
        self.icon = icon
        
        
    }
}

