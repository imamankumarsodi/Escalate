//
//  TermsPrivacyVC.swift
//  Escalate
//
//  Created by abc on 29/09/18.
//  Copyright © 2018 call soft. All rights reserved.
//

import UIKit

class TermsPrivacyVC: UIViewController {
    @IBOutlet weak var txtView: UITextView!
    @IBOutlet weak var lblHeader: UILabel!
    
    var apiKey = ""
    let WebserviceConnection  = AlmofireWrapper()
    var isComing = String()
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    override func viewDidLoad() {
        super.viewDidLoad()
        notificationList()
        // Do any additional setup after loading the view.
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func notificationList(){
        if InternetConnection.internetshared.isConnectedToNetwork() {
            Indicator.shared.showProgressView(self.view)
            WebserviceConnection.requestGETURL("\(apiKey)", success: { (responseJson) in
                if responseJson["status"].stringValue == "SUCCESS" {
                    Indicator.shared.hideProgressView()
                    print("SUCCESS")
                    print(responseJson)
                    if "\(self.apiKey)" == "tandccontent"{
                        self.lblHeader.text = "Terms and Conditions"
                    }else{
                        self.lblHeader.text = "Privacy Policies"
                    }
                    let dataDict = responseJson["data"].dictionaryObject as? NSDictionary ?? [:]
                    self.txtView.text = dataDict.value(forKey: "description") as? String ?? ""
                }else{
                    print(responseJson)
                    Indicator.shared.hideProgressView()
                    let message  = responseJson["message"].stringValue as? String ?? ""
                    _ = SweetAlert().showAlert("Escalate", subTitle: message, style: AlertStyle.error)
                    if message == "Login Token Expire"{
                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "LogInVC") as! LogInVC
                        self.navigationController!.pushViewController(vc, animated: true)
                    }
                }
            },failure: { (Error) in
                _ = SweetAlert().showAlert("Escalate", subTitle: "Something went wrong.Please try again!", style: AlertStyle.error)
                Indicator.shared.hideProgressView()
            })
        }else{
            _ = SweetAlert().showAlert("Escalate", subTitle: "No interter connection!", style: AlertStyle.error)
            Indicator.shared.hideProgressView()
        }
    }
    @IBAction func btnBackTapped(_ sender: Any) {
        if isComing != "SOCIAL"{
        self.navigationController?.popViewController(animated: true)
        }else{
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "LogInVC") as! LogInVC
            let navController = UINavigationController(rootViewController: vc)
            navController.navigationBar.isHidden = true
            self.appDelegate.window?.rootViewController = navController
            self.appDelegate.window?.makeKeyAndVisible()
        }
    }
}
