//
//  VarificationVC.swift
//  Escalate
//
//  Created by call soft on 19/07/18.
//  Copyright © 2018 call soft. All rights reserved.
//

import UIKit
import FirebaseAuth



import Firebase



class VarificationVC: UIViewController{
    
    
    
    
    //MARK:- OUTLETS
    //MARK:
    
    
    @IBOutlet weak var lblTimer: UILabel!
    
    @IBOutlet weak var btnResendRef: UIButton!
    @IBOutlet var txtFeildIOTP: UITextField!
    
    
    //MARK:- VARIABLES
    //MARK:
    
    
    var isComing = ""
    
    var phoneNumber = ""
    
    var contoller =  UIViewController()
    
    var userDataArray :NSMutableArray =  NSMutableArray()
    
     let WebserviceConnection  = AlmofireWrapper()
    
    
    var emailString = ""
    
    var firebase_id = ""
    
    //****variables for locations
    

    
    var lat = ""
    var log = ""
    
    var otpString = ""
    
    var countLimit = 120
    
    var timerLimit:Timer?
    
    
    var hr = 0
    
    var min = 0
    
    var sec = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        
     
//        AccessCurrentLocationuser()
        
           countDownTimet2()
        
        // Do any additional setup after loading the view.
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    //TODO : HANDLE REGISTRASION IN FIREBASE
    
    func handleRegistration(email:String,password:String){
        
        
        Auth.auth().createUserAndRetrieveData(withEmail: email, password: password) { (user, error) in
           
            if error != nil{
                print("Error in firebase registration:- \(error)")
                return
                
            }else{
                
                
               print("register kara do")
                
                
            }
            
            
        }
       
      
//        Auth.auth().createUser(withEmail: email, password: password, completion: { (user, error) in
//            if error != nil {
//                print(error)
//                return
//
//            }else{
//
//                self.userDict = ["userName":self.txtUserName.text!,
//                                 "email":self.txtEmail.text!,
//                                 "password":self.txtPassword.text!,
//                                 "designation":self.txtEmployeeDesgnation.text!,
//                                 "employeeCode":self.txtEmployeeID.text!,
//                                 "confirmPassword":self.txtConfirmPassword.text!,
//                                 "profileImageURL":"",
//                                 "UserFireBAseID":(Auth.auth().currentUser?.uid)!]
//
//
//                self.userName = self.txtUserName.text!
//
//
//                let mainDatabaseRefrence =  Database.database().reference(fromURL:"https://offiece-amigos.firebaseio.com/")
//                let userlist = mainDatabaseRefrence.child("UserList").child((user?.uid)!)
//                userlist.updateChildValues(self.userDict, withCompletionBlock: { (Err, userlist) in
//                    if Err != nil {
//                        print(Err)
//                    }else{
//
//                        print("DATA SAVE SEXY FULLY.")
//
//                        UserDefaults.standard.removeObject(forKey: "IMAGE_SET")
//
//
//                    }
//
//
//
//                })
//
//
//
//            }
//
//        })

        
    }
    
    
    
    
    
    
    
    //MARK:- WEB SERVICES
    //MARK:
    
    //TODO:-WEBSERVICES
    
    
    //ONE MINUTE TIMER
    
    func countDownTimet2(){
        timerLimit = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.update2), userInfo: nil, repeats: true)
    }
    
    
    @objc func update2() {
        if(countLimit > 0) {
            
            sec = countLimit
            
           if countLimit < 120 && countLimit > 60{

                let tempSec = countLimit - 60
                
                if tempSec < 10 {
                  lblTimer.text = "01:0\(tempSec)"
                }else{
                  lblTimer.text = "01:\(tempSec)"
                }
                
                
           }else if countLimit == 60{
            
            lblTimer.text = "01:00"
            
           }else if countLimit < 60{
            
                if countLimit < 10{
                    lblTimer.text = "00:0\(countLimit)"
                }else{
                    lblTimer.text = "00:\(countLimit)"
                }
            }
        
            countLimit = countLimit - 1
            print(countLimit)
        
        }
        else{
            print("TIMERCOUNT")
            print(countLimit)
            timerLimit?.invalidate()
            timerLimit = nil
            btnResendRef.isHidden = false
            lblTimer.isHidden = true
            countLimit = 120
            
            
         
            
            
            
        }
    }
    
    
    
    
    
    
    
    
    
    
    
    func checkUser() {
        
        
        
        
        let tempPassDict = UserDefaults.standard.value(forKey: "PASSDICT") as? NSDictionary ?? [:]
        
        
        
        print(tempPassDict)
        
        
        let fullname = tempPassDict.value(forKey: "fullname") as? String ?? ""
        let username = tempPassDict.value(forKey: "username") as? String ?? ""
        let socialid = tempPassDict.value(forKey: "socialid") as? String ?? ""
        let phone = tempPassDict.value(forKey: "phone") as? String ?? ""
        let country_code = tempPassDict.value(forKey: "country_code") as? String ?? ""
        let email = tempPassDict.value(forKey: "email") as? String ?? ""
        let password = tempPassDict.value(forKey: "password") as? String ?? ""
        let password_confirmation = tempPassDict.value(forKey: "password_confirmation") as? String ?? ""
        let deviceType = tempPassDict.value(forKey: "deviceType") as? String ?? ""
        let deviceToken = tempPassDict.value(forKey: "deviceToken") as? String ?? ""
        
        
        
        let passDict = ["phone":phone,
                        "country_code":country_code,
                        "email":email,
                        "username":username] as! [String : AnyObject]
        
        //        let passDict = ["phone":"\(txtCountryCode.text!)\(txtFeildPhoneNumber.text!)",
        //                        "email":txtFeildMail.text!,
        //                        "username":txtFeildUserName.text!] as! [String : AnyObject]
        
        print(passDict)
        
        if InternetConnection.internetshared.isConnectedToNetwork() {
            
            Indicator.shared.showProgressView(self.view)
            
            WebserviceConnection.requestPOSTURL("check_back", params: passDict as [String : AnyObject], headers:nil, success: { (responseJson) in
                
                if responseJson["status"].stringValue == "SUCCESS" {
                    
                    Indicator.shared.hideProgressView()
                    
                    print(responseJson["status"])
                    print(responseJson)
                    
                    let dataDict = responseJson["data"].dictionaryObject as? NSDictionary ?? [:]
                    
                    
                    
                    self.otpString = dataDict.value(forKey: "otp") as? String ?? ""
                    
                    print(self.otpString)
                    
                   // self.DataOnSignup()
                    self.btnResendRef.isHidden = true
                    self.lblTimer.isHidden = false
                    self.lblTimer.text = "02:00"
                    self.countDownTimet2()
                    
                    
                    
                    
                    
                }else{
                    
                    Indicator.shared.hideProgressView()
                    
                    
                    
                    let message  = responseJson["message"].stringValue
                    
                    _ = SweetAlert().showAlert("Escalate", subTitle: message, style: AlertStyle.error)
                    
                    
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
    
    
    
    
    
    func currentLocationAPI(user_id:String) {
        
        //        lat : required
        //        log : required
        //        user_id : required
        
        
        let passDict = ["lat":"0.00",
            "log":"0.00",
            "user_id":user_id] as! [String : AnyObject]
        
        print(passDict)
        
        if InternetConnection.internetshared.isConnectedToNetwork() {
            
            Indicator.shared.showProgressView(self.view)
            
            WebserviceConnection.requestPOSTURL("latlongupdater", params: passDict as [String : AnyObject], headers:nil, success: { (responseJson) in
                
                if responseJson["status"].stringValue == "SUCCESS" {
                    
                    Indicator.shared.hideProgressView()
                    
                    print(responseJson["status"])
                    print(responseJson)
                   
                    
                    
                    
                    //self.handleRegistration(email:userData.email!,password:"123456")
                    
                    
                    
                }else{
                    
                    Indicator.shared.hideProgressView()
                    
                    
                    let user = Auth.auth().currentUser
                    
                    user?.delete { error in
                        if let error = error {
                            // An error happened.
                        } else {
                           
                            print("Account deleted")
                            
                        }
                    }
                    
                    let message  = responseJson["message"].stringValue
                    
                    _ = SweetAlert().showAlert("Escalate", subTitle: message, style: AlertStyle.error)
                    
                    
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
    
    
    
    
//
//    func fireBaseRegister(){
//
//
//        var tempPassDict = UserDefaults.standard.value(forKey: "PASSDICT") as? NSDictionary ?? [:]
//
//        let emailID = tempPassDict.value(forKey: "email") as? String ?? ""
//
//
//
//        ////////FIREBASE REGISTER///////////
//
//        Auth.auth().createUser(withEmail: emailID, password: "123456", completion: { (firUser, error) in
//            if error != nil{
//                print("Error in register user in Firebase:- \(error)")
//
//                let user = Auth.auth().currentUser
//
//                user?.delete { error in
//                    if let error = error {
//                        // An error happened.
//                    } else {
//                        // Account deleted.
//
//                        print("Account Delete ho gya")
//                    }
//                }
//
//            }else{
//
//
//                self.firebase_id = (Auth.auth().currentUser?.uid)!
//
//                print(self.firebase_id)
//
//                print("Successfully register user into Firebase.")
//
//
//                self.signUserAPI()
//
//
//
//            }
//        })
//
//
//        //////////FIREBASE REGISTER///////////
//
//    }
//
//
//
//
    
    
    func signUserAPI() {
        
        
        
        let passDict = UserDefaults.standard.value(forKey: "PASSDICT") as? [String : Any] ?? [:]
        

        
        print(passDict)
        
        if InternetConnection.internetshared.isConnectedToNetwork() {
            
            Indicator.shared.showProgressView(self.view)
            
            WebserviceConnection.requestPOSTURL("users", params: passDict as [String : AnyObject], headers:nil, success: { (responseJson) in
                
                if responseJson["status"].stringValue == "SUCCESS" {
                    
                    Indicator.shared.hideProgressView()
                    
                    print(responseJson["status"])
                    print(responseJson)
                    
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
                    
                    
                    ////////FIREBASE REGISTER///////////
                    
//                    Auth.auth().createUser(withEmail: userData.email!, password: "123456", completion: { (firUser, error) in
//                        if error != nil{
//                            print("Error in register user in Firebase:- \(error)")
//
//
//                            let user = Auth.auth().currentUser
//
//                            user?.delete { error in
//                                if let error = error {
//                                    // An error happened.
//                                } else {
//                                    // Account deleted.
//
//                                    print("Account Delete ho gya")
//                                }
//                            }
//
//                        }else{
//
//
//
//                            print("Successfully register user into Firebase.")
//
//
//
//
//
//
//                        }
//                    })
//
                    
                    //////////FIREBASE REGISTER///////////
                    
                    
                    
                    weak var pvc = self.presentingViewController
                    self.dismiss(animated: true, completion: {
                        
                        
                        _ = SweetAlert().showAlert("", subTitle: "Select the categories you're interested in. We 'll then populate your newsfeed with the conversations on these topics to give you a foundation of people to interact with on the app", style: AlertStyle.success, buttonTitle:"OK", buttonColor:UIColor.colorFromRGB(0x4C286B)) { (isOtherButton) -> Void in
                            if isOtherButton == true {
                                
                                let vc = self.storyboard?.instantiateViewController(withIdentifier: "CategoriesVC") as! CategoriesVC
                                
                                vc.isComing = "VARIFICATION"
                                
                                let navigation = UINavigationController(rootViewController: vc)
                                navigation.isNavigationBarHidden = true
                                vc.controllerInstance5 =  self.contoller
                                pvc?.present(navigation, animated: true, completion: nil)
                            }
                            
                        }
                        
                        
                    })
                    
  
                    
                }else{
                    
                    Indicator.shared.hideProgressView()
                    
                    
                    let user = Auth.auth().currentUser
                    
                    user?.delete { error in
                        if let error = error {
                            // An error happened.
                        } else {
                            print("Account deleted")
                        }
                    }
                    
                    let message  = responseJson["message"].stringValue
                    
                    _ = SweetAlert().showAlert("Escalate", subTitle: message, style: AlertStyle.error)
                    
                    
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
    
    
    func chekingForOTPConfirmation(){
        
        let verificationID = UserDefaults.standard.value(forKey: "OtpVerification") as! String
        let verificationCode = txtFeildIOTP.text!
        let credential = PhoneAuthProvider.provider().credential(
            withVerificationID: verificationID,
            verificationCode: verificationCode)
        
        Indicator.shared.showProgressView(self.view)
        
        
        if InternetConnection.internetshared.isConnectedToNetwork(){
            
            
            Auth.auth().signIn(with: credential) { (user, error) in
                if let error = error {
                    
                    
                    Indicator.shared.hideProgressView()
                    print("error: \(String(describing: error.localizedDescription))")
                     _ = SweetAlert().showAlert("Escalate", subTitle: "You have entred wrong code", style: AlertStyle.error)
                    return
                }
                // User is signed in
                // ...
                Indicator.shared.hideProgressView()
                print("Phone Number: \(String(describing: user?.phoneNumber))")
                let userInfo = user?.providerData[0]
                print("Provider ID: \(String(describing: userInfo?.providerID))")
                
                
//                self.fireBaseRegister()
                self.signUserAPI()
            
                
            }
            
        }
        else{
            
            _ = SweetAlert().showAlert("Escalate", subTitle: "No interter connection!", style: AlertStyle.error)
            
            
        }
        
        
        
    }
    
    
    func chekingForgotOTPConfirmation(){
        
        let verificationID = UserDefaults.standard.value(forKey: "OtpVerification") as! String
        let verificationCode = txtFeildIOTP.text!
        let credential = PhoneAuthProvider.provider().credential(
            withVerificationID: verificationID,
            verificationCode: verificationCode)
        
        Indicator.shared.showProgressView(self.view)
        
        
        if InternetConnection.internetshared.isConnectedToNetwork(){
            
            
            Auth.auth().signIn(with: credential) { (user, error) in
                if let error = error {
                    
                    
                    Indicator.shared.hideProgressView()
                    print("error: \(String(describing: error.localizedDescription))")
                    _ = SweetAlert().showAlert("Escalate", subTitle: "You have entred wrong code", style: AlertStyle.error)
                    return
                }
                // User is signed in
                // ...
                Indicator.shared.hideProgressView()
                print("Phone Number: \(String(describing: user?.phoneNumber))")
                let userInfo = user?.providerData[0]
                print("Provider ID: \(String(describing: userInfo?.providerID))")
                
              
                
                weak var pvc2 = self.presentingViewController
                self.dismiss(animated: true, completion: {
                    
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "ChangePasswordAfterOTPVC") as! ChangePasswordAfterOTPVC
                    vc.controllerInstance2 =  self.contoller
                    
                    pvc2?.present(vc, animated: true, completion: nil)
                    
                })
                
                
            }
            
        }
        else{
            
            _ = SweetAlert().showAlert("Escalate", subTitle: "No interter connection!", style: AlertStyle.error)
            
            
        }
        
        
        
    }
    
    
    
    func getOTPEmail() {
        
        
        
        let passDict = ["email":emailString] as [String : AnyObject]
        
        print(passDict)
        
        if InternetConnection.internetshared.isConnectedToNetwork() {
            
            Indicator.shared.showProgressView(self.view)
            
            WebserviceConnection.requestPOSTURL("forgotPassword", params: passDict as [String : AnyObject], headers:nil, success: { (responseJson) in
                
                if responseJson["status"].stringValue == "SUCCESS" {
                    
                    Indicator.shared.hideProgressView()
                    
                    print(responseJson["status"])
                    print(responseJson)
                    
                    self.btnResendRef.isHidden = true
                    self.lblTimer.isHidden = false
                    self.lblTimer.text = "02:00"
                    self.countDownTimet2()
                   
                  
                    
                    
                    
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
    
    
    func varifyOTPEmail(){
        
        
        
        let passDict = ["email":emailString,
                        "otp":txtFeildIOTP.text!] as [String : AnyObject]
        
        print(passDict)
        
        if InternetConnection.internetshared.isConnectedToNetwork() {
            
            Indicator.shared.showProgressView(self.view)
            
            WebserviceConnection.requestPOSTURL("verifyemailotp", params: passDict as [String : AnyObject], headers:nil, success: { (responseJson) in
                
                if responseJson["status"].stringValue == "SUCCESS" {
                    
                    Indicator.shared.hideProgressView()
                    
                    print(responseJson["status"])
                    print(responseJson)
                    
                    let dataDict = responseJson["data"].dictionaryObject as? NSDictionary ?? [:]
                    
                    let userID = dataDict.value(forKey: "user_id") as? String ?? ""
                    
                    print(userID)
                    
                    
                    UserDefaults.standard.set(userID, forKey: "USERID")
                    
                    
                    weak var pvc1 = self.presentingViewController
                    self.dismiss(animated: true, completion: {
                        
                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ChangePasswordAfterOTPVC") as! ChangePasswordAfterOTPVC
                        vc.controllerInstance2 =  self.contoller
                        vc.userID = userID
                        pvc1?.present(vc, animated: true, completion: nil)
                        
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
    
    
    
    
    func varifyOTPEmailSignUP(){
        
        
        
        let passDict = ["email":emailString,
                        "otp":txtFeildIOTP.text!] as [String : AnyObject]
        
        print(passDict)
        
        if InternetConnection.internetshared.isConnectedToNetwork() {
            
            Indicator.shared.showProgressView(self.view)
            
            WebserviceConnection.requestPOSTURL("verifyemailotp", params: passDict as [String : AnyObject], headers:nil, success: { (responseJson) in
                
                if responseJson["status"].stringValue == "SUCCESS" {
                    
                    Indicator.shared.hideProgressView()
                    
                    print(responseJson["status"])
                    print(responseJson)
                    
                    let dataDict = responseJson["data"].dictionaryObject as? NSDictionary ?? [:]
                    
                    let userID = dataDict.value(forKey: "user_id") as? String ?? ""
                    
                    print(userID)
                    
                    
                    UserDefaults.standard.set(userID, forKey: "USERID")
                    
                    self.signUserAPI()
                    //self.fireBaseRegister()
                    
                    
//                    weak var pvc1 = self.presentingViewController
//                    self.dismiss(animated: true, completion: {
//
//                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ChangePasswordAfterOTPVC") as! ChangePasswordAfterOTPVC
//                        vc.controllerInstance2 =  self.contoller
//                        vc.userID = userID
//                        pvc1?.present(vc, animated: true, completion: nil)
//
//                    })
                    
                    
                    
                    
                    
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
    
    
    
    
    
    
    
    
    func varifyOTPPhone(){
        
        
       // let userID = UserDefaults.standard.value(forKey: "USERID") as? String ?? ""
        
        let passDict = ["Phone":phoneNumber] as [String : AnyObject]
        
        print(passDict)
        
        if InternetConnection.internetshared.isConnectedToNetwork() {
            
            Indicator.shared.showProgressView(self.view)
            
            WebserviceConnection.requestPOSTURL("verifyemailotp", params: passDict as [String : AnyObject], headers:nil, success: { (responseJson) in
                
                if responseJson["status"].stringValue == "SUCCESS" {
                    
                    Indicator.shared.hideProgressView()
                    
                    print(responseJson["status"])
                    print(responseJson)
                    
                    let dataDict = responseJson["data"].dictionaryObject as? NSDictionary ?? [:]
                    
                    let userID = dataDict.value(forKey: "user_id") as? String ?? ""
                    
                    print(userID)
                    
                    UserDefaults.standard.set(userID, forKey: "USERID")
                    
                    
                   self.chekingForgotOTPConfirmation()
                   
                    
                    
                    
                    
                    
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
    
    
    
    
    
    
    func sendOtpUsingFirebase(){
        
        Indicator.shared.showProgressView(self.view)
        
        PhoneAuthProvider.provider().verifyPhoneNumber(phoneNumber, uiDelegate: nil ) { (verificationID, error) in
            if let error = error {
                
                Indicator.shared.hideProgressView()
                _ = SweetAlert().showAlert("Escalate", subTitle: "Something went wrong!", style: AlertStyle.error)
                print(error)
                
                return
                
            }else{
                Indicator.shared.hideProgressView()
                print("Aman")
                print(verificationID!)
                UserDefaults.standard.set("\(verificationID!)", forKey: "OtpVerification")
                
               
                
                
                
            }
            
        }
    }
    
    
    
    
   
    
    @IBAction func btnCancelTapped(_ sender: UIButton) {
        timerLimit?.invalidate()
        timerLimit = nil
        btnResendRef.isHidden = false
        lblTimer.isHidden = true
        countLimit = 120
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func btnConfirmTapped(_ sender: Any) {
        
        timerLimit?.invalidate()
        timerLimit = nil
        btnResendRef.isHidden = false
        lblTimer.isHidden = true
        countLimit = 120
        

        if isComing == "SIGNUP"{
        
        chekingForOTPConfirmation()
        }
        
        else if isComing == "FORGOTPASSWORDPHONE"{
            
            //varifyOTPPhone()
       chekingForgotOTPConfirmation()
            
          
            
        }
            
        else if isComing == "SIGNUPMAIL"{
            
            
            print(otpString)
            
            if otpString == txtFeildIOTP.text!{
               self.signUserAPI()
               //self.fireBaseRegister()
            }
            
            else{
                
                 _ = SweetAlert().showAlert("Escalate", subTitle: "You have entered wrong OTP.", style: AlertStyle.error)
            }
            
            
        }
        
        else{
            
            varifyOTPEmail()
            
        }
        
  
    }
    
    
    
    @IBAction func btnVarificationTapped(_ sender: UIButton) {
        
        
        if isComing == "SIGNUP"{
            
           sendOtpUsingFirebase()
        }
           
             else if isComing == "SIGNUPMAIL"{
            
            checkUser()
            
        }
            
            
        else if isComing == "FORGOTPASSWORDPHONE"{
            sendOtpUsingFirebase()
            
            //varifyOTPPhone()
            
        }
        else {
            
            getOTPEmail()
            
        }
        
        
    }
    
}
