//
//  SignUpVC.swift
//  Escalate
//
//  Created by call soft on 20/07/18.
//  Copyright © 2018 call soft. All rights reserved.
//

import UIKit
import FirebaseAuth


class SignUpVC: UIViewController {
    
    
    
   
    
    
    //MARK:- OUTLETS
    //MARK:
    
    
    @IBOutlet weak var txtCountryCode: UITextField!
    
    @IBOutlet var btnConfirmPasswordEye: UIButton!
    
    
    @IBOutlet var btnEye: UIButton!
    
    
    @IBOutlet var txtFeildFullName: UITextField!
    
    @IBOutlet var txtFeildUserName: UITextField!
    
    
    @IBOutlet var txtFeildMail: UITextField!
    
    
    @IBOutlet var txtFeildPhoneNumber: UITextField!
    
    
    @IBOutlet var txtFeildPassword: UITextField!
    
    @IBOutlet var txtFeildConfirmPassword: UITextField!
    
    @IBOutlet weak var imgViewTermsAndCondion: UIImageView!
     @IBOutlet weak var lbl_TermConditions: UILabel!
    
    @IBOutlet weak var imgViewNotification: UIImageView!
    //MARK:- VARIABLES
    
    var arrayFromPlist:NSMutableArray = NSMutableArray()
    
    let WebserviceConnection  = AlmofireWrapper()
    
    var btnPasswordState = false
    
    var btnConfirmPasswordState = false
    
    let validationSwift = ValidationSwift.sharedValidationSwiftInstance
    
    let validation:Validation = Validation.validationManager() as! Validation
    
   
    
    
    
    var otpString = ""
    
    var acceptTermsAndConditionState = false
    var notificationState = false
    
    
    //FIND CHARACTERSETS
    
    
    let letters = CharacterSet.letters
    let digits = CharacterSet.decimalDigits
    
    var letterCount = 0
    var digitCount = 0


    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        intial_setup()
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

    //MARK:- METHODS
    //MARK:
    
    func rotationScreen(){
        UIView.animate(withDuration: 0.75, animations: { () -> Void in
            UIView.setAnimationCurve(UIViewAnimationCurve.easeInOut)

            self.navigationController?.popViewController(animated: true)
            
            UIView.setAnimationTransition(UIViewAnimationTransition.flipFromLeft, for: self.navigationController!.view!, cache: false)
        })
        
    }
    
 
    func intial_setup() {
        
        //for Move To SignUp
//        Tick this box if you are over the age of 16 and agree to Escalate's Terms and Condtions of service and Privacy Policy.
        
        
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
    
    
    //MARK:- USER DEFINED METHODS
    //MARK:

    //TODO:-VALIDATIONS
    
    
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
    
    
    func validationForUsername()->Bool{
        
        do {
            let regex = try NSRegularExpression(pattern: ".*[^A-Za-z0-9].*", options: .caseInsensitive)
            if let _ = regex.firstMatch(in: txtFeildUserName.text!, options: NSRegularExpression.MatchingOptions.reportCompletion, range: NSMakeRange(0, txtFeildUserName.text!.count)) {
                return true
            }
            
        } catch {
            debugPrint(error.localizedDescription)
            return false
        }
        
        return false
        
    }
    
    func validationForFullName()->Bool{
        
        do {
            let regex = try NSRegularExpression(pattern: ".*[^A-Za-z ].*", options: .caseInsensitive)
            if let _ = regex.firstMatch(in: txtFeildFullName.text!, options: NSRegularExpression.MatchingOptions.reportCompletion, range: NSMakeRange(0, txtFeildFullName.text!.count)) {
                return true
            }
            
        } catch {
            debugPrint(error.localizedDescription)
            return false
        }
        
        return false
        
    }

    
    
    
    func validationSetup()->Void{
        
    
        
        var message = ""
        
        //var tempString = txtFeildMail.text ?? ""
        
        if !validation.validateBlankField(txtFeildFullName.text!){
            
            message = "Please enter your full name"
        }
            
        else if validationForFullName() == true{
            message = "Please enter your valid full name (Full Name contains A-Z or a-z, no special character or digits are allowed.)"
        }
            
        else if !validation.validateBlankField(txtFeildUserName.text!){
            
            message = "Please enter your user name"
        }
        else if validationForUsername() == true{
            
             message = "Please enter your valid user name"
        }
        
        else if !validation.validateBlankField(txtFeildMail.text!){
            message = "Please enter Email ID"
            
        }else if !validation.validateEmail(txtFeildMail.text!){
            
            message = "Please enter valid Email ID"
        }
            
//        else if !validation.validateBlankField(txtCountryCode.text!){
//            message = "Please select country code"
//        }
//
//        else if !validation.validateBlankField(txtFeildPhoneNumber.text!){
//            message = "Please enter phone number"
//        }
            
        else if !validation.validateBlankField(txtFeildPassword.text!){
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
        else if acceptTermsAndConditionState == false{
            
            message = "Please accept terms and conditions"
            
        }
        
        if message != "" {
            
            
            _ = SweetAlert().showAlert("Escalate", subTitle: message, style: AlertStyle.error)
            
        }else{
            
            
            checkUser()
            
            
            
        }
        
        
    }
    
    
    
    
    
    
    //TODO:-WEBSERVICES
    
    
    
    func getOTPEmail() {
        
        
        
        let passDict = ["email":txtFeildMail.text!] as [String : AnyObject]
        
        print(passDict)
        
        if InternetConnection.internetshared.isConnectedToNetwork() {
            
            Indicator.shared.showProgressView(self.view)
            
            WebserviceConnection.requestPOSTURL("forgotPassword", params: passDict as [String : AnyObject], headers:nil, success: { (responseJson) in
                
                if responseJson["status"].stringValue == "SUCCESS" {
                    
                    Indicator.shared.hideProgressView()
                    
                    print(responseJson["status"])
                    print(responseJson)
                    
                    
                    
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "VarificationVC") as! VarificationVC
                    
                    vc.emailString = self.txtFeildMail.text!
                    
                    vc.isComing = "SIGNUPMAIL"
                    
                    
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
    
    
    
    
    
    
    
    
    
    func checkUser() {
    
        
        
        let passDict = ["phone":txtFeildPhoneNumber.text!,
                        "country_code":txtCountryCode.text!,
                        "email":txtFeildMail.text!,
                        "username":txtFeildUserName.text!] as! [String : AnyObject]
        
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
                    
                    self.DataOnSignup()
                    
                    
                    
                    
                    
                    
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
    
    
    
    
    func DataOnSignup(){
        

        let status = notificationState ? "1" : "0" ;
        let devicetoken = UserDefaults.standard.value(forKey: "devicetoken") as? String ?? "bb55d44bfc4492bd33aac79afeaee474e92c12138e18b021e2326"
        
        let passDict = ["fullname":txtFeildFullName.text!,
                        "username":txtFeildUserName.text!,
                        "socialid":"",
                        "phone":txtFeildPhoneNumber.text!,
                        "country_code":txtCountryCode.text!,
                        "email": txtFeildMail.text!,
                        "password":txtFeildPassword.text!,
                        "password_confirmation":txtFeildConfirmPassword.text!,
                        "deviceType":"ios",
                        "email_activation" : status,
                        "deviceToken":devicetoken] as [String : Any]
        
        print(passDict)
        
        if InternetConnection.internetshared.isConnectedToNetwork() {
            
           
            
            UserDefaults.standard.set(passDict, forKey: "PASSDICT")
            
            if txtCountryCode.text! == "" || txtFeildPhoneNumber.text! == ""{
                
                

                
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "VarificationVC") as! VarificationVC
                
                //vc.phoneNumber = phoneNumber
                vc.isComing = "SIGNUPMAIL"
                
              vc.otpString = self.otpString
                
                self.present(vc, animated: true, completion: nil)
                
                  
                
              
                
            }
            else{
                
                
                
                
                var message = ""
                
                if !validation.validateBlankField(txtCountryCode.text!){
                    message = "Please select country code"
                }
                    
                else if !validation.validateBlankField(txtFeildPhoneNumber.text!){
                    message = "Please enter phone number"
                }
                
                
                if message != "" {
                    
                    
                    _ = SweetAlert().showAlert("Escalate", subTitle: message, style: AlertStyle.error)
                    
                }else{
                    
                    
                  
                   //sendOtpUsingFirebase()
                    
                    
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "VarificationVC") as! VarificationVC
                    
                    //vc.phoneNumber = phoneNumber
                    vc.isComing = "SIGNUPMAIL"
                    
                vc.otpString = self.otpString
                    
                    self.present(vc, animated: true, completion: nil)
                    
                    
                }
                
                
                
                
                
                
            }
            
    
            
        }else{
            
            _ = SweetAlert().showAlert("Escalate", subTitle: "No internet connection!", style: AlertStyle.error)
            
        }
        
        
    }
    
    
//    func sendOtpUsingFirebase(){
//
//        let phoneNumber = "\(txtCountryCode.text!)\(txtFeildPhoneNumber.text!)"
//
//        Indicator.shared.showProgressView(self.view)
//
//        PhoneAuthProvider.provider().verifyPhoneNumber(phoneNumber, uiDelegate: nil ) { (verificationID, error) in
//            if let error = error {
//
//                Indicator.shared.hideProgressView()
//                _ = SweetAlert().showAlert("Escalate", subTitle: "Something went wrong!", style: AlertStyle.error)
//                print(error)
//
//                return
//
//            }else{
//                Indicator.shared.hideProgressView()
//                print("Aman")
//                print(verificationID!)
//                UserDefaults.standard.set("\(verificationID!)", forKey: "OtpVerification")
//
//                let vc = self.storyboard?.instantiateViewController(withIdentifier: "VarificationVC") as! VarificationVC
//
//                vc.phoneNumber = phoneNumber
//                vc.isComing = "SIGNUP"
//
//                vc.otpString = self.otpString
//
//                self.present(vc, animated: true, completion: nil)
//            }
//
//        }
//    }
//
    
    
    
    
    //MARK:- ACTIONS
    //MARK:
    
    
    @IBAction func btnTermsAndPrivacyTapped(_ sender: UIButton) {
        if sender.tag == 1{
            let termVC = self.storyboard?.instantiateViewController(withIdentifier: "TermsPrivacyVC") as! TermsPrivacyVC
            termVC.apiKey = "tandccontent"
            self.navigationController?.pushViewController(termVC, animated: true)
        }else{
            let termVC = self.storyboard?.instantiateViewController(withIdentifier: "TermsPrivacyVC") as! TermsPrivacyVC
            termVC.apiKey = "privacypolicycontent"
            self.navigationController?.pushViewController(termVC, animated: true)
        }
        
        
    }
    
    
    
    @IBAction func btnTermsAndConditionTapped(_ sender: UIButton) {
        if sender.tag == 1{
            acceptTermsAndConditionState = !acceptTermsAndConditionState
            imgViewTermsAndCondion.image = acceptTermsAndConditionState ? #imageLiteral(resourceName: "login_tick_slected") : #imageLiteral(resourceName: "login_tick_un") ;
            
            
        }else if sender.tag == 2{
            notificationState = !notificationState
            imgViewNotification.image = notificationState ? #imageLiteral(resourceName: "login_tick_slected") : #imageLiteral(resourceName: "login_tick_un") ;
            
        }
        
        
    }
    
    
    
    @IBAction func btnLoginTapped(_ sender: UIButton) {
        rotationScreen()
    }
    
    @IBAction func btnSignUpTapped(_ sender: UIButton) {
        
        UserDefaults.standard.setValue("SIMPLE", forKey: "ENTERINGFROM")
        
        validationSetup()
        
    }
    
    
    @IBAction func btnEyeTapped(_ sender: Any) {
        
        
        if btnPasswordState ==  false {
            
            txtFeildPassword.isSecureTextEntry = false
            btnPasswordState = true
            
            btnEye.setImage(UIImage(named: "login_selected_eye"), for: .normal)
            
        }else{
            
            txtFeildPassword.isSecureTextEntry = true
            btnPasswordState = false
            
            btnEye.setImage(UIImage(named: "login_unselected_eye"), for: .normal)
            
        }
    }
    
    
    @IBAction func btneyeConfirmPasswordTapped(_ sender: Any) {
        
        if btnConfirmPasswordState ==  false {
            
            
            txtFeildConfirmPassword.isSecureTextEntry = false
            btnConfirmPasswordState = true
            
            btnConfirmPasswordEye.setImage(UIImage(named: "login_selected_eye"), for: .normal)
            
        }else{
            
            txtFeildConfirmPassword.isSecureTextEntry = true
            btnConfirmPasswordState = false
            
            btnConfirmPasswordEye.setImage(UIImage(named: "login_unselected_eye"), for: .normal)
            
        }
    }
    
    
    @IBAction func btnCountryCodeTapped(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "CityListTablVc") as! CityListTablVc
        vc.objeCountryListDelegate = self
        present(vc, animated: true, completion: nil)
    }
    
    

}




extension SignUpVC:selectedCountry{
    
    func loadPlistDataatLoadTime() {
        
        // getting path to GameData.plist
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true) as NSArray
        let documentsDirectory = paths[0] as! NSString
        let path = documentsDirectory.appendingPathComponent("countryList.plist")
        let fileManager = FileManager.default
        //check if file exists
        if(!fileManager.fileExists(atPath: path)) {
            // If it doesn't, copy it from the default file in the Bundle
            if let bundlePath = Bundle.main.path(forResource: "countryList", ofType: "plist") {
                let rootArray = NSMutableArray(contentsOfFile: bundlePath)
                print("Bundle RecentSearch.plist file is --> \(rootArray?.description)")
                do{
                    try fileManager.copyItem(atPath: bundlePath, toPath: path)
                }
                catch _ {
                    print("Fail to copy")
                }
                print("copy")
            } else {
                print("RecentSearch.plist not found. Please, make sure it is part of the bundle.")
            }
        } else {
            print("RecentSearch.plist already exits at path.")
            // use this to delete file from documents directory
            //fileManager.removeItemAtPath(path, error: nil)
        }
        
        let rootarray = NSMutableArray(contentsOfFile: path)
        print("Loaded RecentSearch.plist file is --> \(rootarray?.description)")
        let array = NSMutableArray(contentsOfFile: path)
        print(array as Any) // Array of country code ,name
        if let dict = array {
            
            
            let tempArray = array!
            self.arrayFromPlist = tempArray
            var i = 0
            for index in tempArray{
                
                let dic = tempArray.object(at: i) as? NSDictionary
                i = i+1
                let code = dic?.object(forKey: "country_dialing_code") as? String
                
                let trimSring:String = code!.replacingOccurrences(of: " ", with: "")
                print(trimSring) // country code
                let countryName = dic?.object(forKey: "country_name") as? String
                let codeString = trimSring+" "+countryName!
                
                //   self.countryCodeArray.add(codeString)
                
            }
            
            //  print(self.countryCodeArray)
            
        } else {
            print("WARNING: Couldn't create dictionary from RecentSearch.plist! Default values will be used!")
        }
    }
    
    
    
    
    func countryInformation(info: NSDictionary) {
        
        print(info)
        let code = info.object(forKey: "country_dailing_code") as? String ?? ""
        txtCountryCode.text = code
        txtCountryCode.textColor = UIColor.black
        txtCountryCode.textAlignment = .center
        print(code)
        
    }
}
