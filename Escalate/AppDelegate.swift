//
//  AppDelegate.swift
//  Escalate
//
//  Created by call soft on 19/07/18.
//  Copyright © 2018 call soft. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import UserNotifications
import FBSDKCoreKit
import FBSDKLoginKit
import Firebase
import FirebaseAuth
import GoogleSignIn
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate,UNUserNotificationCenterDelegate,GIDSignInDelegate {
    
    var window: UIWindow?
    var countryArray:NSMutableArray = NSMutableArray()
    let alamoFireObj = AlmofireWrapper()
    var recivID = ""
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch
        getCountryList()
    
        FirebaseApp.configure()
        
        //let simulaterToken = "Simulaterwalatokenbb55d44bfc4492bd33aac79afeaee474e92c12138e18b021e2326"
        let simulaterToken = "bb55d44bfc4492bd33aac79afeaee474e92c12138e18b021e2326"
        
        UserDefaults.standard.set(simulaterToken as String, forKey: "devicetoken")
        IQKeyboardManager.sharedManager().enable = true
        IQKeyboardManager.sharedManager().shouldResignOnTouchOutside = true
        registerForRemoteNotification()
        
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
         GIDSignIn.sharedInstance().clientID = "1021276106763-s6ftab0bb8qkkivtf2h7rqg7l3t556a7.apps.googleusercontent.com"
        GIDSignIn.sharedInstance().delegate = self
       
        checkAutoLogin()
        
        return true
    }
    
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let err = error{
            print("Failed to logged in with Google : ",error)
        }
        print("Successfully loggedIn")
        let name = user.profile.name
        print(name)
        guard let idToken = user.authentication.idToken
            else {return}
        guard let accessToken = user.authentication.accessToken
            else {return}
        
    }
    
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        
        if FBSDKApplicationDelegate.sharedInstance().application(
            app,
            open: url as URL!,
            sourceApplication: options[UIApplicationOpenURLOptionsKey.sourceApplication] as? String,
            annotation: options[UIApplicationOpenURLOptionsKey.annotation] as Any
            )
        {
            return true
            
        }
        else if GIDSignIn.sharedInstance().handle(url,
                                                  sourceApplication: options[UIApplicationOpenURLOptionsKey.sourceApplication] as? String,
                                                  annotation: options[UIApplicationOpenURLOptionsKey.annotation]){
            return true
        }
        return true
        
    }
    
    func signIn(signIn: GIDSignIn!, didDisconnectWithUser user:GIDGoogleUser!,
                withError error: NSError!) {
        
    }
    
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        
        
        
        
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        
        
        print("App enters in background.....")
        
        
         NotificationCenter.default.post(name: NSNotification.Name(rawValue: "stopRecordingAndPlaying"), object: nil)
        
        
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
        
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        
        let recieverDataDict:[String: String] = ["receiver_id": self.recivID]
        
        
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "MESSAGELISTINGCALL"), object:nil, userInfo: recieverDataDict)
        
//         NotificationCenter.default.post(name: NSNotification.Name(rawValue: "MESSAGELISTINGCALL"), object:nil, userInfo: nil)
        
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    
    
    //MARK:- DEVICE TOKEN GET HERE
    //MARK:
    
    
    func registerForRemoteNotification() {
        
        if #available(iOS 10.0, *) {
            let center  = UNUserNotificationCenter.current()
            center.delegate = self
            center.requestAuthorization(options: [.sound, .alert, .badge]) { (granted, error) in
                if error == nil{
                    
                    DispatchQueue.main.async {
                        
                        UIApplication.shared.registerForRemoteNotifications()
                    }
                    
                }
            }
        }
        else {
            UIApplication.shared.registerUserNotificationSettings(UIUserNotificationSettings(types: [.sound, .alert, .badge], categories: nil))
            UIApplication.shared.registerForRemoteNotifications()
        }
        
    }
    
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        
        
        let deviceTokenString = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})
        
        UserDefaults.standard.set(deviceTokenString as String, forKey: "devicetoken")
        
        NSLog("Device Token : %@", deviceTokenString)
        
    }
    
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        
        //let simulaterToken = "Simulatorb1e2d3bb55d44bfc4492bd33aac79afeaee474e92c12138e18b021e2326"
        let simulaterToken = "bb55d44bfc4492bd33aac79afeaee474e92c12138e18b021e2326"
        UserDefaults.standard.set(simulaterToken, forKey: "devicetoken")
        print(error, terminator: "")
        
        
    }
    
    
    func checkAutoLogin()
    {
        
        if UserDefaults.standard.bool(forKey: "isLoginSuccessfully") ==  true {
            
            UserDefaults.standard.set(true, forKey: "isCoimngFront")
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            
            let vc = storyboard.instantiateViewController(withIdentifier: "TabBarVC") as! TabBarVC
            
            let nav = UINavigationController(rootViewController: vc)
            nav.isNavigationBarHidden = true
            
            (UIApplication.shared.delegate as! AppDelegate).window?.rootViewController = nav
            
            
            
            
        }else{
            
             UserDefaults.standard.set(false, forKey: "isCoimngFront")

            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            
            let vc = storyboard.instantiateViewController(withIdentifier: "LogInVC") as! LogInVC
            
            let nav = UINavigationController(rootViewController: vc)
            nav.isNavigationBarHidden = true
            
            (UIApplication.shared.delegate as! AppDelegate).window?.rootViewController = nav
            
        }
        
        
        
        

    }
    
    
    
    func getCountryList(){
        
        DispatchQueue.global(qos: .default).async(execute: {() -> Void in
            let list:NSDictionary = CommonMethod.getDictionaryFromXMLFile("country_list_c2call", fileExtension: "xml") as NSDictionary
            
            self.setCountryList(info:list)
            
            
        })
    }
    
    // MARK: read country from xml parser
    
    
    func setCountryList(info:NSDictionary){
        
        let countries: NSDictionary = info.object(forKey: "countries") as! NSDictionary
        let arr_Country: NSArray = countries.object(forKey: "country") as! NSArray
        let arr:NSMutableArray = NSMutableArray()
        
        for i in 0..<arr_Country.count {
            
            let dict:NSDictionary = arr_Country[i] as! NSDictionary
            
            let dictCode = dict.object(forKey: "code") as? NSDictionary
            let text: String = (dictCode?.object(forKey: "text") as? String)!
            let dialing_code: String = text.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
            let country_name: String = (dict.object(forKey: "name") as? String)!
            let country_code: String = (dict.object(forKey: "iso") as? String)!
            let country_dailing_code: String = dialing_code
            let info:NSDictionary = ["country_name":country_name,"country_code":country_code,"country_dailing_code":country_dailing_code]
            arr.add(info)
        }
        let descriptor: NSSortDescriptor =  NSSortDescriptor(key: "country_name", ascending: true, selector: #selector(NSString.caseInsensitiveCompare(_:)))
        let sortedResults: NSArray = (arr.sortedArray(using: [descriptor]) as? NSArray)!
        self.countryArray = NSMutableArray(array: sortedResults)
        //print(self.countryArray)
        
    }
    
    
    //MARK:  UNNOTIFICATION DELGATE METHODS
    
    @available(iOS 10.0, *)
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,  willPresent notification: UNNotification, withCompletionHandler   completionHandler: @escaping (_ options:   UNNotificationPresentationOptions) -> Void) {
        
        
        print("FORE GROUND NOTIFICATION COMES")
        
        let scree_nname  =  ScreeNNameClass.shareScreenInstance.screenName
        
        let userInfo = notification.request.content.userInfo as NSDictionary
        
        print(userInfo)
        
        let apnsDict  =  userInfo.value(forKey: "aps") as! NSDictionary
        
        let badge = apnsDict.value(forKey: "badge") as? Int ?? 0
        
        print(badge)
        
        UserDefaults.standard.set(badge, forKey: "BADGECOUNT")
        
        UIApplication.shared.applicationIconBadgeNumber = badge
        
    
    
        
       if scree_nname == "HomeVC" {
            
        let apnsDict  =  userInfo.value(forKey: "aps") as! NSDictionary
        
        let alert = apnsDict.value(forKey: "alert") as? NSDictionary ?? [:]
        
        let type = alert.value(forKey: "type") as? String ?? ""
        

        print(type)
        print(apnsDict)
        
        if type == "comments" || type == "likes"{
            
            
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "HOMENOTIFYRELOAD"), object:nil, userInfo: nil)
          
            
        }
        
        
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "NOTIFICATION_NOTIFYRELOAD"), object:nil, userInfo: nil)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "MESSAGELISTINGCALL"), object:nil, userInfo: nil)

        
        
         completionHandler([.alert, .badge, .sound])
        
  
        
            
            
        }else if scree_nname == "ChatRepliesVC"{
        
        
        
        let apnsDict  =  userInfo.value(forKey: "aps") as! NSDictionary
        
        let alert = apnsDict.value(forKey: "alert") as? NSDictionary ?? [:]
        
        let type = alert.value(forKey: "type") as? String ?? ""
        
        if type == "chat"{
            
            if  let batchDict = apnsDict.value(forKey: "batch") as? NSDictionary{
            print(batchDict)
                
                
            let receiver_id = batchDict.value(forKey: "receiver_id") as? String ?? ""
                
                
                
                self.recivID = receiver_id
              let receiver_idOnChatScree  =  ScreeNNameClass.shareScreenInstance.receiver_id
                
                print(receiver_id)
                
                print(receiver_idOnChatScree)
                
                
                let recieverDataDict:[String: String] = ["receiver_id": receiver_id]
                
                if receiver_idOnChatScree == receiver_id{
                    
                      NotificationCenter.default.post(name: NSNotification.Name(rawValue: "MESSAGELISTINGCALL"), object:nil, userInfo: recieverDataDict)
                }
                else{
                    
                    completionHandler([.alert, .badge, .sound])
                    
                }
                
                
            
            }
            
            
            
        }else{
            
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "NOTIFICATION_NOTIFYRELOAD"), object:nil, userInfo: nil)
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "HOMENOTIFYRELOAD"), object:nil, userInfo: nil)
            
            completionHandler([.alert, .badge, .sound])
        }
        
            
        }else if scree_nname == "ChatVC"{
        
        
        let apnsDict  =  userInfo.value(forKey: "aps") as! NSDictionary
        
        let alert = apnsDict.value(forKey: "alert") as? NSDictionary ?? [:]
        
        let type = alert.value(forKey: "type") as? String ?? ""
        
        if type == "chat"{
           
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "MESSAGELISTINGCALL"), object:nil, userInfo: nil)
            
            
            
        }else{
            
             NotificationCenter.default.post(name: NSNotification.Name(rawValue: "NOTIFICATION_NOTIFYRELOAD"), object:nil, userInfo: nil)
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "HOMENOTIFYRELOAD"), object:nil, userInfo: nil)
            
            completionHandler([.alert, .badge, .sound])
        }
            
        
            
       }else if scree_nname == "NotificationsVC"{
        
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "NOTIFICATION_NOTIFYRELOAD"), object:nil, userInfo: nil)
        
       
        
       }else{
        
        
        let apnsDict  =  userInfo.value(forKey: "aps") as! NSDictionary
        
        let alert = apnsDict.value(forKey: "alert") as? NSDictionary ?? [:]
        
        let type = alert.value(forKey: "type") as? String ?? ""
        print(type)
        completionHandler([.alert, .badge, .sound])
        }
    }
    
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        print("BACK GROUND NOTIFICATION COMES")
        let userInfo = response.notification.request.content.userInfo as? NSDictionary ?? [:]
        print(userInfo)
        let apnsDict  =  userInfo.value(forKey: "aps") as? NSDictionary ?? [:]
        let alert = apnsDict.value(forKey: "alert") as? NSDictionary ?? [:]
        let badge = apnsDict.value(forKey: "badge") as? Int ?? 0
        print(badge)
        UserDefaults.standard.set(badge, forKey: "BADGECOUNT")
        UIApplication.shared.applicationIconBadgeNumber = badge
        let type = alert.value(forKey: "type") as? String ?? ""
        print("\(String(describing: userInfo))")
        if UserDefaults.standard.bool(forKey: "isLoginSuccessfully") ==  true {
            
            if let apsDict = userInfo.value(forKey: "aps") as? NSDictionary{
                guard let badgeCount = apsDict.value(forKey: "badge") as? Int else{
                    print("No badgeCount")
                    return
                }
                if let alertDict = apsDict.value(forKey: "alert") as? NSDictionary{
                    if let thread_id = apsDict.value(forKey: "thread_id") as? Int{
                        print(thread_id)
                        self.decreaseBadgeCountApi(thread_id, alertDict, apsDict)
                        
                    }
                }
            }
            

            
        }else{
            
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            
            let destinationController = storyboard.instantiateViewController(withIdentifier: "LogInVC") as? LogInVC
            let navController = UINavigationController(rootViewController: destinationController!)
            navController.navigationBar.isHidden = true
            self.window!.rootViewController = navController
            
        }
        
    }
   
}



//MARK: - Extension web services implementations

extension AppDelegate{
    
    //TODO: Decrease badge count api
    func decreaseBadgeCountApi(_ thread_id : Int, _ alertDict : NSDictionary, _ apsDict : NSDictionary){
        if InternetConnection.internetshared.isConnectedToNetwork(){
            // macroObj.showLoader(view: view)
            alamoFireObj.requestGETURL("notify_count/\(thread_id)", success: { (responseJASON) in
                // self.macroObj.hideLoader(view: self.view)
                if responseJASON["status"].string == "SUCCESS"{
                    print(responseJASON)
                    if let responseDict = responseJASON["data"].dictionaryObject as NSDictionary?{
                        
                        guard let badge = responseDict.value(forKey: "badge") as? Int else{
                            print("No badge")
                            return
                        }
                        UIApplication.shared.applicationIconBadgeNumber = badge





                        if let type = alertDict.value(forKey: "type") as? String{
                            if type == "comments" || type == "likes"{
                                if  let batchDict = apsDict.value(forKey: "batch") as? NSDictionary{
                                    print(batchDict)
                                    let fullname = batchDict.value(forKey: "fullname") as? String ?? ""
                                    let audioID = batchDict.value(forKey: "audio_id") as? String ?? ""
                                    let user_id = batchDict.value(forKey: "user_id") as? String ?? ""
                                    let user_image = batchDict.value(forKey: "user_image") as? String ?? ""
                                    let tag_list = batchDict.value(forKey: "tag_list") as? String ?? ""
                                    let audio_url = batchDict.value(forKey: "audio_url") as? String ?? ""
                                    let duration = batchDict.value(forKey: "duration") as? String ?? ""
                                    let description_post = batchDict.value(forKey: "description_post") as? String ?? ""
                                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                                    let destinationController = storyboard.instantiateViewController(withIdentifier: "CommentsWithPostVC") as? CommentsWithPostVC
                                    destinationController?.audioID = audioID
                                    destinationController?.user_image = user_image
                                    destinationController?.fullname = fullname
                                    destinationController?.tag_list = tag_list
                                    destinationController?.audio_url = audio_url
                                    destinationController?.duration = duration
                                    destinationController?.descriptionPost = description_post
                                    destinationController?.isComing = "NOTI"
                                    let navController = UINavigationController(rootViewController: destinationController!)
                                    navController.navigationBar.isHidden = true
                                    self.window!.rootViewController = navController

                                }

                            }else if type == "chat"{
                                if  let batchDict = apsDict.value(forKey: "batch") as? NSDictionary{
                                    print(batchDict)

                                    let receiver_id = batchDict.value(forKey: "receiver_id") as? String ?? ""


                                    self.recivID = receiver_id

                                    let receiver_idOnChatScree  =  ScreeNNameClass.shareScreenInstance.receiver_id

                                    print(receiver_id)

                                    print(receiver_idOnChatScree)


                                    let recieverDataDict:[String: String] = ["receiver_id": receiver_id]


                                    let storyboard = UIStoryboard(name: "Main", bundle: nil)

                                    let destinationController = storyboard.instantiateViewController(withIdentifier: "ChatRepliesVC") as? ChatRepliesVC

                                    destinationController?.user_id = receiver_id
                                    let navController = UINavigationController(rootViewController: destinationController!)
                                    navController.navigationBar.isHidden = true
                                    self.window!.rootViewController = navController

                                }

                            }else if type == "follow"{
                                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                                let destinationController = storyboard.instantiateViewController(withIdentifier: "TabBarVC") as? TabBarVC
                                let navController = UINavigationController(rootViewController: destinationController!)
                                navController.navigationBar.isHidden = true
                                destinationController?.selectedIndex = 4
                                UserDefaults.standard.set("NOTI", forKey: "ISCOMING")
                                self.window!.rootViewController = navController
                                self.window!.makeKeyAndVisible()



                            }else{
                                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                                let destinationController = storyboard.instantiateViewController(withIdentifier: "NotificationsVC") as? NotificationsVC
                                destinationController?.isComing = "NOTI"
                                let navController = UINavigationController(rootViewController: destinationController!)
                                navController.navigationBar.isHidden = true
                                self.window!.rootViewController = navController


                            }

                        }else{

                            // Do nothing

                        }


                    }
                }else{
                    // self.macroObj.hideLoader(view: self.view)
                    //                    if let message = responseJASON["message"].string as? String{
                    //                        _ = SweetAlert().showAlert(self.macroObj.appName, subTitle: message, style: AlertStyle.error)
                    //                    }
                    
                }
                
                
            }, failure: { (error) in
                //self.macroObj.hideLoader(view: self.view)
                print(error.localizedDescription)
                //  _ = SweetAlert().showAlert(self.macroObj.appName, subTitle: MacrosForAll.ERRORMESSAGE.ErrorMessage.rawValue, style: AlertStyle.error)
            })
            
        }else{
            // self.macroObj.hideLoader(view: self.view)
            //  _ = SweetAlert().showAlert(macroObj.appName, subTitle: MacrosForAll.ERRORMESSAGE.NoInternet.rawValue, style: AlertStyle.error)
        }
    }
}

