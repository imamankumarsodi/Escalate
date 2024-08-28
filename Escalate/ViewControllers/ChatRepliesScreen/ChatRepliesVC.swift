//
//  ChatRepliesVC.swift
//  Escalate
//
//  Created by call soft on 20/07/18.
//  Copyright © 2018 call soft. All rights reserved.
//

import UIKit
import AVFoundation
import Pulsator
import SDWebImage
import Firebase
import SwiftSiriWaveformView


class ChatRepliesVC: UIViewController,AVAudioRecorderDelegate, AVAudioPlayerDelegate {
    
    
    
    //MARK:- OUTLETS
    //NARK:
    
    @IBOutlet weak var sourceView: UIView!
   
    @IBOutlet var record_btn_ref: UIButton!
    @IBOutlet var lblRecordingTime: UILabel!
    
    @IBOutlet weak var imgProfilePic: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var tblChat: UITableView!
    
    
    @IBOutlet weak var btnSendMessageRef: UIButton!
    
    
    
    
    @IBOutlet weak var btnPlayRecording: UIButton!
    
    
    @IBOutlet weak var btnCancelTapped: UIButton!
    
    @IBOutlet weak var audioView: SwiftSiriWaveformView!
    
    
    //MARK:- VARIABLES
    //MARK:
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var audioUrl: URL!
    var audioRecorder: AVAudioRecorder!
    var audioPlayer : AVAudioPlayer!
    var meterTimer:Timer!
    var isAudioRecordingGranted: Bool!
    var isRecording = false
    var isPlaying = false
    let pulsator = Pulsator()
    
    var user_id=""
    
    let WebserviceConnection  = AlmofireWrapper()
    
    var count = 0
    
    var timerCountCA:Timer?
    
    var timerCA:Timer?
    
    var change:CGFloat = 0.01
    
    
    //VARIABLES FOR FIREBASE CHAT
    
//    var chatRoom1  = ""
//    var chatRoom2 = ""
//    var currentChatRoom = ""
    
    
    var isComing = ""
    
    var recieverID = ""
    
    var audioDownloadURL = ""
    
    
    var durationForApi = ""
    
    var messageArray = [MessageDataModel]()
    
    
    //******Variables for 40 timer
    
    var countLimit = 39
    
    var timerLimit:Timer?
    
    
    
    
    //********Variables for tableview
    
    var timerCR:Timer?
    
    
    
    var timerCRA:Timer?
    
    var timerCountCRA:Timer?
    
    
    var timerCountCR:Timer?
    
    
    var isPlaying1 = false
    
    
    var audioUrl1: URL!
    
    
    var change1:CGFloat = 0.01
    
    
    var hr1 = 0
    var min1 = 0
    var sec1 = 0
    
    var player1:AVPlayer?
    var playerItem1:AVPlayerItem?
    
    var count1 = 0
    
    var hr = 0
    var min = 0
    var sec = 0
    
    
    
    
    var audioData = Data()
    var audioUrlForApi: URL!
    
    
    var msg_thread_array = NSArray()
    
    var btnPlayPauseTappedBool = false
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ScreeNNameClass.shareScreenInstance.screenName = "ChatRepliesVC"
        
        ScreeNNameClass.shareScreenInstance.receiver_id = user_id
        initialSetUp()
        
        NotificationCenter.default.addObserver(self,
                                               selector:#selector(ChatRepliesVC.reloadChatListApi(_:)),
                                               name:NSNotification.Name(rawValue: "MESSAGELISTINGCALL"),
                                               object: nil)
        
        // Do any additional setup after loading the view.
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    override func viewWillAppear(_ animated: Bool) {
        
        ScreeNNameClass.shareScreenInstance.screenName = "ChatRepliesVC"
        
        ScreeNNameClass.shareScreenInstance.receiver_id = user_id
        
        UserDefaults.standard.removeObject(forKey: "CRBTNTAG")
         UserDefaults.standard.removeObject(forKey: "CRPBTNTAG")
        viewProfile()
    }
    
    
    
    
    
    func initialSetUp(){
        
    ScreeNNameClass.shareScreenInstance.screenName = "ChatRepliesVC"
        
    NotificationCenter.default.addObserver(self, selector: #selector(ChatRepliesVC.stopRecordingAndPlaying(_:)), name: NSNotification.Name(rawValue: "stopRecordingAndPlaying"), object: nil)
        
   
        
        viewProfile()
        

        
    }
    
    
    @objc func reloadChatListApi(_ notification: Notification){
        
        print(notification.userInfo ?? "")
        if let dict = notification.userInfo as NSDictionary? {
           
             let id = dict["receiver_id"] as? String ?? ""
                
               let idString = "\(id)"
                
               self.user_id = idString
                
                viewProfile()
        }

    }

    
    func addHalo() {
        
        pulsator.position = .init(x: 75, y: 37.5)
        pulsator.numPulse = 5
        pulsator.radius = 40
        
        pulsator.animationDuration = 3
        pulsator.backgroundColor = UIColor.white.cgColor
        sourceView.layer.addSublayer(pulsator)
        pulsator.start()
    }
    
    
    
    
    
    //MARK: RETRIEVE FIREBASE MESSAGE
    //MARK:-
    
    
    func scrollToBottom(){
        
        
        if msg_thread_array.count > 0{
            
            DispatchQueue.main.async {
                let indexPath = IndexPath(row: self.msg_thread_array.count-1, section: 0)
                self.tblChat.scrollToRow(at: indexPath, at: .bottom, animated: true)
                // self.stopAnimating()
            }
        }
        
    }
    
    
    
//    func retrieveMessages(){
//
//
//
//
//        print(chatRoom1)
//        print(chatRoom2)
//
//
//        let path = Database.database().reference().child("Messages")
//
//        print(path)
//
//        path.observeSingleEvent(of: .value) { (snapshot) in
//            if snapshot.hasChild(self.chatRoom1){
//                self.currentChatRoom = self.chatRoom1
//                let messageRef = Database.database().reference().child("Messages").child(self.currentChatRoom)
//                messageRef.observe(.childAdded, with: { snapshot in
//
//                    if let messageDict = snapshot.value as? [String:Any]{
//
//                        print(messageDict)
//                        let message = MessageDataModel()
//
//                        message.time = messageDict["time"] as? String ?? ""
//                        message.senderId = messageDict["senderId"] as? String ?? ""
//                        message.receiverId = messageDict["receiverId"] as? String ?? ""
//                        message.audioUrl = messageDict["audioUrl"] as? String ?? ""
//                        message.mssgDuration = messageDict["mssgDuration"] as? String ?? ""
//                        message.type = messageDict["type"] as? String ?? ""
//
//                        self.messageArray.append(message)
//
//
//                        print(self.messageArray.count)
//
//                        self.tblChat.dataSource = self
//                        self.tblChat.delegate = self
//
//
//
//                        self.tblChat.reloadData()
//                        self.scrollToBottom()
//
//                    }
//                })
//
//
//            }else if snapshot.hasChild(self.chatRoom2){
//                self.currentChatRoom = self.chatRoom2
//                let messageRef = Database.database().reference().child("Messages").child(self.currentChatRoom)
//
//                messageRef.observe(.childAdded, with: { snapshot in
//
//
//                    if let messageDict = snapshot.value as? [String:Any]{
//
//                        print(messageDict)
//                        let message = MessageDataModel()
//
//                        message.time = messageDict["time"] as? String ?? ""
//                        message.senderId = messageDict["senderId"] as? String ?? ""
//                        message.receiverId = messageDict["receiverId"] as? String ?? ""
//                        message.audioUrl = messageDict["audioUrl"] as? String ?? ""
//                        message.mssgDuration = messageDict["mssgDuration"] as? String ?? ""
//                        message.type = messageDict["type"] as? String ?? ""
//
//                        self.messageArray.append(message)
//
//
//                        print(self.messageArray.count)
//
//                        self.tblChat.dataSource = self
//                        self.tblChat.delegate = self
//
//
//
//                        self.tblChat.reloadData()
//                        self.scrollToBottom()
//                    }
//
//
//                })
//
//            }
//        }
//
//
//
//        print(messageArray)
//
//    }
//
//
    
    
    
    
    
    //MARK:- METHODS WEB SERVICES
    //MARK:
    
    
    @objc func updateAudioMeter(timer: Timer)
    {
        if audioRecorder.isRecording
        {
            let hr = Int((audioRecorder.currentTime / 60) / 60)
            let min = Int(audioRecorder.currentTime / 60)
            let sec = Int(audioRecorder.currentTime.truncatingRemainder(dividingBy: 60))
            let totalTimeString = String(format: "%02d:%02d", min, sec)
            record_btn_ref.setTitle("\(totalTimeString)", for: .normal)
            audioRecorder.updateMeters()
        }
    }
    
    
    func getMessagesAPI() {
        
        
        let infoArray = UserDefaults.standard.value(forKey: "USERINFO") as? NSArray ?? []
        print(infoArray)
        let infoDict = infoArray.object(at: 0) as? NSDictionary ?? [:]
        
        print(infoDict)
        
        let user_id = infoDict.value(forKey: "user_id") as? String ?? ""
        
        print(user_id)
        
        let token = infoDict.value(forKey: "token") as? String ?? ""
        
        
        
        
        //        sender_id:required
        //        receiver_id:required
        //        token:required
        
        let passDict = ["receiver_id":user_id,
                        "sender_id":self.user_id,
                        "token":token] as! [String : AnyObject]
        
        print(passDict)
        
        if InternetConnection.internetshared.isConnectedToNetwork() {
            
            Indicator.shared.showProgressView(self.view)
            
            WebserviceConnection.requestPOSTURL("getmsg", params: passDict as [String : AnyObject], headers:nil, success: { (responseJson) in
                
                if responseJson["status"].stringValue == "SUCCESS" {
                    
                    Indicator.shared.hideProgressView()
                    
                    print(responseJson["status"])
                    print(responseJson)
                    
                    
                    
                    
                    if self.msg_thread_array.count > 0{
                        
                        let dummyFilterArray = self.msg_thread_array.mutableCopy() as? NSMutableArray ?? []
                        
                        dummyFilterArray.removeAllObjects()
                        
                        self.msg_thread_array = dummyFilterArray.mutableCopy() as? NSArray ?? []
                        
                        
                    }
                    
                    
                    
                    self.stopPlayingMusic()
                    self.stopTableAudio()
                    
                    
                    
                    self.btnPlayRecording.isHidden = true
                    self.audioView.isHidden = true
                    self.btnSendMessageRef.isHidden = true
                    self.btnCancelTapped.isHidden = true
                    
                    self.record_btn_ref.isHidden = false
                    self.sourceView.isHidden = false
                    self.lblRecordingTime.isHidden = true
                    self.btnPlayRecording.setImage(UIImage(named: "chat_message_play_white"),for: .normal)
                    
                    if self.msg_thread_array.count == 0{
                        
                        self.record_btn_ref.setTitle("", for: .normal)
                    }else{
                        self.record_btn_ref.setTitle(" Reply", for: .normal)
                    }
                    
                    
                    self.check_record_permission()
                    
                    
                    let responseDict = responseJson["data"].dictionaryObject as? NSDictionary ?? [:]
                    
                    self.msg_thread_array = responseDict.value(forKey: "msg_thread") as? NSArray ?? []
                    
                    
                    if self.msg_thread_array.count == 0{
                        
                        self.record_btn_ref.setTitle("", for: .normal)
                        
                    }else{
                        
                        self.record_btn_ref.setTitle(" Reply", for: .normal)
                    }
                    
                    self.tblChat.dataSource = self
                    self.tblChat.delegate = self
                    
                    
                    
                    self.tblChat.reloadData()
                    self.scrollToBottom()
                    
                    
                    
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
    
    
    func getMessagesNotificationAPI() {
        
        
        let infoArray = UserDefaults.standard.value(forKey: "USERINFO") as? NSArray ?? []
        print(infoArray)
        let infoDict = infoArray.object(at: 0) as? NSDictionary ?? [:]
        
        print(infoDict)
        
        let user_id = infoDict.value(forKey: "user_id") as? String ?? ""
        
        print(user_id)
        
        let token = infoDict.value(forKey: "token") as? String ?? ""
        
        
        
        
        //        sender_id:required
        //        receiver_id:required
        //        token:required
        
        let passDict = ["receiver_id":user_id,
                        "sender_id":self.user_id,
                        "token":token] as! [String : AnyObject]
        
        print(passDict)
        
        if InternetConnection.internetshared.isConnectedToNetwork() {
            
            Indicator.shared.showProgressView(self.view)
            
            WebserviceConnection.requestPOSTURL("getmsg", params: passDict as [String : AnyObject], headers:nil, success: { (responseJson) in
                
                if responseJson["status"].stringValue == "SUCCESS" {
                    
                    Indicator.shared.hideProgressView()
                    
                    print(responseJson["status"])
                    print(responseJson)
                    
                    
                    
                    
                    if self.msg_thread_array.count > 0{
                        
                        let dummyFilterArray = self.msg_thread_array.mutableCopy() as? NSMutableArray ?? []
                        
                        dummyFilterArray.removeAllObjects()
                        
                        self.msg_thread_array = dummyFilterArray.mutableCopy() as? NSArray ?? []
                        
                        
                    }
                    
                    
                    
                    self.stopPlayingMusic()
                    self.stopTableAudio()
                    
                    
                    
                    self.btnPlayRecording.isHidden = true
                    self.audioView.isHidden = true
                    self.btnSendMessageRef.isHidden = true
                    self.btnCancelTapped.isHidden = true
                    
                    self.record_btn_ref.isHidden = false
                    self.sourceView.isHidden = false
                    self.lblRecordingTime.isHidden = true
                    self.btnPlayRecording.setImage(UIImage(named: "chat_message_play_white"),for: .normal)
                    
                    if self.msg_thread_array.count == 0{
                        
                        self.record_btn_ref.setTitle("", for: .normal)
                    }else{
                        self.record_btn_ref.setTitle(" Reply", for: .normal)
                    }
                    
                    
                    self.check_record_permission()
                    
                    
                    let responseDict = responseJson["data"].dictionaryObject as? NSDictionary ?? [:]
                    
                    self.msg_thread_array = responseDict.value(forKey: "msg_thread") as? NSArray ?? []
                    
                    
                    if self.msg_thread_array.count == 0{
                        
                        self.record_btn_ref.setTitle("", for: .normal)
                        
                    }else{
                        
                        self.record_btn_ref.setTitle(" Reply", for: .normal)
                    }
                    
                    self.tblChat.dataSource = self
                    self.tblChat.delegate = self
                    
                    
                    
                    self.tblChat.reloadData()
                    self.scrollToBottom()
                    
                    
                    
                }else{
                    
                   
                    Indicator.shared.hideProgressView()
                   
                    
                }
                
                
            },failure: { (Error) in
                Indicator.shared.hideProgressView()
               
                self.dismiss(animated: true, completion: nil)
                
                
            })
            
            
        }else{
            
        
            
            
        }
        
        
        
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    func sendMessages(){
        
        
        stopPlayingMusic()
        stopTableAudio()
        
        let infoArray = UserDefaults.standard.value(forKey: "USERINFO") as? NSArray ?? []
        //print(infoArray)
        let infoDict = infoArray.object(at: 0) as? NSDictionary ?? [:]
        
        //print(infoDict)
        
        let token = infoDict.value(forKey: "token") as? String ?? ""
        
        print(token)
        
        let user_id = infoDict.value(forKey: "user_id") as? String ?? ""
        
        print(user_id)
        
        
        
        let asset = AVAsset(url: audioUrlForApi)
        
        let duration = asset.duration
        let durationTime = Int(round(CMTimeGetSeconds(duration)))
        
        print(durationTime)
        
        let hours = durationTime/3600
        
        let minutes = durationTime / 60 % 60
        
        let seconds = durationTime % 60
        
        
        print("\(hours),\(minutes) and \(seconds)")
        
        var secondString = String()
        
        var minuteString = String()
        
        var hourString = String()
        
        if seconds<10{
            
            secondString = "0\(seconds)"
            
        }else{
            
            secondString = "\(seconds)"
        }
        
        if minutes<10{
            
            minuteString = "0\(minutes)"
            
        }else{
            
            minuteString = "\(minutes)"
        }
        
        
        if hours<10{
            
            hourString = "0\(hours)"
            
        }else{
            
            hourString = "\(hours)"
        }
        
        
        
        durationForApi = "\(minuteString):\(secondString)"
        
        print(durationForApi)
        
        
        
        
        
        
        
        do {
            
            self.audioData = try Data(contentsOf: audioUrlForApi)
            print("AUDIO DATA")
            print(self.audioData)
            print("AUDIO DATA")
            
        } catch {
            
            print("Unable to load data: \(error)")
            
        }
        
        
        
        let passDict = ["sender_id":user_id,
                        "message_duration":durationForApi,
                        "token":token,
                        "receiver_id":self.user_id] as [String : AnyObject]
        
        print(passDict)
        
        if InternetConnection.internetshared.isConnectedToNetwork() {
            
            Indicator.shared.showProgressView(self.view)
            
            
            WebserviceConnection.requWithAudioFile(audioData: audioData as NSData, fileName: "recording.mp3", audioparam: "msg", urlString: "sendmessage", parameters: passDict, headers: nil, success:{ (responseJson) in
                
                
                if responseJson["status"].stringValue == "SUCCESS" {
                    
                    Indicator.shared.hideProgressView()
                    
                    print(responseJson["status"])
                    print(responseJson)
                    
                    self.getMessagesAPI()
                    
                    
                }else{
                    
                    print(responseJson)
                    Indicator.shared.hideProgressView()
                    
                    print("WOW Failure")
                    
                    let message  = responseJson["message"].stringValue as? String ?? ""
                    
                    _ = SweetAlert().showAlert("Escalate", subTitle: message, style: AlertStyle.error)
                    
                    if message == "Login Token Expire"{
                        
                        
                        
                        self.navigationController!.popToRootViewController(animated: true)
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
    
    
    
    
    
    
    
    
    
    
    
    //MARK: SENDING  MESSAGE THROUGH FIREBASE
    //MARK:-
    
    
    
    func stopTableAudio(){
        
        
       // if btnPlayPauseTappedBool == true{
            
            
            let btnTag = UserDefaults.standard.value(forKey: "CRBTNTAG") as? Int ?? 0
            
            print(btnTag)
            
            if msg_thread_array.count > 0{
                
                let messageDict  =  msg_thread_array[btnTag] as? NSDictionary ?? [:]
                
                let senderFlag = messageDict.value(forKey: "flag") as? String ?? ""
                
                
                if(isPlaying1)
                {
                    
                    let messageDict  =  msg_thread_array[btnTag] as? NSDictionary ?? [:]
                    
                    let senderFlag = messageDict.value(forKey: "flag") as? String ?? ""
                    
                    if senderFlag == "1"{
                        
                        
                        let indexPath = IndexPath(row: btnTag, section: 0)
                        guard let prevCell = tblChat.cellForRow(at: indexPath) as? ChatMessageCombineCellAndXib else {
                            
                            return
                        }
                        
                        player1!.pause()
                        timerCountCRA?.invalidate()
                        timerCountCRA = nil
                        timerCRA?.invalidate()
                        timerCRA = nil
                        sec1 = 0
                        hr1 = 0
                        min1 = 0
                        
                        prevCell.btnPlayPausedRefP.setImage(#imageLiteral(resourceName: "chat_message_play_white"), for: .normal)
                        prevCell.audioViewP.amplitude = 0.0
                        
                        let totalTimeString = messageDict.value(forKey: "message_duration") as? String ?? ""
                        prevCell.lblTotalTimerP.text = totalTimeString
                        
                        isPlaying1 = false
                        
                        
                        
                    }else{
                        
                        print(isPlaying1)
                        let indexPath = IndexPath(row: btnTag, section: 0)
                        guard let prevCell = tblChat.cellForRow(at: indexPath) as? ChatMessageCombineCellAndXib else {
                            
                            return
                        }
                        
                        
                        player1!.pause()
                        timerCountCRA?.invalidate()
                        timerCountCRA = nil
                        timerCRA?.invalidate()
                        timerCRA = nil
                        sec1 = 0
                        hr1 = 0
                        min1 = 0
                        
                        prevCell.btnPlayPausedRefW.setImage(#imageLiteral(resourceName: "chat_message_play_pur"), for: .normal)
                        prevCell.audioViewW.amplitude = 0.0
                        
                        let totalTimeString = messageDict.value(forKey: "message_duration") as? String ?? ""
                        prevCell.lblTotalTimerW.text = totalTimeString
                        
                        isPlaying1 = false
                        
                        
                    }
                    
                    
                    
                    print(isPlaying1)
                    
                }
                
            }
            
        //}
        
    }
    
    
    
    func stopRecording(){
        
        
        if(isRecording)
        {
            print("TIMERCOUNT")
            print(countLimit)
            timerLimit?.invalidate()
            timerLimit = nil
            
            countLimit = 39
     
            pulsator.stop()
            finishAudioRecording(success: true)
            isRecording = false
            
            btnPlayRecording.isHidden = false
            audioView.isHidden = false
            btnSendMessageRef.isHidden = false
            btnCancelTapped.isHidden = false
            
            record_btn_ref.isHidden = true
            sourceView.isHidden = true
            
            if self.msg_thread_array.count == 0{
                
                self.record_btn_ref.setTitle("", for: .normal)
            }else{
                self.record_btn_ref.setTitle(" Reply", for: .normal)
            }
            
            
            
            
        }
        
        
    }
    
    
    
    
    
    func stopPlayingMusic(){
        
        
        if(isPlaying)
        {
            audioPlayer.stop()
            record_btn_ref.isEnabled = true
            isPlaying = false
            
            timerCountCA?.invalidate()
            timerCountCA = nil
            timerCA?.invalidate()
            timerCA = nil
            btnPlayRecording.setImage(UIImage(named: "chat_message_play_white"),for: .normal)
            audioView.amplitude = 0.0
            lblRecordingTime.isHidden = false
            
            
            
        }
        
        
    }
    
    
    
    func getCurrentTime()-> String{
        
        let formatter = DateFormatter()
        formatter.dateFormat = "hh:mm a"
        print("Current date: \(formatter.string(from: Date()))")
        let time = formatter.string(from: Date())
        return time
        
    }
    
    
//    func sendMessage(time:String,senderId:String,receiverId:String,audioUrl:String,mssgDuration:String){
//
//        let path = Database.database().reference().child("Messages")
//
//        print(path)
//
//        path.observeSingleEvent(of: .value) { (snapshot) in
//            if snapshot.hasChild(self.chatRoom1){
//                self.currentChatRoom = self.chatRoom1
//                let messageRef = Database.database().reference().child("Messages").child(self.currentChatRoom)
//                let childRef = messageRef.childByAutoId()
//
//                let values = ["time":time,
//                              "senderId":senderId,
//                              "receiverId":receiverId,
//                              "audioUrl":self.audioDownloadURL,
//                              "mssgDuration":mssgDuration,
//                              "type":".m4a"] as [String : Any]
//
//                print(values)
//
//                childRef.updateChildValues(values)
//
//
//
//            }else if snapshot.hasChild(self.chatRoom2){
//                self.currentChatRoom = self.chatRoom2
//                let messageRef = Database.database().reference().child("Messages").child(self.currentChatRoom)
//                let childRef = messageRef.childByAutoId()
//
//                let values = ["time":time,
//                              "senderId":senderId,
//                              "receiverId":receiverId,
//                              "audioUrl":self.audioDownloadURL,
//                              "mssgDuration":mssgDuration,
//                              "type":".m4a"] as [String : Any]
//
//                print(values)
//
//                childRef.updateChildValues(values)
//
//
//
//            }else{
//                self.currentChatRoom = self.chatRoom1
//                let messageRef = Database.database().reference().child("Messages").child(self.currentChatRoom)
//                let childRef = messageRef.childByAutoId()
//                let values = ["time":time,
//                              "senderId":senderId,
//                              "receiverId":receiverId,
//                              "audioUrl":self.audioDownloadURL,
//                              "mssgDuration":mssgDuration,
//                              "type":".m4a"] as [String : Any]
//
//                print(values)
//
//                childRef.updateChildValues(values)
//                self.retrieveMessages()
//
//            }
//        }
//
//
//
//    }
//
    
    
    
    
    
//    
//    func sendRecordedMessage(){
//        
//        print(durationForApi)
//        
//        let audioName = NSUUID().uuidString
//        let audioUploadRef = Storage.storage().reference().child("all_files").child("\(audioName).m4a")
//        print(audioUploadRef)
//        
//        do{
//            
//            let audioData = try Data(contentsOf: getFileUrl() as URL)
//            
//            print(getFileUrl() as URL)
//            
//            
//            
//            
//            
//            
//            let asset = AVAsset(url: getFileUrl())
//            
//            let duration = asset.duration
//            let durationTime = Int(floor(CMTimeGetSeconds(duration)))
//            
//            print(durationTime)
//            
//            let hours = durationTime/3600
//            
//            let minutes = durationTime / 60 % 60
//            
//            let seconds = durationTime % 60
//            
//            
//            print("\(hours),\(minutes) and \(seconds)")
//            
//            var secondString = String()
//            
//            var minuteString = String()
//            
//            var hourString = String()
//            
//            if seconds<10{
//                
//                secondString = "0\(seconds)"
//                
//            }else{
//                
//                secondString = "\(seconds)"
//            }
//            
//            if minutes<10{
//                
//                minuteString = "0\(minutes)"
//                
//            }else{
//                
//                minuteString = "\(minutes)"
//            }
//            
//            
//            if hours<10{
//                
//                hourString = "0\(hours)"
//                
//            }else{
//                
//                hourString = "\(hours)"
//            }
//            
//            
//            
//            self.durationForApi = "\(hourString):\(minuteString):\(secondString)"
//            
//            
//            
//            
//            
//            
//            audioUploadRef.putFile(from: getFileUrl() as URL, metadata: nil, completion: { (metadata, error) in
//                if error != nil  {
//                    print(error as Any)
//                }
//                    
//                else{
//                    
//                    print("uploded successfully")
//                    let size = metadata?.size
//                    print(size)
//                    
//                    audioUploadRef.downloadURL(completion: { (url, error) in
//                        guard let downloadURL = url else {
//                            // Uh-oh, an error occurred!
//                            return
//                        }
//                        
//                        print(downloadURL)
//                        
//                        self.audioDownloadURL = "\(downloadURL)"
//                        
//                        let currentFireBaseID = Auth.auth().currentUser?.uid  // personLogin Firebase ID
//                        print(currentFireBaseID)
//                        print(self.recieverID)
//                        print(self.audioDownloadURL)
//                        
//                        self.sendMessage(time:self.getCurrentTime(),senderId:"\(currentFireBaseID!)",receiverId:self.recieverID,audioUrl:self.audioDownloadURL,mssgDuration:self.durationForApi)
//                        
//                    })
//                    
//                    
//                    
//                    
//                }
//            })
//            
//            
//            
//        }catch{
//            
//        }
//        
//        
//        
//        
//        
//    }
//    
    
    
    func viewProfile(){
        
        //        lblCategories.text = UserDefaults.standard.value(forKey: "CATEGORIES") as? String ?? ""
        //
        let infoArray = UserDefaults.standard.value(forKey: "USERINFO") as? NSArray ?? []
        //print(infoArray)
        let infoDict = infoArray.object(at: 0) as? NSDictionary ?? [:]
        
        
        
        
        
        let login_user_id = infoDict.value(forKey: "user_id") as? String ?? ""
        
        print(login_user_id)
        
        
        if InternetConnection.internetshared.isConnectedToNetwork() {
            
            Indicator.shared.showProgressView(self.view)
            
            
            
            WebserviceConnection.requestGETURL("userdetail/\(user_id)/\(login_user_id)", success: { (responseJson) in
                
                if responseJson["status"].stringValue == "SUCCESS" {
                    
                    Indicator.shared.hideProgressView()
                    
                    print("SUCCESS")
                    
                    print(responseJson)
                    self.tblChat.tableFooterView = UIView()
                    
                    let userDict = responseJson["data"].dictionaryObject ?? [:]
                    
                    self.lblName.text = userDict["fullname"] as? String ?? ""
                    
                    
                    let image = userDict["image"] as? String ?? ""
                    
                    self.imgProfilePic.sd_setImage(with: URL(string: image as? String ?? ""), placeholderImage: UIImage(named: "user_signup"))
                    
//
//                    let currentFireBaseID = Auth.auth().currentUser?.uid  // personLogin Firebase ID
//
//                    let toWhomeChatId  = userDict["firebase_id"] as? String ?? "" // whome to chat ID
//
//                    self.recieverID = userDict["firebase_id"] as? String ?? ""
//
//                    print(currentFireBaseID)
//
//                    print(toWhomeChatId)
//
//                    self.chatRoom1 = "\(currentFireBaseID!)-\(toWhomeChatId)"
//                    self.chatRoom2 = "\(toWhomeChatId)-\(currentFireBaseID!)"
//
//                    print(self.chatRoom1)
//                    print(self.chatRoom2)
//
                    self.getMessagesAPI()
                    
                    //self.retrieveMessages()
                    
                    
                    
                    
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
                
                _ = SweetAlert().showAlert("Escalate", subTitle: "Something went wrong.Please try again!", style: AlertStyle.error)
                Indicator.shared.hideProgressView()
                
                
            })
            
            
        }else{
            
            _ = SweetAlert().showAlert("Escalate", subTitle: "No interter connection!", style: AlertStyle.error)
            Indicator.shared.hideProgressView()
            
        }
        
        
        
    }
    
    
    
    
    
    func check_record_permission()
    {
        switch AVAudioSession.sharedInstance().recordPermission() {
        case AVAudioSessionRecordPermission.granted:
            isAudioRecordingGranted = true
            break
        case AVAudioSessionRecordPermission.denied:
            isAudioRecordingGranted = false
            break
        case AVAudioSessionRecordPermission.undetermined:
            AVAudioSession.sharedInstance().requestRecordPermission({ (allowed) in
                if allowed {
                    self.isAudioRecordingGranted = true
                } else {
                    self.isAudioRecordingGranted = false
                }
            })
            break
        default:
            break
        }
    }
    
    
    func getDocumentsDirectory() -> URL
    {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
    
    func getFileUrl() -> URL
    {
        let filename = "myRecording.m4a"
        let filePath = getDocumentsDirectory().appendingPathComponent(filename)
        return filePath
    }
    
    func setup_recorder()
    {
        if isAudioRecordingGranted
        {
            let session = AVAudioSession.sharedInstance()
            do
            {
                try session.setCategory(AVAudioSessionCategoryPlayAndRecord, with: .defaultToSpeaker)
                try session.setActive(true)
                let settings = [
                    AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
                    AVSampleRateKey: 44100,
                    AVNumberOfChannelsKey: 2,
                    AVEncoderAudioQualityKey:AVAudioQuality.high.rawValue
                ]
                audioRecorder = try AVAudioRecorder(url: getFileUrl(), settings: settings)
                audioRecorder.delegate = self
                audioRecorder.isMeteringEnabled = true
                audioRecorder.prepareToRecord()
                
                
                
                
                
            }
            catch let error {
                display_alert(msg_title: "Error", msg_desc: error.localizedDescription, action_title: "OK")
            }
        }
        else
        {
            display_alert(msg_title: "Error", msg_desc: "Don't have access to use your microphone.", action_title: "OK")
        }
    }
    
    func finishAudioRecording(success: Bool)
    {
        if success
        {
            audioRecorder.stop()
            audioRecorder = nil
            
            meterTimer.invalidate()
            meterTimer = nil
            print("recorded successfully.")
            
            
            let urlString: String = getFileUrl().absoluteString
            
            audioUrlForApi = getFileUrl()
            
            print(urlString)
            
        }
        else
        {
            display_alert(msg_title: "Error", msg_desc: "Recording failed.", action_title: "OK")
        }
    }
    
    
    
    
    func display_alert(msg_title : String , msg_desc : String ,action_title : String)
    {
        let ac = UIAlertController(title: msg_title, message: msg_desc, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: action_title, style: .default)
        {
            (result : UIAlertAction) -> Void in
            _ = self.navigationController?.popViewController(animated: true)
        })
        present(ac, animated: true)
    }
    
    
    
    
    //TODO : Recording audio
    
    func recordingVoiceMessage(){
        
        stopPlayingMusic()
        stopTableAudio()
        
        
        if(isRecording)
        {
            
            
            
            print("TIMERCOUNT")
            print(countLimit)
            timerLimit?.invalidate()
            timerLimit = nil
            
            countLimit = 39
            
            pulsator.stop()
            finishAudioRecording(success: true)
            isRecording = false
            
            btnPlayRecording.isHidden = false
            audioView.isHidden = false
            btnSendMessageRef.isHidden = false
            btnCancelTapped.isHidden = false
            lblRecordingTime.isHidden = false
            
            record_btn_ref.isHidden = true
            sourceView.isHidden = true
            
            
            let asset = AVAsset(url: audioUrlForApi)
            
            let duration = asset.duration
            let durationTime = Int(round(CMTimeGetSeconds(duration)))
            
            print(durationTime)
            
            let hours = durationTime/3600
            
            let minutes = durationTime / 60 % 60
            
            let seconds = durationTime % 60
            
            
            print("\(hours),\(minutes) and \(seconds)")
            
            var secondString = String()
            
            var minuteString = String()
            
            var hourString = String()
            
            if seconds<10{
                
                secondString = "0\(seconds)"
                
            }else{
                
                secondString = "\(seconds)"
            }
            
            if minutes<10{
                
                minuteString = "0\(minutes)"
                
            }else{
                
                minuteString = "\(minutes)"
            }
            
            
            if hours<10{
                
                hourString = "0\(hours)"
                
            }else{
                
                hourString = "\(hours)"
            }
            
            
            
            durationForApi = "\(minuteString):\(secondString)"
            
            print(durationForApi)
            
            
            
            
            
            let totalTimeString = "\(durationForApi)"
            lblRecordingTime.text = totalTimeString
            
            
            
            
            
            if self.msg_thread_array.count == 0{
                
                self.record_btn_ref.setTitle("", for: .normal)
            }else{
                self.record_btn_ref.setTitle(" Reply", for: .normal)
            }
            
   
            
        }
        else
        {
            meterTimer = Timer.scheduledTimer(timeInterval: 0.1, target:self, selector:#selector(self.updateAudioMeter(timer:)), userInfo:nil, repeats:true)
            addHalo()
            
          
            setup_recorder()
            
            
            audioRecorder.record()
            
            isRecording = true
            
            countDownTimet2()
            
            
        }
        
        
        
        
        
    }
    
    
    
  
    
    
    
    //MARK:- RECORDINGS DELEGATES
    //MARK:
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool)
    {
        if !flag
        {
            finishAudioRecording(success: false)
        }
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool)
    {
        record_btn_ref.isEnabled = true
    }
    
    
    
    func prepare_play()
    {
        do
        {
            audioPlayer = try AVAudioPlayer(contentsOf: getFileUrl())
            audioPlayer.delegate = self
            audioPlayer.prepareToPlay()
        }
        catch{
            print("Error")
        }
    }
    //MARK:- ACTIONS
    //MARK:
    
    
    //COUNTER FOR WAVE AND AUDIO TIME
    
    
  
    
    
    
    @objc func stopRecordingAndPlaying(_ notification: Notification) {
        
        stopPlayingMusic()
        stopTableAudio()
        stopRecording()
        
        
    }
    
    
    
    
    
    @objc internal func refreshAudioView1(_:Timer) {
        
        let btnTag = UserDefaults.standard.value(forKey: "CRBTNTAG") as? Int ?? 0
        
        
        let indexPath = IndexPath(row: btnTag, section: 0)
        
        let messageDict = msg_thread_array[btnTag] as? NSDictionary ?? [:]
        
        let senderFlag = messageDict.value(forKey: "flag") as? String ?? ""
        
        //let dataDict = messageArray[btnTag]
        
        //        let sender_id = dataDict.senderId as? String ?? ""
        //        let currentFireBaseID = Auth.auth().currentUser?.uid  // personLogin Firebase ID
        //        print(currentFireBaseID)
        
        
        if senderFlag == "1"{
            
            
            guard let cell = tblChat.cellForRow(at: indexPath) as? ChatMessageCombineCellAndXib else {
                
                return
            }
            
            
            
            if cell.audioViewP.amplitude <= cell.audioViewP.idleAmplitude || cell.audioViewP.amplitude > 1.0 {
                self.change1 *= -1.0
            }
            
            
            cell.audioViewP.amplitude += self.change1
            
            
        }else{
            
            
            guard let cell = tblChat.cellForRow(at: indexPath) as? ChatMessageCombineCellAndXib else {
                
                return
            }
            
            
            
            if cell.audioViewW.amplitude <= cell.audioViewW.idleAmplitude || cell.audioViewW.amplitude > 1.0 {
                self.change1 *= -1.0
            }
            
            
            cell.audioViewW.amplitude += self.change1
            
            
            
        }
        
        
        
    }
    
    
  
    
    @objc func btnPlayPausedTapped(sender: UIButton){
        
        btnPlayPauseTappedBool = true
        
        stopPlayingMusic()
        
        
        if isRecording == true{
            
            
            print("TIMERCOUNT")
            print(countLimit)
            timerLimit?.invalidate()
            timerLimit = nil
            
            countLimit = 39
            
            pulsator.stop()
            finishAudioRecording(success: true)
            isRecording = false
            
            btnPlayRecording.isHidden = false
            audioView.isHidden = false
            btnSendMessageRef.isHidden = false
            btnCancelTapped.isHidden = false
            
            record_btn_ref.isHidden = true
            sourceView.isHidden = true
            
            if self.msg_thread_array.count == 0{
                
                self.record_btn_ref.setTitle("", for: .normal)
            }else{
                self.record_btn_ref.setTitle(" Reply", for: .normal)
            }
            
            
            
        }else{
            
            
            UserDefaults.standard.set(sender.tag, forKey: "CRBTNTAG")
            
            timerCountCRA?.invalidate()
            timerCountCRA = nil
            timerCRA?.invalidate()
            timerCRA = nil
            
            let prevTag = UserDefaults.standard.value(forKey: "CRPBTNTAG") as? Int ?? 0
            print(prevTag)
            let btnTag = UserDefaults.standard.value(forKey: "CRBTNTAG") as? Int ?? 0
            
            print(btnTag)
            
            if btnTag != prevTag{
                
                if(isPlaying1){
                    
                    let messageDict  =  msg_thread_array[prevTag] as? NSDictionary ?? [:]
                    
                    let senderFlag = messageDict.value(forKey: "flag") as? String ?? ""
                    
                    if senderFlag == "1"{
                        
                        
                        let prevIndexPath = IndexPath(row: prevTag, section: 0)
                        guard let prevCell = tblChat.cellForRow(at: prevIndexPath) as? ChatMessageCombineCellAndXib else {
                            
                            return
                        }
                        
                        player1!.pause()
                        
                        timerCountCRA?.invalidate()
                        timerCountCRA = nil
                        timerCRA?.invalidate()
                        timerCRA = nil
                        sec1 = 0
                        hr1 = 0
                        min1 = 0
                        
                        prevCell.btnPlayPausedRefP.setImage(#imageLiteral(resourceName: "chat_message_play_white"), for: .normal)
                        prevCell.audioViewP.amplitude = 0.0
                        
                        let totalTimeString = messageDict.value(forKey: "message_duration") as? String ?? ""
                        prevCell.lblTotalTimerP.text = totalTimeString
                        
                        isPlaying1 = false
                        
                        
                        
                    }else{
                        
                        
                        let prevIndexPath = IndexPath(row: prevTag, section: 0)
                        guard let prevCell = tblChat.cellForRow(at: prevIndexPath) as? ChatMessageCombineCellAndXib else {
                            
                            return
                        }
                        
                        
                        player1!.pause()
                        
                        timerCountCRA?.invalidate()
                        timerCountCRA = nil
                        timerCRA?.invalidate()
                        timerCRA = nil
                        sec1 = 0
                        hr1 = 0
                        min1 = 0
                        
                        prevCell.btnPlayPausedRefW.setImage(#imageLiteral(resourceName: "chat_message_play_pur"), for: .normal)
                        prevCell.audioViewW.amplitude = 0.0
                        
                        let totalTimeString = messageDict.value(forKey: "message_duration") as? String ?? ""
                        prevCell.lblTotalTimerW.text = totalTimeString
                        
                        isPlaying1 = false
                        
                        
                    }
                    
                    
                    
                    
                }else{
                    
                    
                }
                
                
                
            }
            
            
            print(isPlaying1)
            
            
            let indexPath = IndexPath(row: btnTag, section: 0)
            let cell = tblChat.cellForRow(at: indexPath) as! ChatMessageCombineCellAndXib
            
            
            let messageDict  =  msg_thread_array[btnTag] as? NSDictionary ?? [:]
            
            let senderFlag = messageDict.value(forKey: "flag") as? String ?? ""
            
            audioUrl1 = NSURL(string: messageDict.value(forKey: "msg") as? String ?? "" )! as URL
            
            print(audioUrl1)
            
            
            print(isPlaying1)
            
            if isPlaying1 == true{
                
                let messageDict  =  msg_thread_array[prevTag] as? NSDictionary ?? [:]
                
                let senderFlag = messageDict.value(forKey: "flag") as? String ?? ""
                
                if senderFlag == "1"{
                    
                    
                    let prevIndexPath = IndexPath(row: prevTag, section: 0)
                    guard let prevCell = tblChat.cellForRow(at: prevIndexPath) as? ChatMessageCombineCellAndXib else {
                        
                        return
                    }
                    
                    player1!.pause()
                    timerCountCRA?.invalidate()
                    timerCountCRA = nil
                    timerCRA?.invalidate()
                    timerCRA = nil
                    sec1 = 0
                    hr1 = 0
                    min1 = 0
                    
                    prevCell.btnPlayPausedRefP.setImage(#imageLiteral(resourceName: "chat_message_play_white"), for: .normal)
                    prevCell.audioViewP.amplitude = 0.0
                    
                    let totalTimeString = messageDict.value(forKey: "message_duration") as? String ?? ""
                    prevCell.lblTotalTimerP.text = totalTimeString
                    
                    isPlaying1 = false
                    
                    
                    
                }else{
                    
                    print(isPlaying1)
                    let prevIndexPath = IndexPath(row: prevTag, section: 0)
                    guard let prevCell = tblChat.cellForRow(at: prevIndexPath) as? ChatMessageCombineCellAndXib else {
                        
                        return
                    }
                    
                    
                    player1!.pause()
                    timerCountCRA?.invalidate()
                    timerCountCRA = nil
                    timerCRA?.invalidate()
                    timerCRA = nil
                    sec1 = 0
                    hr1 = 0
                    min1 = 0
                    
                    prevCell.btnPlayPausedRefW.setImage(#imageLiteral(resourceName: "chat_message_play_pur"), for: .normal)
                    prevCell.audioViewW.amplitude = 0.0
                    
                    let totalTimeString = messageDict.value(forKey: "message_duration") as? String ?? ""
                    prevCell.lblTotalTimerW.text = totalTimeString
                    
                    isPlaying1 = false
                    
                    
                }
                
                
                
                print(isPlaying1)
                
            }else{
                
                
                print(isPlaying1)
                //chalna hai
                
                let messageDict  =  msg_thread_array[btnTag] as? NSDictionary ?? [:]
                
                let senderFlag = messageDict.value(forKey: "flag") as? String ?? ""
                
                if senderFlag == "1"{
                    
                    if audioUrl1 != nil{
                        
                        let indexPath = IndexPath(row: btnTag, section: 0)
                        guard let cell = tblChat.cellForRow(at: indexPath) as? ChatMessageCombineCellAndXib else {
                            
                            return
                        }
                        
                        
                        
                        let playerItem1:AVPlayerItem = AVPlayerItem(url: audioUrl1!)
                        player1 = AVPlayer(playerItem: playerItem1)
                        
                        
                        let asset = AVAsset(url: audioUrl1)
                        
                        let duration = asset.duration
                        let durationTime = CMTimeGetSeconds(duration)
                        
                        
                        count1 = Int(ceil(durationTime))
                        
                        
                       countDownTimet()
                        
                        
                        timerCRA = Timer.scheduledTimer(timeInterval: 0.009, target: self, selector: #selector(self.refreshAudioView1(_:)), userInfo: nil, repeats: true)
                        
                        cell.btnPlayPausedRefP.setImage(UIImage(named: "chat_message_pause_white"),for: .normal)
                        player1!.play()
                        
                        
                        isPlaying1 = true
                    }else{
                        
                        _ = SweetAlert().showAlert("Escalate", subTitle: "Audio file is missing.", style: AlertStyle.error)
                        
                    }
                    
                    
                    
                    
                }else{
                    
                    if audioUrl1 != nil{
                        
                        let indexPath = IndexPath(row: btnTag, section: 0)
                        guard let cell = tblChat.cellForRow(at: indexPath) as? ChatMessageCombineCellAndXib else {
                            
                            return
                        }
                        
                        
                        
                        let playerItem1:AVPlayerItem = AVPlayerItem(url: audioUrl1!)
                        player1 = AVPlayer(playerItem: playerItem1)
                        
                        
                        let asset = AVAsset(url: audioUrl1)
                        
                        let duration = asset.duration
                        let durationTime = CMTimeGetSeconds(duration)
                        
                        
                        count1 = Int(round(durationTime))
                        
                        
                        countDownTimet()
                        
                        
                        timerCRA = Timer.scheduledTimer(timeInterval: 0.009, target: self, selector: #selector(self.refreshAudioView1(_:)), userInfo: nil, repeats: true)
                        
                        cell.btnPlayPausedRefW.setImage(UIImage(named: "chat_message_pause_purple"),for: .normal)
                        player1!.play()
                        
                        
                        isPlaying1 = true
                    }else{
                        
                        _ = SweetAlert().showAlert("Escalate", subTitle: "Audio file is missing.", style: AlertStyle.error)
                        
                    }
                    
                    
                    
                    
                    
                    
                }
                
                
                
            }
            
            
            
        }
        
        
        
        
        
        let prevBtnTag = UserDefaults.standard.value(forKey: "CRBTNTAG") as? Int ?? 0
        
        print(prevBtnTag)
        
        UserDefaults.standard.set(prevBtnTag, forKey: "CRPBTNTAG")
        
        
        print(isPlaying1)
        
        
    }
    
    
    
    
    
    
    @IBAction func btnSendMessageTapped(_ sender: UIButton) {
        
        //sendRecordedMessage()
        
        
        
        sendMessages()
    }
    
    
    
    
    
    
    @IBAction func btnCancelRecoringsTapped(_ sender: UIButton) {
        
        stopPlayingMusic()
        stopTableAudio()
        
        btnPlayRecording.isHidden = true
        audioView.isHidden = true
        btnSendMessageRef.isHidden = true
        btnCancelTapped.isHidden = true
        
        record_btn_ref.isHidden = false
        sourceView.isHidden = false
        
        lblRecordingTime.isHidden = true
        
        btnPlayRecording.setImage(UIImage(named: "chat_message_play_white"),for: .normal)
        
        if msg_thread_array.count == 0{
            
            record_btn_ref.setTitle("", for: .normal)
        }else{
            record_btn_ref.setTitle(" Reply", for: .normal)
        }
        
    }
    
    @IBAction func start_recording(_ sender: UIButton)
    {
        recordingVoiceMessage()
        
     
        
        
    }
    
    
    
    
    @IBAction func play_recording(_ sender: Any)
    {
        
        
        if(isPlaying)
        {
            
            sec = 0
            hr = 0
            min = 0
            
            audioPlayer.stop()
            record_btn_ref.isEnabled = true
            isPlaying = false
            
            timerCountCA?.invalidate()
            timerCountCA = nil
            timerCA?.invalidate()
            timerCA = nil
            btnPlayRecording.setImage(UIImage(named: "chat_message_play_white"),for: .normal)
            audioView.amplitude = 0.0
            
            
            let asset = AVAsset(url: audioUrlForApi)
            
            let duration = asset.duration
            let durationTime = Int(round(CMTimeGetSeconds(duration)))
            
            print(durationTime)
            
            let hours = durationTime/3600
            
            let minutes = durationTime / 60 % 60
            
            let seconds = durationTime % 60
            
            
            print("\(minutes) and \(seconds)")
            
            var secondString = String()
            
            var minuteString = String()
            
            var hourString = String()
            
            if seconds<10{
                
                secondString = "0\(seconds)"
                
            }else{
                
                secondString = "\(seconds)"
            }
            
            if minutes<10{
                
                minuteString = "0\(minutes)"
                
            }else{
                
                minuteString = "\(minutes)"
            }
            
            
            if hours<10{
                
                hourString = "0\(hours)"
                
            }else{
                
                hourString = "\(hours)"
            }
            
            
            
            durationForApi = "\(minuteString):\(secondString)"
            
            print(durationForApi)
            
            
            
            

            let totalTimeString = "\(durationForApi)"
            lblRecordingTime.text = totalTimeString
            
            
            
            
            
            
            
        }
        else
        {
            if FileManager.default.fileExists(atPath: getFileUrl().path)
            {
                record_btn_ref.isEnabled = false
                prepare_play()
                audioPlayer.play()
                isPlaying = true
                btnPlayRecording.setImage(UIImage(named: "chat_message_pause_white"),for: .normal)
                
                
                
                let asset = AVAsset(url: getFileUrl())
                
                let duration = asset.duration
                let durationTime = CMTimeGetSeconds(duration)
                count = Int(round(durationTime))
                countDownTimet1()
                
                timerCA = Timer.scheduledTimer(timeInterval: 0.009, target: self, selector: #selector(self.refreshAudioView(_:)), userInfo: nil, repeats: true)
                
                
    
             
                
                
                
                
            }
            else
            {
                display_alert(msg_title: "Error", msg_desc: "Audio file is missing.", action_title: "OK")
            }
        }
    }
    
    
    
    
    @IBAction func btnBackTapped(_ sender: Any) {

        
        
        stopRecording()
        stopTableAudio()
        stopPlayingMusic()
        
        if isComing == "CHATVC"{
        
        self.navigationController?.popViewController(animated: true)
            
        }else{
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "TabBarVC") as! TabBarVC
            let navController = UINavigationController(rootViewController: vc)
            navController.navigationBar.isHidden = true
            self.appDelegate.window?.rootViewController = navController
            self.appDelegate.window?.makeKeyAndVisible()
            
        }
    }
    
    
    @objc internal func refreshAudioView(_:Timer) {
        if self.audioView.amplitude <= self.audioView.idleAmplitude || self.audioView.amplitude > 1.0 {
            self.change *= -1.0
        }
        
        
        // Simply set the amplitude to whatever you need and the view will update itself.
        self.audioView.amplitude += self.change
    }
    
    
    
    //COUNTER FOR WAVE AND AUDIO TIME
    
    func countDownTimet(){

        timerCountCRA = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.update), userInfo: nil, repeats: true)
    }


    @objc func update() {


        let btnTag = UserDefaults.standard.value(forKey: "CRBTNTAG") as? Int ?? 0

        let messageDict  =  msg_thread_array[btnTag] as? NSDictionary ?? [:]

        let senderFlag = messageDict.value(forKey: "flag") as? String ?? ""

        audioUrl1 = NSURL(string: messageDict.value(forKey: "msg") as? String ?? "" )! as URL


         if senderFlag == "1"{


            let indexPath = IndexPath(row: btnTag, section: 0)
            guard let cell = tblChat.cellForRow(at: indexPath) as? ChatMessageCombineCellAndXib else {

                return
            }


            if(count1 > 0) {
                
                
                sec += 1
                
                if sec == 60{
                    min += 1
                    sec = 0
                }
                if min == 60{
                    hr += 1
                    min = 0
                    sec = 0
                }
                if hr == 24{
                    hr = 0
                    min = 0
                    sec = 0
                }
                
                count1 = count1 - 1
                print(count1)
                
                let totalTimeString = String(format: "%02d:%02d", min, count1)
                cell.lblTotalTimerP.text = totalTimeString
                
                
                
            }
            else{
                
                
                timerCountCRA?.invalidate()
                timerCountCRA = nil
                timerCRA?.invalidate()
                timerCRA = nil
        
                 cell.btnPlayPausedRefP.setImage(#imageLiteral(resourceName: "chat_message_play_white"), for: .normal)
                cell.lblTotalTimerP.text = messageDict.value(forKey: "message_duration") as? String ?? ""
                
                
                cell.audioViewP.amplitude = 0.0
                isPlaying1 = false
                //STOP PLAYING AND ANIMATION
                
                
            }
            
            





         }else{


            let indexPath = IndexPath(row: btnTag, section: 0)
            guard let cell = tblChat.cellForRow(at: indexPath) as? ChatMessageCombineCellAndXib else {

                return
            }


            if(count1 > 0) {


                sec += 1

                if sec == 60{
                    min += 1
                    sec = 0
                }
                if min == 60{
                    hr += 1
                    min = 0
                    sec = 0
                }
                if hr == 24{
                    hr = 0
                    min = 0
                    sec = 0
                }

                count1 = count1 - 1
                print(count)

                let totalTimeString = String(format: "%02d:%02d", min, count1)
                cell.lblTotalTimerW.text = totalTimeString



            }
            else{


                timerCountCRA?.invalidate()
                timerCountCRA = nil
                timerCRA?.invalidate()
                timerCRA = nil

    
                cell.btnPlayPausedRefW.setImage(#imageLiteral(resourceName: "chat_message_play_pur"), for: .normal)

                cell.lblTotalTimerW.text = messageDict.value(forKey: "message_duration") as? String ?? ""


                cell.audioViewW.amplitude = 0.0
                isPlaying1 = false
                //STOP PLAYING AND ANIMATION


            }

        }






    }


    
    
    //COUNTER FOR WAVE AND AUDIO TIME
    
    func countDownTimet1(){
        
        timerCountCA = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.update1), userInfo: nil, repeats: true)
    }
    
    
    @objc func update1() {
        if(count > 0) {
            
            
            sec += 1
            
            if sec == 60{
                min += 1
                sec = 0
            }
            if min == 60{
                hr += 1
                min = 0
                sec = 0
            }
            if hr == 24{
                hr = 0
                min = 0
                sec = 0
            }
            
            count = count - 1
            print(count)
            
            let totalTimeString = String(format: "%02d:%02d", min, count)
            lblRecordingTime.text = totalTimeString
            
            
            
        }
        else{
            
            
            timerCountCA?.invalidate()
            timerCountCA = nil
            timerCA?.invalidate()
            timerCA = nil
            
            sec = 0
            hr = 0
            min = 0
            
            btnPlayRecording.setImage(UIImage(named: "chat_message_play_white"),for: .normal)
            
            
            let asset = AVAsset(url: audioUrlForApi)
            
            let duration = asset.duration
            let durationTime = Int(round(CMTimeGetSeconds(duration)))
            
            print(durationTime)
            
            let hours = durationTime/3600
            
            let minutes = durationTime / 60 % 60
            
            let seconds = durationTime % 60
            
            
            print("\(hours),\(minutes) and \(seconds)")
            
            var secondString = String()
            
            var minuteString = String()
            
            var hourString = String()
            
            if seconds<10{
                
                secondString = "0\(seconds)"
                
            }else{
                
                secondString = "\(seconds)"
            }
            
            if minutes<10{
                
                minuteString = "0\(minutes)"
                
            }else{
                
                minuteString = "\(minutes)"
            }
            
            
            if hours<10{
                
                hourString = "0\(hours)"
                
            }else{
                
                hourString = "\(hours)"
            }
            
            
            
            durationForApi = "\(minuteString):\(secondString)"
            
            print(durationForApi)
            
            
            
            
            
            let totalTimeString = "\(durationForApi)"
            lblRecordingTime.text = totalTimeString
            
            
            audioView.amplitude = 0.0
            isPlaying = false
            //STOP PLAYING AND ANIMATION
            
            
        }
    }
    
    
    
    
    
    //ONE MINUTE TIMER
    
    func countDownTimet2(){
        
        timerLimit = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.update2), userInfo: nil, repeats: true)
    }
    
    
    @objc func update2() {
        if(countLimit > 0) {
            
            
            countLimit = countLimit - 1
            print(countLimit)
        }
        else{
            print("TIMERCOUNT")
            print(countLimit)
            timerLimit?.invalidate()
            timerLimit = nil
            
            countLimit = 39
            
            let sec = 0
            let hr = 0
            let min = 0
            
            pulsator.stop()
            finishAudioRecording(success: true)
            isRecording = false
            
            btnPlayRecording.isHidden = false
            audioView.isHidden = false
            btnSendMessageRef.isHidden = false
            btnCancelTapped.isHidden = false
            lblRecordingTime.isHidden = false
            record_btn_ref.isHidden = true
            sourceView.isHidden = true
            
            _ = SweetAlert().showAlert("Escalate", subTitle: "Recording limit(40 sec) reached!", style: AlertStyle.warning)
            
            
            
            if self.msg_thread_array.count == 0{
                
                self.record_btn_ref.setTitle("", for: .normal)
            }else{
                self.record_btn_ref.setTitle(" Reply", for: .normal)
            }
            
            
        
            
            
        }
    }
    
    
    
    
    
    
    
    
    
    
}



//MARK:- EXTENSION TABLEVIEW DATA SOURCE AND DELEGATES
//MARK:

extension ChatRepliesVC:UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return msg_thread_array.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        var tableCell = UITableViewCell()
        
        
        tblChat.register(UINib(nibName:"ChatMessageCombineCellAndXib",bundle:nil), forCellReuseIdentifier: "ChatMessageCombineCellAndXib")
        
        let audioCell = tblChat.dequeueReusableCell(withIdentifier: "ChatMessageCombineCellAndXib", for: indexPath) as! ChatMessageCombineCellAndXib
        
        if msg_thread_array.count > 0{
            
            
            let messageDict  =  msg_thread_array[indexPath.row] as? NSDictionary ?? [:]
            
            
            
            
            
            let senderFlag = messageDict.value(forKey: "flag") as? String ?? ""
            if senderFlag == "1"{
                
                
                audioCell.selectionStyle = .none
                
                audioCell.viewWhite.isHidden = true
                audioCell.imgCornerW.isHidden = true
                
                audioCell.viewPurple.isHidden = false
                audioCell.imgCornerP.isHidden = false
                
                audioCell.lblTimeP.text = messageDict.value(forKey: "time") as? String ?? ""
                
                audioCell.lblTotalTimerP.text = messageDict.value(forKey: "message_duration") as? String ?? ""
                
                audioCell.btnPlayPausedRefP.tag = indexPath.row
                audioCell.btnPlayPausedRefP.addTarget(self, action: #selector(btnPlayPausedTapped), for: .touchUpInside)
                
                tableCell = audioCell
                
                
            }else{
                
                audioCell.selectionStyle = .none
                
                audioCell.viewWhite.isHidden = false
                audioCell.imgCornerW.isHidden = false
                
                audioCell.viewPurple.isHidden = true
                audioCell.imgCornerP.isHidden = true
                
                audioCell.lblTimeW.text = messageDict.value(forKey: "time") as? String ?? ""
                
                audioCell.lblTotalTimerW.text = messageDict.value(forKey: "message_duration") as? String ?? ""
                
                audioCell.btnPlayPausedRefW.tag = indexPath.row
                audioCell.btnPlayPausedRefW.addTarget(self, action: #selector(btnPlayPausedTapped), for: .touchUpInside)
                
                tableCell = audioCell
                
            }
            
            
            
        }
        
        
        return tableCell
        
        
        
        
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableViewAutomaticDimension
        
    }
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        
        
        stopPlayingMusic()
        stopTableAudio()
        
        
        
    }
    
    
    
    
    
}
