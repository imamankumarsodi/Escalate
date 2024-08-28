//
//  ChangePasswordAfterOTPVC.swift
//  Escalate
//
//  Created by abc on 27/07/18.
//  Copyright © 2018 call soft. All rights reserved.
//

import UIKit


class ChangePasswordAfterOTPVC: UIViewController {
    
    
    //MARK:- OUTLETS
    //MARK:-
    
    
    @IBOutlet weak var txtFeildPassword: UITextField!
    
    @IBOutlet weak var txtFeildConfirmPassword: UITextField!
    
    //MARK:- VARIABLES
    //MARK:
    
   var contoller =  UIViewController()
    
    var controllerInstance2 =  UIViewController()
    
    let WebserviceConnection  = AlmofireWrapper()
    var btnPasswordState = false
    var btnConfirmPasswordState = false
    
    let validation:Validation = Validation.validationManager() as! Validation
    
    var userID = ""
    
    
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
        
        
       if !validation.validateBlankField(txtFeildPassword.text!){
            message = "Please enter Password"
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
            
            changePasswordApi()
            
        }
        
        
    }
    
    
    
    func changePasswordApi() {
        
        
        userID = UserDefaults.standard.value(forKey: "USERID") as? String ?? ""
        
        
        let passDict = ["user_id":userID,
                        "password":txtFeildPassword.text!,
                        "password_confirmation":txtFeildConfirmPassword.text!] as [String : AnyObject]
        
        print(passDict)
        
        if InternetConnection.internetshared.isConnectedToNetwork() {
            
            Indicator.shared.showProgressView(self.view)
            
            WebserviceConnection.requestPOSTURL("setnewpass", params: passDict as [String : AnyObject], headers:nil, success: { (responseJson) in
                
                if responseJson["status"].stringValue == "SUCCESS" {
                    
                    Indicator.shared.hideProgressView()
                    
                    print(responseJson["status"])
                    print(responseJson)
                    
                    _ = SweetAlert().showAlert("Escalate", subTitle: "Password changed successfully", style: AlertStyle.success)
                    
                    weak var pvc1 = self.presentingViewController
                    self.dismiss(animated: true, completion: {
                        
                        
                        
                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "LogInVC") as! LogInVC
                        let navigation = UINavigationController(rootViewController: vc)
                        navigation.isNavigationBarHidden = true
                        vc.controllerInstance3 =  self.contoller
                        pvc1?.present(navigation, animated: true, completion: nil)
                        
                        UserDefaults.standard.removeObject(forKey: "USERID")
                        
                    })
                    
                    
                    
                    
                    
                }else{
                    
                    Indicator.shared.hideProgressView()
                    
                    _ = SweetAlert().showAlert("Escalate", subTitle: "You are not a registered user.", style: AlertStyle.error)
                    
                    
                    
                    
                    
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
    
    
    
    //MARK:- ACTIONS
    //MARK:
    
    @IBAction func btnBackTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
        
       
    }
    
    @IBAction func btnSaveTapped(_ sender: Any) {
        
       validationSetup()
        
    }
    
    
}
