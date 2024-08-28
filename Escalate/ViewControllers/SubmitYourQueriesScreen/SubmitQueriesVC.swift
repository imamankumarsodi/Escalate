//
//  SubmitQueriesVC.swift
//  Escalate
//
//  Created by abc on 31/01/19.
//  Copyright © 2019 call soft. All rights reserved.
//

import UIKit
import RSKPlaceholderTextView

class SubmitQueriesVC: UIViewController {
    //MARK: - Quries
    
    @IBOutlet weak var txtViewQuries: RSKPlaceholderTextView!
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
    
    @IBAction func btnBackTapped(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
        
    }
    
    @IBAction func btnSubmitTapped(_ sender: UIButton) {
        validationSetup()
    }
    
    func validationSetup()->Void{
        
        
        
        var message = ""
        
        
        if !validation.validateBlankField(txtViewQuries.text!){
            message = "Please enter your query."
        }
        if message != "" {
            
            
            _ = SweetAlert().showAlert("Escalate", subTitle: message, style: AlertStyle.error)
            
        }else{
            
            submitQuriesAPI()
            
        }
        
        
    }
    
    
    
    func submitQuriesAPI() {
        
        
        let infoArray = UserDefaults.standard.value(forKey: "USERINFO") as? NSArray ?? []
        print(infoArray)
        let infoDict = infoArray.object(at: 0) as? NSDictionary ?? [:]
        
        print(infoDict)
        
        let user_id = infoDict.value(forKey: "user_id") as? String ?? ""
        
        print(user_id)
        
        let token = infoDict.value(forKey: "token") as? String ?? ""
        
        let passDict = ["msg":txtViewQuries.text!,
                        "user_id":user_id,
                        "token":token] as! [String : AnyObject]
        
        print(passDict)
        
        if InternetConnection.internetshared.isConnectedToNetwork() {
            
            Indicator.shared.showProgressView(self.view)
            
            WebserviceConnection.requestPOSTURL("submitquery", params: passDict as [String : AnyObject], headers:nil, success: { (responseJson) in
                
                if responseJson["status"].stringValue == "SUCCESS" {
                    
                    Indicator.shared.hideProgressView()
                    
                    print(responseJson["status"])
                    print(responseJson)
                    
                    
                    _ = SweetAlert().showAlert("Escalate", subTitle: "Query submitted successfully.", style: AlertStyle.success)
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
    
}
