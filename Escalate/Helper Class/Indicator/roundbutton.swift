//
//  roundbutton.swift
//  userFlow
//
//  Created by call soft on 03/07/18.
//  Copyright © 2018 call soft. All rights reserved.
//

import UIKit

class roundbutton: NSObject {

    func roundBtn(view:AnyObject,radius:CGFloat,borderWidth:CGFloat,borderColor:CGColor) -> AnyObject {
        
        let view1 = view as! UIView
        view1.layer.cornerRadius = radius
        view1.layer.borderWidth = borderWidth
        view1.layer.borderColor = borderColor
        
        return view1 as AnyObject
        
    }
    
}
