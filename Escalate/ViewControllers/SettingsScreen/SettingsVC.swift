//
//  SettingsVC.swift
//  Escalate
//
//  Created by call soft on 20/07/18.
//  Copyright © 2018 call soft. All rights reserved.
//

import UIKit
import Firebase

class SettingsVC: UIViewController {
    
    
    
    //MARK:- OUTLETS
    //MARK:
    
    
    @IBOutlet var tblSettings: UITableView!
    
    
    //MARK:- VARIABLES
    //MARK:
    
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    var notification_flag = ""
    
    let WebserviceConnection  = AlmofireWrapper()
    
    
//    let settingsNameArray = ["Notification","Change Password","Reported Users","Terms and Conditions","Privacy Policies","Logout"]
    
    
    let settingsNameArray = ["Notification","Change Password","Terms and Conditions","Privacy Policies","Post Queries","Logout"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tblSettings.tableFooterView = UIView()
        viewProfile()
        
        // Do any additional setup after loading the view.
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
//    override var prefersStatusBarHidden: Bool {
//        return true
//    }
    
    
    
    //MARK:- METHODS
    //MARK:
    
    
    
    func viewProfile(){
        
        
        
        let infoArray = UserDefaults.standard.value(forKey: "USERINFO") as? NSArray ?? []
        //print(infoArray)
        let infoDict = infoArray.object(at: 0) as? NSDictionary ?? [:]
        
        //print(infoDict)
        
        let user_id = infoDict.value(forKey: "user_id") as? String ?? ""
        
        //print(user_id)
        
        
        if InternetConnection.internetshared.isConnectedToNetwork() {
            
            Indicator.shared.showProgressView(self.view)
            
            
            
            WebserviceConnection.requestGETURL("userdetail/\(user_id)/\(user_id)", success: { (responseJson) in
                
                if responseJson["status"].stringValue == "SUCCESS" {
                    
                    Indicator.shared.hideProgressView()
                    
                    print("SUCCESS")
                    
                    print(responseJson)
                    
                    let userDict = responseJson["data"].dictionaryObject ?? [:]
                    
                    self.notification_flag = userDict["notification_flag"] as? String ?? ""
                    
                    self.tblSettings.dataSource = self
                    self.tblSettings.delegate = self
                    self.tblSettings.reloadData()
                    
                    
                }else{
                    
                    print(responseJson)
                    
                    Indicator.shared.hideProgressView()
                    self.tblSettings.tableFooterView = UIView()
                    
                    let message  = responseJson["message"].stringValue as? String ?? ""
                    
                    _ = SweetAlert().showAlert("Escalate", subTitle: message, style: AlertStyle.error)
                    
                    if message == "Login Token Expire"{
                        
                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "LogInVC") as! LogInVC
                        
                        self.navigationController!.pushViewController(vc, animated: true)
                    }else{
                        
                        print("do Nothing")
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
    
    
    
    
    
    
    
    func notificationOff(){
        
        
        
        let infoArray = UserDefaults.standard.value(forKey: "USERINFO") as? NSArray ?? []
        //print(infoArray)
        let infoDict = infoArray.object(at: 0) as? NSDictionary ?? [:]
        
        //print(infoDict)
        
        let user_id = infoDict.value(forKey: "user_id") as? String ?? ""
        
        //print(user_id)
        
        
        if InternetConnection.internetshared.isConnectedToNetwork() {
            
            Indicator.shared.showProgressView(self.view)
            
            
            
            WebserviceConnection.requestGETURL("notificationtrigger/\(user_id)", success: { (responseJson) in
                
                if responseJson["status"].stringValue == "SUCCESS" {
                    
                    Indicator.shared.hideProgressView()
                    
                    print("SUCCESS")
                    
                    print(responseJson)
                    
        
                    
                 
                    
                    
                }else{
                    
                    print(responseJson)
                    
                    Indicator.shared.hideProgressView()
                    
                    let message  = responseJson["message"].stringValue as? String ?? ""
                    
                    _ = SweetAlert().showAlert("Escalate", subTitle: message, style: AlertStyle.error)
                    
                    if message == "Login Token Expire"{
                        
                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "LogInVC") as! LogInVC
                        
                        self.navigationController!.pushViewController(vc, animated: true)
                    }else{
                        
                        print("do Nothing")
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
    
    
    
    
    
    
    
    func handleFirebaseLoggedOut(){
        UserDefaults.standard.removeObject(forKey: "token")
        UserDefaults.standard.removeObject(forKey: "USERINFO")
        UserDefaults.standard.set(false, forKey: "isLoginSuccessfully")
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "LogInVC") as! LogInVC
        let navController = UINavigationController(rootViewController: vc)
        navController.navigationBar.isHidden = true
        self.appDelegate.window?.rootViewController = navController
        self.appDelegate.window?.makeKeyAndVisible()
    }
    
    
    //MARK:- ACTIONS
    //MARK:
    
    @IBAction func btnBackTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
   
    
     @objc func switchNotificationTappd(_ sender: UISwitch) {
        
        if sender.isOn == false{
            notificationOff()
        }else{
            notificationOff()
        }
        
    }
    
    
}


//MARK:- EXTENTION TABLE VIEW
//MARK:

extension SettingsVC:UITableViewDelegate,UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settingsNameArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        tblSettings.register(UINib(nibName: "SettingsTableViewCell", bundle: nil), forCellReuseIdentifier: "SettingsTableViewCell")
        
        let cell = tblSettings.dequeueReusableCell(withIdentifier: "SettingsTableViewCell", for: indexPath) as! SettingsTableViewCell
        cell.lblSettingsName.text = settingsNameArray[indexPath.row]
        if indexPath.row == 0{
            cell.switchNotifications.isHidden = false
            cell.btnSettingsTapped.isHidden = true
            
            if self.notification_flag == "0"{



                cell.switchNotifications.setOn(false, animated:true)

            }else{

                cell.switchNotifications.setOn(true, animated:true)

            }
            
            
            cell.switchNotifications.tag = indexPath.row
            cell.switchNotifications.addTarget(self, action: #selector(switchNotificationTappd), for: .touchUpInside)
            
            
            
            cell.btnSettingsTapped.transform = CGAffineTransform(scaleX: 0.20, y: 0.20)

        
        }
        else if indexPath.row == 5{
            cell.btnSettingsTapped.setImage(#imageLiteral(resourceName: "setting_logout"), for: .normal)
        }
        else{
            cell.btnSettingsTapped.setImage(#imageLiteral(resourceName: "setting_arrow_forward"), for: .normal)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row == 1{
            UserDefaults.standard.removeObject(forKey: "token")
            
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "ChangePasswordVC") as! ChangePasswordVC
            self.navigationController?.pushViewController(vc, animated: true)
        }
            
        else if indexPath.row == 2{
            
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "TermsPrivacyVC") as! TermsPrivacyVC
            
            vc.apiKey = "tandccontent"
            
            self.navigationController?.pushViewController(vc, animated: true)
            
        }
            
        else if indexPath.row == 3{
            
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "TermsPrivacyVC") as! TermsPrivacyVC
            
            vc.apiKey = "privacypolicycontent"
            
            self.navigationController?.pushViewController(vc, animated: true)
            
        }
        
            
        else if indexPath.row == 4{
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "SubmitQueriesVC") as! SubmitQueriesVC
            self.navigationController?.pushViewController(vc, animated: true)
        }else{
            
            
            _ = SweetAlert().showAlert("Escalate", subTitle: "Are you sure?\nYou want to logout!", style: AlertStyle.warning, buttonTitle:"Cancel", buttonColor:UIColor.colorFromRGB(0xD0D0D0) , otherButtonTitle:  "OK", otherButtonColor: UIColor.colorFromRGB(0xDD6B55)) { (isOtherButton) -> Void in
                if isOtherButton == true {
                    
                    print("Cancel Button  Pressed", terminator: "")
                }
                else
                {
                    
                    self.handleFirebaseLoggedOut()
                    
                    
                }
                
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableViewAutomaticDimension
        
    }
    
}

