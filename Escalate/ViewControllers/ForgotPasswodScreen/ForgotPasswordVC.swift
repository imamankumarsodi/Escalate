//
//  ForgotPasswordVC.swift
//  Escalate
//
//  Created by call soft on 20/07/18.
//  Copyright © 2018 call soft. All rights reserved.
//

import UIKit
import FirebaseAuth

class ForgotPasswordVC: UIViewController {
    
    
    
    //MARK:- OUTLETS
    //MARK:
    
    @IBOutlet var lblEmail: UILabel!
    
   
    @IBOutlet var viewLineEmail: UIView!
    
    
    @IBOutlet var lblPhone: UILabel!
    
    
    @IBOutlet var viewLinePhone: UIView!
    
    @IBOutlet var imgForgotPassword: UIImageView!
    
    @IBOutlet var txtFeildForgotPassword: UITextField!
    
    
    
    //MARK:- VARIABLES
    //MARK:
    
    var tag = Int()
    
    var arrayFromPlist:NSMutableArray = NSMutableArray()
    
     let validation:Validation = Validation.validationManager() as! Validation
    
      let WebserviceConnection  = AlmofireWrapper()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
    
    func validationSetup()->Void{
        
        
        
        var message = ""
        
        //var tempString = txtFeildMail.text ?? ""
    
            
        if !validation.validateBlankField(txtFeildForgotPassword.text!){
            message = "Please enter Email ID"
            
        }else if !validation.validateEmail(txtFeildForgotPassword.text!){
            
            message = "Please enter valid Email ID"
        }
            
       
        
        if message != "" {
            
            
            _ = SweetAlert().showAlert("Escalate", subTitle: message, style: AlertStyle.error)
            
        }else{
            
            self.getOTPEmail()
            
        }
        
        
    }
    
    
    
    
    //TODO:-WEBSERVICES
    
    
    
    func getOTPEmail() {
        
        
        
        let passDict = ["email":txtFeildForgotPassword.text!] as [String : AnyObject]
        
        print(passDict)
        
        if InternetConnection.internetshared.isConnectedToNetwork() {
            
            Indicator.shared.showProgressView(self.view)
            
            WebserviceConnection.requestPOSTURL("forgotPassword", params: passDict as [String : AnyObject], headers:nil, success: { (responseJson) in
                
                if responseJson["status"].stringValue == "SUCCESS" {
                    
                    Indicator.shared.hideProgressView()
                    
                    print(responseJson["status"])
                    print(responseJson)
                    
                    
                    
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "VarificationVC") as! VarificationVC
                    
                    vc.emailString = self.txtFeildForgotPassword.text!
                    
                    vc.isComing = "FORGOTPASSWORDEMAIL"
                    
                    self.present(vc, animated: true, completion: nil)
                    
                    
                    
                    
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
    
    
    
    
    
//    func checkUser() {
//        
//        
//        
//        let passDict = ["phone":"",
//            "email":txtFeildForgotPassword.text!,
//            "username":""] as [String : AnyObject]
//        
//        print(passDict)
//        
//        if InternetConnection.internetshared.isConnectedToNetwork() {
//            
//            Indicator.shared.showProgressView(self.view)
//            
//            WebserviceConnection.requestPOSTURL("check_back", params: passDict as [String : AnyObject], headers:nil, success: { (responseJson) in
//                
//                if responseJson["status"].stringValue == "FAILURE" {
//                    
//                    Indicator.shared.hideProgressView()
//                    
//                    print(responseJson["status"])
//                    print(responseJson)
//                    
//
//                    
//                    
//                    
//                    
//
//                    
//                    
//                    
//                    
//                }else{
//                    
//                    Indicator.shared.hideProgressView()
//                   
//                    
//                     _ = SweetAlert().showAlert("Escalate", subTitle: "You are not a registered user.", style: AlertStyle.error)
//                    
//                  
//                   
//                    
//                    
//                }
//                
//                
//            },failure: { (Error) in
//                Indicator.shared.hideProgressView()
//                _ = SweetAlert().showAlert("Escalate", subTitle: "Something went wrong.Please try again!", style: AlertStyle.error)
//                self.dismiss(animated: true, completion: nil)
//                
//                
//            })
//            
//            
//        }else{
//            
//            _ = SweetAlert().showAlert("Escalate", subTitle: "No interter connection!", style: AlertStyle.error)
//            
//            
//        }
//        
//        
//        
//    }
    
 
    
    //MARK:- ACTIONS
    //MARK:
    
    @IBAction func btnNavigationTapped(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "LogInVC") as! LogInVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    
    @IBAction func btnEmailOrPhoneChoice(_ sender: UIButton) {
        
        tag = sender.tag
        
        if tag == 1{
            
            //DO NOTHING
  
        }
        else if tag == 2{
            
            
            
            
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "ForgotPasswordPhoneVC") as! ForgotPasswordPhoneVC
            
            self.navigationController?.pushViewController(vc, animated: false)
  
        }
    }
    
    
    @IBAction func btnForgotPasswordTapped(_ sender: UIButton) {
        
            validationSetup()
    }

}


