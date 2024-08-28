//
//  ChatVC.swift
//  Escalate
//
//  Created by call soft on 20/07/18.
//  Copyright © 2018 call soft. All rights reserved.
//

import UIKit


class ChatVC: UIViewController {
    
    
    
    //MARK:- OUTLETS
    //MARK:
    
    
    @IBOutlet var tblChat: UITableView!
    
    
    //MARK:- VARIABLES
    //MARK:
    
    let WebserviceConnection  = AlmofireWrapper()
    var user_id = ""
    
    var msg_thread_array = NSArray()
    
    //****variables for locations
    
   
    
    var lat = ""
    var log = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
         //self.AccessCurrentLocationuser()
        
         ScreeNNameClass.shareScreenInstance.screenName = "ChatVC"
        
        initialSetup()
        
        // Do any additional setup after loading the view.
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
//    override var prefersStatusBarHidden: Bool {
//        return true
//    }
    
    
  override func viewWillAppear(_ animated: Bool) {
    ScreeNNameClass.shareScreenInstance.screenName = "ChatVC"
       // self.AccessCurrentLocationuser()
    
    initialSetup()
   }
    
    func initialSetup(){
        
        NotificationCenter.default.addObserver(self,
                                               selector:#selector(ChatVC.reloadChatListApi(_:)),
                                               name:NSNotification.Name(rawValue: "MESSAGELISTINGCALL"),
                                               object: nil)
        
        self.tblChat.tableFooterView = UIView()
        
        chatList()
        
       
    }
    
    
  
    
    
    
    //MARK:- WEB SERVICES
    //MARK:
    
    
    @objc func reloadChatListApi(_ notification: Notification){
        
        
        
       chatList()
        
    }

    
    
    func currentLocationAPI() {
        
        
        let infoArray = UserDefaults.standard.value(forKey: "USERINFO") as? NSArray ?? []
        //print(infoArray)
        let infoDict = infoArray.object(at: 0) as? NSDictionary ?? [:]
        
        //print(infoDict)
        
        user_id = infoDict.value(forKey: "user_id") as? String ?? ""
        
        //print(user_id)
        
        
        
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
                    
                    self.tblChat.dataSource = self
                    self.tblChat.delegate = self
                    self.tblChat.reloadData()
                    
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
    
    
    
    func chatList(){
        
        let infoArray = UserDefaults.standard.value(forKey: "USERINFO") as? NSArray ?? []
        //print(infoArray)
        let infoDict = infoArray.object(at: 0) as? NSDictionary ?? [:]
        
        //print(infoDict)
        
        user_id = infoDict.value(forKey: "user_id") as? String ?? ""
        
        //print(user_id)
        
        let token = infoDict.value(forKey: "token") as? String ?? ""
        
        
        if InternetConnection.internetshared.isConnectedToNetwork() {
            
            Indicator.shared.showProgressView(self.view)
            
            
            
            let Passdict = ["token":token,
                            "user_id":"\(user_id)"] as [String : Any]
            
            print(Passdict)
            
            
            
            WebserviceConnection.requestPOSTURL("chatpage", params: Passdict as [String : AnyObject], headers:nil, success: { (responseJson) in
                
                
                
                if responseJson["status"].stringValue == "SUCCESS" {
                    
                    Indicator.shared.hideProgressView()
                    
                    print(responseJson)
                    
                    
                    if self.msg_thread_array.count > 0{
                        
                        let dummyFilterArray = self.msg_thread_array.mutableCopy() as? NSMutableArray ?? []
                        
                        dummyFilterArray.removeAllObjects()
                        
                        self.msg_thread_array = dummyFilterArray.mutableCopy() as? NSArray ?? []
                        
                        
                    }
                    
                      self.msg_thread_array = responseJson["data"].arrayObject as? NSArray ?? []
                    
                    
                    
                    
                    self.currentLocationAPI()
    
                    
                }else{
                    
                    print(responseJson)
                    Indicator.shared.hideProgressView()
                    
                    print("WOW Failure")
                    
               
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
                
                _ = SweetAlert().showAlert("ESCALATE", subTitle: "Something went wrong.Please try again!", style: AlertStyle.error)
                Indicator.shared.hideProgressView()
                
                
            })
            
            
        }else{
            
            _ = SweetAlert().showAlert("ESCALATE", subTitle: "No interter connection!", style: AlertStyle.error)
            Indicator.shared.hideProgressView()
            
        }
        
        
        
    }
    
    
    
    
    
    //DELEGATS FOR LOCATIONS
  
    
    
    
}


//MARK:- EXTENTION TABLE VIEW
//MARK:

extension ChatVC:UITableViewDelegate,UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return msg_thread_array.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        tblChat.register(UINib(nibName: "ChatTableViewCell", bundle: nil), forCellReuseIdentifier: "ChatTableViewCell")
        
        let cell = tblChat.dequeueReusableCell(withIdentifier: "ChatTableViewCell", for: indexPath) as! ChatTableViewCell
        
 
            let messageDict  =  msg_thread_array[indexPath.row] as? NSDictionary ?? [:]
        
            cell.lblNotificationBody.text = messageDict.value(forKey: "fullname") as? String ?? ""
            
            cell.lblTime.text = messageDict.value(forKey: "fftime") as? String ?? ""
            
            let imgString = messageDict.value(forKey: "image") as? String ?? ""
            
            
            cell.imgProfile.sd_setImage(with: URL(string: imgString as? String ?? ""), placeholderImage: UIImage(named: "user_signup"))
            
             return cell
            

        
       
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableViewAutomaticDimension
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if msg_thread_array.count > 0{
            
            let messageDict  =  msg_thread_array[indexPath.row] as? NSDictionary ?? [:]
            
            let sender_id = messageDict.value(forKey: "sender_id") as? String ?? ""
            
            
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "ChatRepliesVC") as! ChatRepliesVC
            
            vc.user_id = sender_id
            
            vc.isComing = "CHATVC"
            
            self.navigationController?.pushViewController(vc, animated: true)
        }else{
            
            print("do noting")
        }
        
    }
    
}

