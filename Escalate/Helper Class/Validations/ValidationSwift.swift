//
//  ValidationSwift.swift
//  Escalate
//
//  Created by call soft on 24/07/18.
//  Copyright © 2018 call soft. All rights reserved.
//

import Foundation

class ValidationSwift{
    
    
    static let sharedValidationSwiftInstance = ValidationSwift()
    
    
    func isValidPassword(testStr:String?) -> Bool {
        //guard testStr != nil else { return false }
        
        // at least one uppercase,
        // at least one digit
        // at least one lowercase
        // 8 characters total
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", "^(?:(?:(?=.*?[0-9])(?=.*?[-!@#$%&*ˆ+=_])|(?:(?=.*?[0-9])|(?=.*?[A-Z])|(?=.*?[-!@#$%&*ˆ+=_])))|(?=.*?[a-z])(?=.*?[0-9])(?=.*?[-!@#$%&*ˆ+=_]))[A-Za-z0-9-!@#$%&*ˆ+=_]{6,15}$")
        return passwordTest.evaluate(with: testStr)
    }
}
