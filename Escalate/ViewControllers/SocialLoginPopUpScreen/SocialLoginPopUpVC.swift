//
//  SocialLoginPopUpVC.swift
//  Escalate
//
//  Created by abc on 10/01/19.
//  Copyright © 2019 call soft. All rights reserved.
//

import UIKit

class SocialLoginPopUpVC: UIViewController {
    
    //MARK: - Outlets
    @IBOutlet weak var imgViewTermsAndCondion: UIImageView!
    @IBOutlet weak var imgViewNotification: UIImageView!
    @IBOutlet weak var lbl_TermConditions: UILabel!
    //MARK: - Variables
    var firebase_id = ""
    var acceptTermsAndConditionState = false
    var notificationState = false
    let WebserviceConnection  = AlmofireWrapper()
    var userDataArray :NSMutableArray =  NSMutableArray()
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
        // Do any additional setup after loading the view.
    }

    //MARK: - Actions
    
    @IBAction func btnTermsAndConditionTapped(_ sender: UIButton) {
        if sender.tag == 1{
            acceptTermsAndConditionState = !acceptTermsAndConditionState
            imgViewTermsAndCondion.image = acceptTermsAndConditionState ? #imageLiteral(resourceName: "login_tick_slected") : #imageLiteral(resourceName: "login_tick_un") ;
            
            
        }else if sender.tag == 2{
            notificationState = !notificationState
            imgViewNotification.image = notificationState ? #imageLiteral(resourceName: "login_tick_slected") : #imageLiteral(resourceName: "login_tick_un") ;
            
        }
    
}
    
    @IBAction func btnTermsAndPrivacyTapped(_ sender: UIButton) {
        if sender.tag == 1{
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "TermsPrivacyVC") as! TermsPrivacyVC
            vc.apiKey = "tandccontent"
            vc.isComing = "SOCIAL"
            let navController = UINavigationController(rootViewController: vc)
            navController.navigationBar.isHidden = true
            self.appDelegate.window?.rootViewController = navController
            self.appDelegate.window?.makeKeyAndVisible()
        }else{
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "TermsPrivacyVC") as! TermsPrivacyVC
            vc.apiKey = "privacypolicycontent"
            vc.isComing = "SOCIAL"
            let navController = UINavigationController(rootViewController: vc)
            navController.navigationBar.isHidden = true
            self.appDelegate.window?.rootViewController = navController
            self.appDelegate.window?.makeKeyAndVisible()
        }
        
    }
    @IBAction func btnBackTapped(_ sender: UIButton) {
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func btnAcceptTapped(_ sender: UIButton) {
        validationSetup()
    }
}

//MARK: - Extension methods
extension SocialLoginPopUpVC{
    func validationSetup()->Void{
        var message = String()
        if acceptTermsAndConditionState == false{
            message = "Please accept terms and conditions"
        }
        if message != "" {
            _ = SweetAlert().showAlert("Escalate", subTitle: message, style: AlertStyle.error)
        }else{
            
           signUserAPI()
        }
    }
    func initialSetup(){
        let normalText1  = "Tick this box if you are over the age of 16 and agree to Escalate's "
        let underLineText1 = "Terms and Condtions"
        let normalText2 = " of service and "
        let underLineText2 = "Privacy Policy."
        let myMutableString1 = NSMutableAttributedString()
        let myMutableString2 = NSAttributedString(string: "\(normalText1) ", attributes:[.font:UIFont(name: App.Fonts.SegoeUI.Regular, size: 13.0)!, .foregroundColor :UIColor.lightGray])
        let myMutableString3 = NSAttributedString(string: "\(underLineText1) ", attributes:[.font:UIFont(name: App.Fonts.SegoeUI.Regular, size: 13.0)!, .foregroundColor :UIColor(red: 76/255, green: 40/255, blue: 107/255, alpha: 1.0), .underlineStyle: NSUnderlineStyle.styleSingle.rawValue])
        
        let myMutableString4 = NSAttributedString(string: "\(normalText2) ", attributes:[.font:UIFont(name: App.Fonts.SegoeUI.Regular, size: 13.0)!, .foregroundColor :UIColor.lightGray] )
        let myMutableString5 = NSAttributedString(string: "\(underLineText2) ", attributes:[.font:UIFont(name: App.Fonts.SegoeUI.Regular, size: 13.0)!, .foregroundColor :UIColor(red: 76/255, green: 40/255, blue: 107/255, alpha: 1.0),.underlineStyle: NSUnderlineStyle.styleSingle.rawValue])
        
        
        myMutableString1.append(myMutableString2)
        myMutableString1.append(myMutableString3)
        myMutableString1.append(myMutableString4)
        myMutableString1.append(myMutableString5)
        lbl_TermConditions.attributedText = myMutableString1
    }
}

//MARK: - Web services extension
extension SocialLoginPopUpVC{
    func signUserAPI() {
        if UserDefaults.standard.value(forKey: "imageData") != nil {
            let devicetoken = UserDefaults.standard.value(forKey: "devicetoken") as? String ?? "bb55d44bfc4492bd33aac79afeaee474e92c12138e18b021e2326"
            let temPassdict  = UserDefaults.standard.value(forKey: "PASSDICT")
            let imagedata  =  UserDefaults.standard.value(forKey: "imageData") as! NSData
            let socialDict = UserDefaults.standard.value(forKey: "socialData") as? NSDictionary ?? [:]
            print(socialDict)
            let passDict = ["fullname":socialDict.object(forKey: "name")!,
                            "username":"",
                            "email":socialDict.object(forKey: "email") as? String ?? "",
                            "socialid":socialDict.object(forKey: "id")!,
                            "phone": socialDict.object(forKey: "phone") as? String ?? "",
                            "password":"",
                            "password_confirmation":"",
                            "deviceType":"ios",
                            "deviceToken":devicetoken,
                            "email_activation" : "1",
                            "firebase_id":firebase_id] as [String : Any]
            print(passDict)
            if InternetConnection.internetshared.isConnectedToNetwork() {
                Indicator.shared.showProgressView(self.view)
                WebserviceConnection.requWithFile(imageData: imagedata, fileName: "image.jpg", imageparam: "image", urlString:"users", parameters: passDict as [String : AnyObject], headers: nil, success: { (responseJson) in
                    Indicator.shared.hideProgressView()
                    print("response JSON")
                    print(responseJson)
                    print("response JSON")
                    if responseJson["status"].stringValue == "SUCCESS" {
                        Indicator.shared.hideProgressView()
                        print("SUCCESS")
                        let  userDict =  responseJson["data"].dictionary ?? [:]
                        let userData  =  SignUpUserDataModel(json: responseJson)
                        userData.fullname =  userDict["fullname"]?.string ?? ""
                        userData.phone =  userDict["phone"]?.string ?? ""
                        userData.username =  userDict["username"]?.string ?? ""
                        userData.image =  userDict["image"]?.string ?? ""
                        userData.bio =  userDict["bio"]?.string ?? ""
                        userData.token =  userDict["token"]?.string ?? ""
                        UserDefaults.standard.set(userData.token, forKey: "token")
                        userData.user_id =  userDict["user_id"]?.string ?? ""
                        userData.email = userDict["email"]?.string ?? ""
                        userData.firebase_id = userDict["firebase_id"]?.string ?? ""
                        let Dict = [
                            "token":userData.token!,
                            "user_id":userData.user_id!,
                            "bio":userData.bio!,
                            "image":userData.image!,
                            "phone":userData.phone!,
                            "fullname":userData.fullname!,
                            "username":userData.username!,
                            "email":userData.email!,
                            "firebase_id":userData.firebase_id!] as [String : Any]
                        self.userDataArray.add(Dict)
                        print(self.userDataArray)
                        UserDefaults.standard.set(self.userDataArray, forKey: "USERINFO")
                        UserDefaults.standard.removeObject(forKey: "imageData")
                        UserDefaults.standard.set(true, forKey: "isLoginSuccessfully")
                        
                        _ = SweetAlert().showAlert("", subTitle: "You can select the categories you are interested in which will then populate your newsfeed", style: AlertStyle.success, buttonTitle:"OK", buttonColor:UIColor.colorFromRGB(0x4C286B)) { (isOtherButton) -> Void in
                            if isOtherButton == true {
                                
                                let vc = self.storyboard?.instantiateViewController(withIdentifier: "CategoriesVC") as! CategoriesVC
                                vc.isComing = "SOCIAL"
                                let navController = UINavigationController(rootViewController: vc)
                                navController.navigationBar.isHidden = true
                                self.appDelegate.window?.rootViewController = navController
                                self.appDelegate.window?.makeKeyAndVisible()
                            }
                            
                        }
                        
                        
                        
                       
                    }else{
                        print("FAILURE")
                        Indicator.shared.hideProgressView()
                        let message  = responseJson["message"].stringValue
                        _ = SweetAlert().showAlert("Escalate", subTitle: message, style: AlertStyle.error)
                    }
                    
                }, failure: { (Error) in
                    print("failure")
                    Indicator.shared.hideProgressView()
                    _ = SweetAlert().showAlert("Escalate", subTitle: "Something went wrong.Please try again!", style: AlertStyle.error)
                })
            }else{
                _ = SweetAlert().showAlert("Escalate", subTitle: "No interter connection!", style: AlertStyle.error)
                Indicator.shared.hideProgressView()
            }
        }else{
            //print(temPassdict!)
            if InternetConnection.internetshared.isConnectedToNetwork() {
                Indicator.shared.showProgressView(self.view)
                // WHEN No Image Updated
                let socialDict = UserDefaults.standard.value(forKey: "socialData") as? NSDictionary ?? [:]
                let devicetoken = UserDefaults.standard.value(forKey: "devicetoken") as? String ?? "bb55d44bfc4492bd33aac79afeaee474e92c12138e18b021e2326"
                let passDict = ["fullname":socialDict.object(forKey: "name")!,
                                "username":socialDict.object(forKey: "email") as? String ?? "",
                                "socialid":socialDict.object(forKey: "id")!,
                                "phone": socialDict.object(forKey: "phone") as? String ?? "",
                                "password":"",
                                "password_confirmation":"",
                                "deviceType":"ios",
                                "deviceToken":devicetoken] as [String : Any]
                print(passDict)
                WebserviceConnection.requestPOSTURL("users", params: passDict as? [String : AnyObject], headers:nil, success: { (responseJson) in
                    if responseJson["status"].stringValue == "SUCCESS" {
                        Indicator.shared.hideProgressView()
                        print("RESPONSE JSON")
                        let  userDict =  responseJson["data"].dictionary ?? [:]
                        let userData  =  SignUpUserDataModel(json: responseJson)
                        userData.fullname =  userDict["fullname"]?.string ?? ""
                        userData.phone =  userDict["phone"]?.string ?? ""
                        userData.username =  userDict["username"]?.string ?? ""
                        userData.image =  userDict["image"]?.string ?? ""
                        userData.bio =  userDict["bio"]?.string ?? ""
                        userData.token =  userDict["token"]?.string ?? ""
                        UserDefaults.standard.set(userData.token, forKey: "token")
                        userData.user_id =  userDict["user_id"]?.string ?? ""
                        let Dict = [
                            "token":userData.token!,
                            "user_id":userData.user_id!,
                            "bio":userData.bio!,
                            "image":userData.image!,
                            "phone":userData.phone!,
                            "fullname":userData.fullname!,
                            "username":userData.username!] as [String : Any]
                        self.userDataArray.add(Dict)
                        print(self.userDataArray)
                        UserDefaults.standard.set(self.userDataArray, forKey: "USERINFO")
                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "CategoriesVC") as! CategoriesVC
                        vc.isComing = "SOCIAL"
                        let navController = UINavigationController(rootViewController: vc)
                        navController.navigationBar.isHidden = true
                        self.appDelegate.window?.rootViewController = navController
                        self.appDelegate.window?.makeKeyAndVisible()
                        print("RESPONSE JSON")
                    }else{
                        _ = SweetAlert().showAlert("Escalate", subTitle: "Something went wrong!", style: AlertStyle.error)
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
    }
}
