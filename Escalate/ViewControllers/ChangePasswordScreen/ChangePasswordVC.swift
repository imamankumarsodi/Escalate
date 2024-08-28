//
//  ChangePasswordVC.swift
//  Escalate
//
//  Created by call soft on 20/07/18.
//  Copyright © 2018 call soft. All rights reserved.
//

import UIKit

class ChangePasswordVC: UIViewController {
    
    
    //MARK:- OUTLETS
    //MARK:
    
    
    @IBOutlet weak var txtFeildOldPassword: UITextField!
    
    
    @IBOutlet weak var txtFeildPassword: UITextField!
    
    
    
    @IBOutlet weak var txtFeildConfirmPassword: UITextField!
    
    
    //MARK:- VARIABLES
    //MARK:
    
    let WebserviceConnection  = AlmofireWrapper()
    
    let validation:Validation = Validation.validationManager() as! Validation

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
//    override var prefersStatusBarHidden: Bool {
//        return true
//    }
//    
    
    
    
    //MARK:- METHODS
    //MARK:-
    
    
    
    
    func changePasswordAPI() {
        
        
        let infoArray = UserDefaults.standard.value(forKey: "USERINFO") as? NSArray ?? []
        print(infoArray)
        let infoDict = infoArray.object(at: 0) as? NSDictionary ?? [:]
        
        print(infoDict)
        
        let user_id = infoDict.value(forKey: "user_id") as? String ?? ""
        
        print(user_id)
        
        let token = infoDict.value(forKey: "token") as? String ?? ""
        
        let passDict = ["password_old":txtFeildOldPassword.text!,
                        "password":txtFeildPassword.text!,
                        "password_confirmation":txtFeildConfirmPassword.text!,
                        "token":token] as! [String : AnyObject]
        
        print(passDict)
        
        if InternetConnection.internetshared.isConnectedToNetwork() {
            
            Indicator.shared.showProgressView(self.view)
            
            WebserviceConnection.requestPOSTURL("users_change_password/\(user_id)", params: passDict as [String : AnyObject], headers:nil, success: { (responseJson) in
                
                if responseJson["status"].stringValue == "SUCCESS" {
                    
                    Indicator.shared.hideProgressView()
                    
                    print(responseJson["status"])
                    print(responseJson)

                    
                _ = SweetAlert().showAlert("Escalate", subTitle: "Password changed successfully", style: AlertStyle.success)
                   self.navigationController?.popViewController(animated: true)
                    
                    
                    
                    
                }else{
                    
                    print(responseJson)
                    Indicator.shared.hideProgressView()
                    
                    print("WOW Failure")
                    
                    let message  = responseJson["message"].stringValue as? String ?? ""
                    
                    _ = SweetAlert().showAlert("Escalate", subTitle: message, style: AlertStyle.error)
                    
                    if message == "Login Token Expire"{
                        
                        self.navigationController?.popToRootViewController(animated: true)
                    }else{
                        
                        print("do Nothing")
                    }
                    
                    
                }
                
                
            },failure: { (Error) in
                Indicator.shared.hideProgressView()
                _ = SweetAlert().showAlert("Escalate", subTitle: "Something went wrong.Please try again!", style: AlertStyle.error)
                self.dismiss(animated: true, completion: nil)
                
                
            })
            
            
        }else{
            
            _ = SweetAlert().showAlert("Escalate", subTitle: "No interter connection!", style: AlertStyle.error)
            
            
        }
        
        
        
    }
    
    
    
    func checkConfirmPasswordForLettersAndNumber()->Bool{
        
        
        let phrase = txtFeildConfirmPassword.text!
        
        
        
        let letters = CharacterSet.letters
        let digits = CharacterSet.decimalDigits
        
        var letterCount = 0
        var digitCount = 0
        
        for uni in phrase.unicodeScalars {
            if letters.contains(uni) {
                letterCount += 1
            } else if digits.contains(uni) {
                digitCount += 1
            }
        }
        
        if letterCount >= 1 && digitCount >= 1{
            return true
        }
        else{
            return false
        }
        
    }
    
    func checkPasswordForLettersAndNumber()->Bool{
        
        
        let phrase = txtFeildPassword.text!
        
        
        
        let letters = CharacterSet.letters
        let digits = CharacterSet.decimalDigits
        
        var letterCount = 0
        var digitCount = 0
        
        for uni in phrase.unicodeScalars {
            if letters.contains(uni) {
                letterCount += 1
            } else if digits.contains(uni) {
                digitCount += 1
            }
        }
        
        if letterCount >= 1 && digitCount >= 1{
            return true
        }
        else{
            return false
        }
        
    }
    
    
    func validationSetup()->Void{
        
        
        
        var message = ""
        
        
        if !validation.validateBlankField(txtFeildOldPassword.text!){
            message = "Please enter old Password"
        }
        
        else if !validation.validateBlankField(txtFeildPassword.text!){
            message = "Please enter new Password"
        }
            
        else if checkPasswordForLettersAndNumber() == false {
            message = "Please enter valid Password (Password contains atleast 1 characters and 1 digits)"
        }

        else if checkConfirmPasswordForLettersAndNumber() == false {
            message = "Please enter valid confirm Password (Password contains atleast 1 characters and 1 digits)"
        }
            
            
            
        else if (txtFeildPassword.text!.characters.count < 7 ){
            message = "Password length must be 7 atleast characters"
        }
            
        else if !validation.validateBlankField(txtFeildConfirmPassword.text!){
            message = "Please re-enter your Password"
        }
            
        else if (txtFeildConfirmPassword.text!.characters.count < 7){
            message = "Confirm Password must be 7 atleast characters"
        }
            
        else if txtFeildPassword.text! != txtFeildConfirmPassword.text!{
            
            message = "Password and Confirm Password must be the same"
            
        }
        
        
        if message != "" {
            
            
            _ = SweetAlert().showAlert("Escalate", subTitle: message, style: AlertStyle.error)
            
        }else{
            
            changePasswordAPI()
            
        }
        
        
    }

    
    //MARK:- ACTIONS
    //MARK:
    
    @IBAction func btnBackTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnSaveTapped(_ sender: Any) {
        
        
        validationSetup()
//        self.navigationController?.popViewController(animated: true)
    }
    

}
