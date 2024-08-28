//
//  LogInVC.swift
//  Escalate
//
//  Created by call soft on 20/07/18.
//  Copyright © 2018 call soft. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import FBSDKCoreKit
import Firebase

import GoogleSignIn

//import Firebase

class LogInVC: UIViewController,GIDSignInDelegate,GIDSignInUIDelegate{
    
    
    
    //MARK:- OUTLETS
    //MARK
    
    
    @IBOutlet var txtFeildUserName: UITextField!
    
    @IBOutlet var btnEyeRef: UIButton!
    
    @IBOutlet var txtFeildPassword: UITextField!
    
    @IBOutlet var imgViewRememberMe: UIImageView!
    
    
    //MARK:- VARIABLES
    //MARK:
    
    var firebase_id = ""
    
     var controllerInstance3 =  UIViewController()
    
    var btnRememberMeState = "false"
    
    
    var btnPasswordState = false
    
    
    var userDataArray :NSMutableArray =  NSMutableArray()
    
    let WebserviceConnection  = AlmofireWrapper()
    
    let validation:Validation = Validation.validationManager() as! Validation
    
    var socialLoginFB = ["id","name","first_name","last_name","picture.type(large)","email" ]
    var dict : [String : AnyObject]!
    
    
    //****variables for social login
    var socialName = ""
    var socialAliasName = ""
    var socialPhoneNumber = ""
    var socialEmailId = ""
    var socialGender = ""
    
    
    
    
    //****variables for locations
    
    
    
    var lat = ""
    var log = ""

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initialSetUp()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
//    override var preferredStatusBarStyle: UIStatusBarStyle {
//        return .lightContent
//    }
    
//    override var prefersStatusBarHidden: Bool {
//        return true
//    }
//    
    
    //MARK:- METHODS
    //MARK:
    
    
    
    //TO DO FOR LOCATIONS
    
    


    func Gmail(){
        
        GIDSignIn.sharedInstance().signOut()
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().signIn()
        
    }
    
    
    func initialSetUp(){
        
        
        
        let fontFamilyNames = UIFont.familyNames
        for familyName in fontFamilyNames {
            print("------------------------------")
            print("Font Family Name = [\(familyName)]")
            let names = UIFont.fontNames(forFamilyName: familyName as! String)
            print("Font Names = [\(names)]")
        }
        
        
        if UserDefaults.standard.value(forKey: "REMEBER_STS") != nil{
           print("do nothing")
        }else{
            
            UserDefaults.standard.set(btnRememberMeState, forKey: "REMEBER_STS")
        }
        
        
        
        
        
        
        
       //  AccessCurrentLocationuser()
        
        let email =  UserDefaults.standard.value(forKey: "REMEMBERME_EMAIL") as? String ?? ""
        let password =  UserDefaults.standard.value(forKey: "REMEMBERME_PASSWORD") as? String ?? ""
        
        let chekImage =  UserDefaults.standard.value(forKey: "CHEKimage") as? String ?? ""
        
        
        txtFeildUserName.text = email
        txtFeildPassword.text = password
        
        if chekImage == "true" {
            
            imgViewRememberMe.image = UIImage(named: "login_tick_slected")
            
            
        }else if chekImage == "false"{
            
            imgViewRememberMe.image = UIImage(named: "login_tick_un")
            
        }else{
            
            imgViewRememberMe.image = UIImage(named: "login_tick_un")
        }
        
        
    }
    
    func rotationScreen(){
        UIView.animate(withDuration: 0.75, animations: { () -> Void in
            UIView.setAnimationCurve(UIViewAnimationCurve.easeInOut)
            
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "SignUpVC") as! SignUpVC
            
            
            self.navigationController!.pushViewController(vc, animated: true)
            
            UIView.setAnimationTransition(UIViewAnimationTransition.flipFromRight, for: self.navigationController!.view!, cache: false)
        })
        
    }
    
    
    func rememberPassword(){
        
       
        
        
        guard let btnRememberMeString = UserDefaults.standard.value(forKey: "REMEBER_STS") as? String else{return}
                if btnRememberMeString == "true"{
        
            
                    
                    imgViewRememberMe.image = UIImage(named: "login_tick_slected")
                    UserDefaults.standard.set("true", forKey: "CHEKimage")
                    let txtfiled_UserIdFieldRem = txtFeildUserName.text ?? ""
                    let txtfiled_passwordRem =  txtFeildPassword.text ?? ""
        
                    UserDefaults.standard.set(txtfiled_UserIdFieldRem, forKey: "REMEMBERME_EMAIL")
                    UserDefaults.standard.set(txtfiled_passwordRem, forKey: "REMEMBERME_PASSWORD")
        
        
                }else if btnRememberMeString == "false" {
        
                    imgViewRememberMe.image = UIImage(named: "login_tick_un")
                    UserDefaults.standard.set("false", forKey: "CHEKimage")
                    UserDefaults.standard.removeObject(forKey: "REMEMBERME_EMAIL")
                    UserDefaults.standard.removeObject(forKey: "REMEMBERME_PASSWORD")

                }
    }
    
    //TODO:-WEBSERVICES
    
    
    
    func currentLocationAPIForSimpleSocial(user_id:String) {

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
                    
                    
                    
                    
                     UserDefaults.standard.set(true, forKey: "isLoginSuccessfully")
                    
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "TabBarVC") as! TabBarVC
                    self.navigationController?.pushViewController(vc, animated: true)
                    
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
    
    
    
    
    func currentLocationAPIForSignUp(user_id:String) {
        

        
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
                    
                    
                    UserDefaults.standard.set(true, forKey: "isLoginSuccessfully")
                    
                    
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "CategoriesVC") as! CategoriesVC
                    
                    
                    
                    vc.isComing = "SOCIAL"
                    
                    self.navigationController?.pushViewController(vc, animated: true)
                    
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
    
    

    
    
    
    
    
    func logInUserAPI() {
        
        let devicetoken = UserDefaults.standard.value(forKey: "devicetoken") as? String ?? "bb55d44bfc4492bd33aac79afeaee474e92c12138e18b021e2326"
        
        let passDict = ["username":txtFeildUserName.text!,
                        "password":txtFeildPassword.text!,
                        "deviceType":"ios",
                        "deviceToken":devicetoken,
                        
                        
                        ] as! [String : AnyObject]
        
        print(passDict)
        
        if InternetConnection.internetshared.isConnectedToNetwork() {
            
            Indicator.shared.showProgressView(self.view)
            

            WebserviceConnection.requestPOSTURL("login", params: passDict as [String : AnyObject], headers:nil, success: { (responseJson) in
                
                if responseJson["status"].stringValue == "SUCCESS" {
                    
                    Indicator.shared.hideProgressView()
                    
                    print(responseJson["status"])
                    print(responseJson)
                    
                    self.rememberPassword()
                    
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
                    
                    
                     self.currentLocationAPIForSimpleSocial(user_id:userDict["user_id"]?.string ?? "")
                    

                   
                 
                    
                    
                    
                    
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
    
    
    
    //TODO:-API CALL FOR SOCIAL LOGIN
    
    func apiCallForSocialLogin(){
        
        
        let devicetoken = UserDefaults.standard.value(forKey: "devicetoken") as? String ?? "bb55d44bfc4492bd33aac79afeaee474e92c12138e18b021e2326"
        let socialId = UserDefaults.standard.value(forKey: "SocialID") as? String ?? ""
        
        let Passdict = ["socialid": socialId,
                        "deviceType":"ios",
                        "deviceToken":devicetoken] as [String : Any]
        
        print(Passdict)
        
        if InternetConnection.internetshared.isConnectedToNetwork() {
            
            //Indicator.shared.showProgressView(self.view)
            
            WebserviceConnection.requestPOSTURL("social_login", params: Passdict as [String : AnyObject], headers:nil, success: { (responseJson) in
                
                if responseJson["status"].stringValue == "SUCCESS" {
                    
                    Indicator.shared.hideProgressView()
                    print(responseJson)
                    
                    let  userDict =  responseJson["data"].dictionary!
                    
                    if let status = userDict["status"] {
                        
                        if status == "0"{
                            let vc = self.storyboard?.instantiateViewController(withIdentifier: "SocialLoginPopUpVC") as! SocialLoginPopUpVC
                            self.navigationController?.present(vc, animated: true, completion: nil)
                            // WHEn first time user ko firebase mei register karoghay
                        }else{
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
                            
                            userData.email =  userDict["email"]?.string ?? ""
                            
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
                            
                            self.currentLocationAPIForSimpleSocial(user_id:userDict["user_id"]?.string ?? "")
                            
                            
                            
                           
                            
                            
                        }
                        
                    }else{
                        
                        // DO NOTHING
                    }
                    
                    
                }else{
                    
                    Indicator.shared.hideProgressView()
                    
                    let message  = responseJson["message"].stringValue
                    
                    print("FAILUERE")
                    print(responseJson)
                    
                    _ = SweetAlert().showAlert("Escalate", subTitle: message, style: AlertStyle.error)
                    
                    
                }
                
                
            },failure: { (Error) in
                
                Indicator.shared.hideProgressView()
                
                _ = SweetAlert().showAlert("Escalate", subTitle: "Something went wrong.Please try again!", style: AlertStyle.error)
                
                
            })
            
            
        }else{
            
            _ = SweetAlert().showAlert("Escalate", subTitle: "No interter connection!", style: AlertStyle.error)
            
            
        }
        
        
        
    }
    
    
   
    
    
    
  
    
    //TODO:-VALIDATIONS
    
    
    func validationSetup()->Void{
        
        
        var message = ""
        if !validation.validateBlankField(txtFeildUserName.text!){
            
            message = "Please enter your User Name"
        }
            
            
        else if !validation.validateUsername(txtFeildUserName.text!) {
            
            message = "Please enter your valid Full Name"
            
        }
            
        else if !validation.validateBlankField(txtFeildPassword.text!){
            message = "Please enter Password"
        }
        
        if message != "" {
            
            
            _ = SweetAlert().showAlert("Escalate", subTitle: message, style: AlertStyle.error)
            
        }else{
            
            
            logInUserAPI()
            
        }
        
        
    }
    
    
    func getFBUserData(){

        if((FBSDKAccessToken.current()) != nil){
            FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name, last_name, picture.type(large), email"]).start(completionHandler: { (connection, result, error) -> Void in
                if (error == nil){
                    
                    
                    
                    self.dict = result as! [String : AnyObject]
                    print(result!)
                    
                     Indicator.shared.showProgressView(self.view)
                    
                    let pictureData = self.dict["picture"]!.value(forKey: "data")! as? NSDictionary ?? [:]
                    let pictureUrl = pictureData.value(forKey: "url")
                    
                    let theProfileImageUrl:URL! = URL(string: pictureUrl as! String)
                    
                    
                    do{
                        let imageData = try NSData(contentsOf: theProfileImageUrl as URL)
                        
                        UserDefaults.standard.set(imageData, forKey: "imageData")
                        
                    }catch{
                        print(error)
                    }
                    if let name = self.dict["name"]{
                        print(name)
                        self.socialName = "\(name)"
                    }
                    if let nickName = self.dict["last_name"]{
                        print(nickName)
                        self.socialAliasName = "\(nickName)"
                    }
                    if let email = self.dict["email"]{
                        print(email)
                        self.socialEmailId = "\(email)"
                        
                    }
                    
                    if let fbID = self.dict["id"]{
                        print(fbID)
                        
                        UserDefaults.standard.set("\(fbID)", forKey: "SocialID")
                        
                    }
                    UserDefaults.standard.set(self.dict, forKey: "socialData")
                    print(UserDefaults.standard.value(forKey: "socialData"))
                    self.apiCallForSocialLogin()
                    
                }
            })
        }
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        
        if error != nil{
            print(error ?? "google error")
            return
        }
            
        else {
            
            
            
            
            print(user)
            
            print("\(user.userID)")
            print("\(user.authentication.idToken)")
            print("\(user.profile.name)")
            print("\(user.profile.givenName)")
            print("\(user.profile.familyName)")
            print("\(user.profile.email)")
            
            self.socialName = "\(user.profile.name!)"
            self.socialEmailId = "\(user.profile.email!)"
            self.socialAliasName = "\(user.profile.familyName!)"
            
            let profilePicURL = user.profile.imageURL(withDimension: 200).absoluteString
            
            let theProfileImageUrl:URL! = URL(string:profilePicURL as! String)
            
            do{
                let imageData =   try NSData(contentsOf: theProfileImageUrl as URL)
                print(imageData)
                UserDefaults.standard.set(imageData, forKey: "imageData")
            }
            catch{
                print(error)
            }
            
            print(profilePicURL)
            
            
            
            
            UserDefaults.standard.set("\(user.userID!)", forKey: "SocialID")
            
            self.dict = ["name": socialName,
                         "email":socialEmailId,
                         "id":user.userID!] as [String : AnyObject]
            UserDefaults.standard.set(self.dict, forKey: "socialData")
            print(self.dict)
            
            self.apiCallForSocialLogin()
            
            
        }
    }
    
    
    
    
    
    
    //MARK:- ACTIONS
    //MARK:
    
    
    @IBAction func btnGoogleLoginTapped(_ sender: Any) {
        Gmail()
        
    }
    
    
    @IBAction func btnSignUpTapped(_ sender: UIButton) {
        rotationScreen()
    }
    
    @IBAction func btnForgotPasswordTapped(_ sender: UIButton) {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ForgotPasswordVC") as! ForgotPasswordVC
        
        
        self.navigationController!.pushViewController(vc, animated: true)
    }
    
    @IBAction func btnLogInTapped(_ sender: UIButton) {
        
        UserDefaults.standard.setValue("SIMPLE", forKey: "ENTERINGFROM")
        
        validationSetup()
    }
    
    
    
    @IBAction func btnRememberMeAction(_ sender: Any) {
        if btnRememberMeState == "false"{
            
            
            
            imgViewRememberMe.image = UIImage(named: "login_tick_slected")
            
           
            btnRememberMeState = "true"
            UserDefaults.standard.set(btnRememberMeState, forKey: "REMEBER_STS")
           
            
            
        }else {
            
            imgViewRememberMe.image = UIImage(named: "login_tick_un")
            UserDefaults.standard.set("false", forKey: "CHEKimage")
            UserDefaults.standard.removeObject(forKey: "REMEMBERME_EMAIL")
            UserDefaults.standard.removeObject(forKey: "REMEMBERME_PASSWORD")
            //UserDefaults.standard.set(btnRememberMeState, forKey: "REMEBER_STS")
            btnRememberMeState = "false"
             UserDefaults.standard.set(btnRememberMeState, forKey: "REMEBER_STS")
            
        }
    }
    
    
    @IBAction func btnEyeTapped(_ sender: Any) {
        
        
        if btnPasswordState ==  false {
            
            txtFeildPassword.isSecureTextEntry = false
            btnPasswordState = true
            
            btnEyeRef.setImage(UIImage(named: "login_selected_eye"), for: .normal)
            
        }else{
            
            txtFeildPassword.isSecureTextEntry = true
            btnPasswordState = false
            
            btnEyeRef.setImage(UIImage(named: "login_unselected_eye"), for: .normal)
            
        }
        
        
        
    }
    
    
    @IBAction func btnFbTapped(_ sender: UIButton) {
        
        UserDefaults.standard.setValue("SOCIAL", forKey: "ENTERINGFROM")
        
        
        let fbLoginManager : FBSDKLoginManager = FBSDKLoginManager()
        fbLoginManager.logIn(withReadPermissions: ["email"], from: self) { (result, error) in
            if (error == nil){
                let fbloginresult : FBSDKLoginManagerLoginResult = result!
                if fbloginresult.grantedPermissions != nil {
                    if(fbloginresult.grantedPermissions.contains("email"))
                    {
                        self.getFBUserData()
                        fbLoginManager.logOut()
                    }
                }
            }
        }
        
        
        
    }
    
    

    
    
}

