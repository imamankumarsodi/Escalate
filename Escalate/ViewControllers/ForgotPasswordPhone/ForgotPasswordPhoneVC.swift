//
//  ForgotPasswordPhoneVC.swift
//  Escalate
//
//  Created by abc on 31/07/18.
//  Copyright © 2018 call soft. All rights reserved.
//

import UIKit
import FirebaseAuth

class ForgotPasswordPhoneVC: UIViewController {
    
    
    
    //MARK:- OUTLETS
    //MARK:
    
    @IBOutlet var lblEmail: UILabel!
    
    
    @IBOutlet var viewLineEmail: UIView!
    
    
    @IBOutlet var lblPhone: UILabel!
    
    
    @IBOutlet var viewLinePhone: UIView!
    
    @IBOutlet var imgForgotPassword: UIImageView!
    
    @IBOutlet var txtFeildForgotPassword: UITextField!
    
    
    @IBOutlet weak var txtCountryCode: UITextField!
    
    
    @IBOutlet weak var btnCountryCodeRef: UIButton!
    
    @IBOutlet weak var viewSeprator: UIView!
    
    
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
    
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    
    
    
    func sendOtpUsingFirebase(){
        
        let phoneNumber = "\(txtCountryCode.text!)\(txtFeildForgotPassword.text!)"
        
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
                
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "VarificationVC") as! VarificationVC
                
                vc.phoneNumber = phoneNumber
                
                vc.isComing = "FORGOTPASSWORDPHONE"
                
                self.present(vc, animated: true, completion: nil)
            }
            
        }
    }
    
    
    
    
    //TODO:-WEBSERVICES
    
    
    func getUserIDByNumber() {



        let passDict = ["phone":"\(txtCountryCode.text!)\(txtFeildForgotPassword.text!)"] as! [String : AnyObject]

        print(passDict)

        if InternetConnection.internetshared.isConnectedToNetwork() {

            Indicator.shared.showProgressView(self.view)

            WebserviceConnection.requestPOSTURL("getuseridbynumber", params: passDict as [String : AnyObject], headers:nil, success: { (responseJson) in

                if responseJson["status"].stringValue == "SUCCESS" {

                    Indicator.shared.hideProgressView()

                    print(responseJson["status"])
                    print(responseJson)

                    let dataDict = responseJson["data"].dictionaryObject as? NSDictionary ?? [:]
                    let userID = dataDict.object(forKey: "user_id") as? String ?? ""
                    
                    print(userID)
                    
                    UserDefaults.standard.set(userID, forKey: "USERID")
                    
                    self.sendOtpUsingFirebase()




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
    
    
    
    
    
    func validationSetup()->Void{
        
        var message = ""
        
        //var tempString = txtFeildMail.text ?? ""
        
        if !validation.validateBlankField(txtCountryCode.text!){
            message = "Please select country code"
        }
            
        else if !validation.validateBlankField(txtFeildForgotPassword.text!){
            message = "Please enter phone number"
        }
       
        
        if message != "" {
            
            
            _ = SweetAlert().showAlert("Escalate", subTitle: message, style: AlertStyle.error)
            
        }else{
            
            getUserIDByNumber()

            
            
            
        }
        
        
    }
    
    
    
    
    
    
    //MARK:- ACTIONS
    //MARK:
    
    @IBAction func btnNavigationTapped(_ sender: Any) {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "LogInVC") as! LogInVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    
    @IBAction func btnEmailOrPhoneChoice(_ sender: UIButton) {
        
        tag = sender.tag
        
        if tag == 1{
            
            
            
            
            
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "ForgotPasswordVC") as! ForgotPasswordVC
            
            self.navigationController?.pushViewController(vc, animated: false)
            
            
        }
        else if tag == 2{
            
      //DO NOTHING
            
        }
    }
    
    
    @IBAction func btnForgotPasswordTapped(_ sender: UIButton) {
        
        
        if tag == 1{
            
        }
        else{
            
            validationSetup()
        }
        
    }
    
    
    @IBAction func btnCountryCodeTapped(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "CityListTablVc") as! CityListTablVc
        vc.objeCountryListDelegate = self
        present(vc, animated: true, completion: nil)
    }
    
    
    
}



extension ForgotPasswordPhoneVC:selectedCountry{
    
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

