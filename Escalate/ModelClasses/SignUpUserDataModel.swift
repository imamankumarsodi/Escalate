//
//  SignupModel.swift
//  Claas
//
//  Created by DSP on 17/01/18.
//  Copyright © 2018 Mobulous. All rights reserved.


import Foundation
import SwiftyJSON

class SignUpUserDataModel {
    
    
    
    
    
    var fullname: String?
    var phone: String?
    var username: String?
    var image: String?
    //var is_admin: String?
    var bio: String?
    //var admin_status: String?
    var token:String?
    var user_id:String?
    var email:String?
    
    var firebase_id:String?
    
    var notification_flag:String?
    

 
    
    
    
    
    init(json: JSON) {
        
        
        
        fullname = json["fullname"].string
        
        phone = json["phone"].string
        
        username = json["username"].string
        
        
        
        image = json["image"].string
        
        //is_admin = json["is_admin"].string
        
        bio = json["bio"].string
        
        //admin_status = json["admin_status"].string
        
        token = json["token"].string
        
        
        user_id = json["user_id"].string
        
        email = json["email"].string
        
        firebase_id = json["firebase_id"].string
        
        notification_flag = json["firebase_id"].string
        
        
        
        
    }
}

