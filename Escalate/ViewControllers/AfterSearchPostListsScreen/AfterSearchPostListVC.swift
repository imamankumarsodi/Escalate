//
//  AfterSearchPostListVC.swift
//  Escalate
//
//  Created by abc on 31/08/18.
//  Copyright © 2018 call soft. All rights reserved.
//

import UIKit
import AVFoundation
import SwiftSiriWaveformView
import MediaPlayer
class AfterSearchPostListVC: UIViewController,AVAudioRecorderDelegate,AVAudioPlayerDelegate,UIScrollViewDelegate,UITableViewDataSourcePrefetching{
    //MARK:- OUTLETS
    //MARK:
    @IBOutlet var tblViewHome: UITableView!
    
    //MARK:- VARIABLES
    //MARK
    var controllerInstance =  UIViewController()
    let WebserviceConnection  = AlmofireWrapper()
    var postDataArray = [SavedPostsDataModel]()
    var dataArray = NSArray()
    var isPlaying = false
    var isPlaying1 = false
    var audioUrl: URL!
    var timerASa:Timer?
    var change:CGFloat = 0.01
    var timerCountASa:Timer?
    var count = 0
    var hr = 0
    var min = 0
    var sec = 0
    var player:AVPlayer?
    var playerItem:AVPlayerItem?
    var rowNumber = Int()
    var listButtonTapped = false
    var user_id = ""
    var likeCountsString = ""
    //VARIABLES FOR AUTOREPLY
    var audioUrlArray = [String]()
    var repeatState = false
    var repeatArray = [Int]()
    var currentAudioIndex = 0
    //****variables for locations
    var lat = ""
    var log = ""
    //*****variable for calling respective API
    var apiName = ""
    var tag_id = ""
    var Passdict : [String:AnyObject]?
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetUp()
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        userPostList(apiName: apiName)
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    override func viewWillDisappear(_ animated: Bool) {
        if(isPlaying)
        {
            let btnTag = UserDefaults.standard.value(forKey: "ASABTNTAG") as? Int ?? 0
            let indexPath = IndexPath(row: btnTag, section: 0)
            guard let cell = tblViewHome.cellForRow(at: indexPath) as? HomeTableViewCell else {
                return
            }
            player!.pause()
            timerCountASa?.invalidate()
            timerCountASa = nil
            timerASa?.invalidate()
            timerASa = nil
            sec = 0
            hr = 0
            min = 0
            cell.btnPlayPausedRef.setImage(#imageLiteral(resourceName: "home_play_a"), for: .normal)
            isPlaying = false
            cell.audioView.amplitude = 0.0
            let totalTimeString = String(format: "%02d:%02d", min, sec)
            cell.lblTotalTimer.text = totalTimeString
        }
        
    }
    override func viewDidDisappear(_ animated: Bool) {
        if(isPlaying)
        {
            let btnTag = UserDefaults.standard.value(forKey: "ASABTNTAG") as? Int ?? 0
            let indexPath = IndexPath(row: btnTag, section: 0)
            guard let cell = tblViewHome.cellForRow(at: indexPath) as? HomeTableViewCell else {
                return
            }
            player!.pause()
            timerCountASa?.invalidate()
            timerCountASa = nil
            timerASa?.invalidate()
            timerASa = nil
            sec = 0
            hr = 0
            min = 0
            cell.btnPlayPausedRef.setImage(#imageLiteral(resourceName: "home_play_a"), for: .normal)
            isPlaying = false
            cell.audioView.amplitude = 0.0
            let totalTimeString = String(format: "%02d:%02d", min, sec)
            cell.lblTotalTimer.text = totalTimeString
        }
        
    }
    //MARK:- METHODS
    //MARK:
    func initialSetUp(){
        
        NotificationCenter.default.addObserver(self, selector: #selector(AfterSearchPostListVC.stopRecordingAndPlaying(_:)), name: NSNotification.Name(rawValue: "stopRecordingAndPlaying"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(AfterSearchPostListVC.refreshListAfterSearch(_:)), name: NSNotification.Name(rawValue: "refreshListSearch"), object: nil)
        
        userPostList(apiName: apiName)
    }
    func userPostList(apiName:String){
        let infoArray = UserDefaults.standard.value(forKey: "USERINFO") as? NSArray ?? []
        let infoDict = infoArray.object(at: 0) as? NSDictionary ?? [:]
        user_id = infoDict.value(forKey: "user_id") as? String ?? ""
        let token = infoDict.value(forKey: "token") as? String ?? ""
        if InternetConnection.internetshared.isConnectedToNetwork() {
            Indicator.shared.showProgressView(self.view)
            if apiName == "genrepostbyid"{
            Passdict = ["token":token,
                        "user_id":user_id,
                        "topic_id":tag_id] as [String : AnyObject]
            }else{
            Passdict = ["token":token,
                        "user_id":user_id,
                        "tag_id":tag_id] as [String : AnyObject]
            }
            WebserviceConnection.requestPOSTURL(apiName, params: Passdict as! [String : AnyObject], headers:nil, success: { (responseJson) in
                print(responseJson)
                
                if responseJson["status"].stringValue == "SUCCESS" {
                    Indicator.shared.hideProgressView()
                    if self.postDataArray.count>0{
                        self.postDataArray.removeAll()
                    }
                    self.dataArray = responseJson["data"].arrayObject as? NSArray ?? []
                    for item in self.dataArray {
                        let dict = item as? NSDictionary ?? [:]
                        let user_id = dict.object(forKey: "user_id") as? String ?? ""
                        let user_image = dict.object(forKey: "user_image") as? String ?? ""
                        let fullname = dict.object(forKey: "fullname") as? String ?? ""
                        let username = dict.object(forKey: "username") as? String ?? ""
                        let audio_url = dict.object(forKey: "audio_url") as? String ?? ""
                        let otherurl = dict.object(forKey: "otherurl") as? String ?? ""
                        self.audioUrlArray.append(otherurl)
                        let description = dict.object(forKey: "description") as? String ?? ""
                        let topic_name = dict.object(forKey: "topic_name") as? String ?? ""
                        let duration = dict.object(forKey: "duration") as? String ?? ""
                        guard let post_id = dict.object(forKey: "post_id") as? Int else{
                            print("NO post_id")
                            return
                        }
                        print(post_id)
                        let like_flag = dict.object(forKey: "like_flag") as? String ?? ""
                        let like_count = dict.object(forKey: "like_count") as? String ?? ""
                        let reply_count = dict.object(forKey: "reply_count") as? String ?? ""
                        let tag_list = dict.object(forKey: "tag_list") as? String ?? ""
                        let postItem = SavedPostsDataModel(user_id: user_id, user_image: user_image, fullname: fullname, username: username, audio_url: audio_url, description: description, topic_name: topic_name, duration: duration, post_id: String(post_id), like_flag: like_flag, like_count: like_count, reply_count: reply_count, tag_list: tag_list, otherurl: otherurl)
                        self.postDataArray.append(postItem)
                    }
                    print(self.audioUrlArray)
                    self.tblViewHome.dataSource = self
                    self.tblViewHome.delegate = self
                    self.tblViewHome.prefetchDataSource = self
                    
                    UIView.setAnimationsEnabled(false)
                    self.tblViewHome.beginUpdates()
                    self.tblViewHome.reloadSections(NSIndexSet(index: 0) as IndexSet, with: UITableViewRowAnimation.none)
                    self.tblViewHome.endUpdates()
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
                _ = SweetAlert().showAlert("ESCALATE", subTitle: "Something went wrong.Please try again!", style: AlertStyle.error)
                Indicator.shared.hideProgressView()
            })
        }else{
            _ = SweetAlert().showAlert("ESCALATE", subTitle: "No interter connection!", style: AlertStyle.error)
            Indicator.shared.hideProgressView()
        }
    }
    
    @objc func stopRecordingAndPlaying(_ notification: Notification) {
        
        
        if(isPlaying)
        {
            let btnTag = UserDefaults.standard.value(forKey: "ASABTNTAG") as? Int ?? 0
            
            
            
            let indexPath = IndexPath(row: btnTag, section: 0)
            
            guard let cell = tblViewHome.cellForRow(at: indexPath) as? HomeTableViewCell else {
                
                return
            }
            
            
            
            player!.pause()
            
            timerCountASa?.invalidate()
            timerCountASa = nil
            timerASa?.invalidate()
            timerASa = nil
            sec = 0
            hr = 0
            min = 0
            
            cell.btnPlayPausedRef.setImage(#imageLiteral(resourceName: "home_play_a"), for: .normal)
            
            isPlaying = false
            cell.audioView.amplitude = 0.0
            
            let totalTimeString = String(format: "%02d:%02d", min, sec)
            cell.lblTotalTimer.text = totalTimeString
        }
        
        
        
        
    }
    
    
    
    
    
    
    
    @objc func refreshListAfterSearch(_ notification: Notification) {
        
        
        if rowNumber < postDataArray.count{
            
            
            var replyCounts = Int(postDataArray[rowNumber].reply_count as? String ?? "") as? Int ?? 0
            print(replyCounts)
            
            replyCounts = replyCounts + 1
            
            
            let indexPath = IndexPath(row: rowNumber, section: 0)
            
            
            guard let cell = self.tblViewHome.cellForRow(at: indexPath) as? HomeTableViewCell else {
                
                return
            }
            
            
            
            cell.btnViewAllReplyRef.setTitle("View all \(replyCounts) replies", for: .normal)
            
            
        }
            
        else{
            print("Do nothing")
        }
        
        
        
        
    }
    
    
    
    func postLikeDislike(audio_id:String,index:Int){
        
        
        let infoArray = UserDefaults.standard.value(forKey: "USERINFO") as? NSArray ?? []
        print(infoArray)
        let infoDict = infoArray.object(at: 0) as? NSDictionary ?? [:]
        
        print(infoDict)
        
        let user_id = infoDict.value(forKey: "user_id") as? String ?? ""
        
        print(user_id)
        
        let token = infoDict.value(forKey: "token") as? String ?? ""
        
        let passDict = ["audio_id":audio_id,
                        "user_id":user_id,
                        "token":token] as! [String : AnyObject]
        
        print(passDict)
        
        if InternetConnection.internetshared.isConnectedToNetwork() {
            
           // Indicator.shared.showProgressView(self.view)
            
            WebserviceConnection.requestPOSTURL("likepost", params: passDict as [String : AnyObject], headers:nil, success: { (responseJson) in
                
                if responseJson["status"].stringValue == "SUCCESS" {
                    
                    Indicator.shared.hideProgressView()
                    
                    print(responseJson["status"])
                    print(responseJson)
                    
                    
                    let responseDict = responseJson["data"].dictionaryObject as? NSDictionary ?? [:]
                    
                    let likeflag = responseDict.object(forKey: "likeflag") as? String ?? ""
                    
                    let likecount = responseDict.object(forKey: "likecount") as? String ?? ""
                    
                    print(likecount)
                    let dataDict = self.postDataArray[index]
                    
                    
                    
                    
                    dataDict.like_flag = likeflag
                    
                    dataDict.like_count = likecount
                    
                    
                    let indexPath = IndexPath(row: index, section: 0)
                    
                    guard let cell = self.tblViewHome.cellForRow(at: indexPath) as? HomeTableViewCell else {
                        
                        return
                    }
                    
                    
                    //                    let indexPath = IndexPath(row: index, section: 0)
                    //                    let cell = self.tblViewHome.cellForRow(at: indexPath) as! HomeTableViewCell
                    
                    
                    
                    
                    
                    if cell.btnLikeRef.imageView?.image == #imageLiteral(resourceName: "home_like_unselected"){
                        
                        
                        cell.btnLikeRef.setImage(#imageLiteral(resourceName: "home_like"), for: .normal)
                        cell.lblTotalLikes.text = "\(dataDict.like_count!) Likes"
                        
                        
                        
                        
                    }else{
                        
                        
                        
                        cell.btnLikeRef.setImage(#imageLiteral(resourceName: "home_like_unselected"), for: .normal)
                        
                        cell.lblTotalLikes.text = "\(dataDict.like_count!) Likes"
                    }
                    
                    
                    
                    
                    
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
                Indicator.shared.hideProgressView()
                _ = SweetAlert().showAlert("Escalate", subTitle: "Something went wrong.Please try again!", style: AlertStyle.error)
                self.dismiss(animated: true, completion: nil)
                
                
            })
            
            
        }else{
            
            _ = SweetAlert().showAlert("Escalate", subTitle: "No interter connection!", style: AlertStyle.error)
            
            
        }
        
        
        
    }
    
    //COUNTER FOR WAVE AND AUDIO TIME
    
    func countDownTimet(){
        
        timerCountASa = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.update), userInfo: nil, repeats: true)
        
    }
    
    
    @objc func update() {
        
        
        let btnTag = UserDefaults.standard.value(forKey: "ASABTNTAG") as? Int ?? 0
        
        let indexPath = IndexPath(row: btnTag, section: 0)
        
        let dataDict = postDataArray[btnTag]
        
        
        guard let cell = tblViewHome.cellForRow(at: indexPath) as? HomeTableViewCell else {
            
            return
        }
        
        
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
            cell.lblTotalTimer.text = totalTimeString
            
        }
        else{
            print("TIMERCOUNT")
            print(count)
            sec = 0
            hr = 0
            min = 0
            
            timerASa?.invalidate()
            timerASa = nil
            timerCountASa?.invalidate()
            timerCountASa = nil
            
            let totalTimeString = dataDict.duration ?? ""
            cell.lblTotalTimer.text = totalTimeString
            
            
            cell.btnPlayPausedRef.setImage(UIImage(named: "home_play_a"),for: .normal)
            
            cell.audioView.amplitude = 0.0
            isPlaying = false
            //STOP PLAYING AND ANIMATION
            
            //autoPlayList()
            
            
            
            
            
            
        }
    }
    
    
    //MARK:- ACTIONS
    //MARK:
    
    
    
    
  
    

   
    
    @IBAction func btnNotificationTapped(_ sender: UIButton) {
        
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "NotificationsVC") as! NotificationsVC
        
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    
    
    
    @IBAction func btnBackTapped(_ sender: UIButton) {
        
        
        
        if(isPlaying)
        {
            let btnTag = UserDefaults.standard.value(forKey: "ASABTNTAG") as? Int ?? 0
            
            
            
            let indexPath = IndexPath(row: btnTag, section: 0)
            
            guard let cell = tblViewHome.cellForRow(at: indexPath) as? HomeTableViewCell else {
                
                return
            }
            
            
            
            player!.pause()
            
            timerCountASa?.invalidate()
            timerCountASa = nil
            timerASa?.invalidate()
            timerASa = nil
            sec = 0
            hr = 0
            min = 0
            
            cell.btnPlayPausedRef.setImage(#imageLiteral(resourceName: "home_play_a"), for: .normal)
            
            isPlaying = false
            cell.audioView.amplitude = 0.0
            
            let totalTimeString = String(format: "%02d:%02d", min, sec)
            cell.lblTotalTimer.text = totalTimeString
        }
        
        self.navigationController?.popViewController(animated: true)
        
        
        
        
    }
    
    
    
    
    
    
    
    
    
    
    //MARK:- TABLEVIEW CELL BUTTONS ACTIONS
    //MARK:
    
    @objc func btnLikeTapped(sender: UIButton){
        print(sender.tag)
        
        listButtonTapped = true
        rowNumber = sender.tag
        
        
        
        let dataDict = postDataArray[sender.tag]
        
        
        let audioID = dataDict.post_id ?? ""
        
        
        
        
        print(audioID)
        
        postLikeDislike(audio_id: audioID, index: sender.tag)
        
        
        
    }
    
    
    
    @objc func btnOtherProfileTapped(sender: UIButton){
        print(sender.tag)
        
        print("aman")
        
        
        let dataDict = postDataArray[sender.tag]
        
        print(dataDict)
        
        let userID = dataDict.user_id ?? ""
        
        
        
        
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "OtherProfileVC") as! OtherProfileVC
        
        vc.user_id = userID
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func buttonSelected(sender: UIButton){
        print(sender.tag)
    }
    
    @objc func btnPlayPausedTapped(sender: UIButton){
        
        UserDefaults.standard.set(sender.tag, forKey: "ASABTNTAG")
        currentAudioIndex = sender.tag
        
        timerCountASa?.invalidate()
        timerCountASa = nil
        timerASa?.invalidate()
        timerASa = nil
        
        
        let prevTag = UserDefaults.standard.value(forKey: "ASAPBTNTAG") as? Int ?? 0
        print(prevTag)
        let btnTag = UserDefaults.standard.value(forKey: "ASABTNTAG") as? Int ?? 0
        
        print(btnTag)
        
        if btnTag != prevTag{
            
            
            if(isPlaying)
            {
                
                
                let prevIndexPath = IndexPath(row: prevTag, section: 0)
                guard let prevCell = tblViewHome.cellForRow(at: prevIndexPath) as? HomeTableViewCell else {
                    
                    return
                }
                
                
                
                //player!.pause()
                
                timerCountASa?.invalidate()
                timerCountASa = nil
                timerASa?.invalidate()
                timerASa = nil
                sec = 0
                hr = 0
                min = 0
                
                
                
                prevCell.btnPlayPausedRef.setImage(#imageLiteral(resourceName: "home_play_a"), for: .normal)
                prevCell.audioView.amplitude = 0.0
                
                let totalTimeString = String(format: "%02d:%02d", min, sec)
                prevCell.lblTotalTimer.text = totalTimeString
                
                isPlaying = false
                
                
                
            }else{
                
            }
            
            
            
        }
        
        
        
        
        
        
        let indexPath = IndexPath(row: btnTag, section: 0)
        let cell = tblViewHome.cellForRow(at: indexPath) as! HomeTableViewCell
        
        
        
        
        let dataDict = postDataArray[sender.tag]
        
        
        
        audioUrl = NSURL(string: dataDict.otherurl ?? "")! as URL
        
        
        
        print(audioUrl)
        
        
        if(isPlaying)
        {
            
            player!.pause()
            
            timerCountASa?.invalidate()
            timerCountASa = nil
            timerASa?.invalidate()
            timerASa = nil
            sec = 0
            hr = 0
            min = 0
            
            cell.btnPlayPausedRef.setImage(#imageLiteral(resourceName: "home_play_a"), for: .normal)
            
            isPlaying = false
            cell.audioView.amplitude = 0.0
            
            let totalTimeString = String(format: "%02d:%02d", min, sec)
            cell.lblTotalTimer.text = totalTimeString
        }
        else
        {
            if audioUrl != nil
            {
                
                
                
                
                let playerItem:AVPlayerItem = AVPlayerItem(url: audioUrl!)
                player = AVPlayer(playerItem: playerItem)
                
                //                 playerItem.delegate = self
                
                
                let asset = AVAsset(url: audioUrl)
                
                let duration = asset.duration
                let durationTime = CMTimeGetSeconds(duration)
                count = Int(ceil(durationTime))
                
                
                countDownTimet()
                
                
                
                
                
                timerASa = Timer.scheduledTimer(timeInterval: 0.009, target: self, selector: #selector(self.refreshAudioView(_:)), userInfo: nil, repeats: true)
                
                cell.btnPlayPausedRef.setImage(UIImage(named: "home_pause_a"),for: .normal)
                player!.play()
                
                
                isPlaying = true
            }
            else
            {
                
                
                _ = SweetAlert().showAlert("Escalate", subTitle: "Audio file is missing.", style: AlertStyle.error)
                
            }
        }
        
        
        let prevBtnTag = UserDefaults.standard.value(forKey: "ASABTNTAG") as? Int ?? 0
        
        print(prevBtnTag)
        
        UserDefaults.standard.set(prevBtnTag, forKey: "ASAPBTNTAG")
        
        
        
        
        
    }
    
    @objc internal func refreshAudioView(_:Timer) {
        
        let btnTag = UserDefaults.standard.value(forKey: "ASABTNTAG") as? Int ?? 0
        
        
        let indexPath = IndexPath(row: btnTag, section: 0)
        
        
        guard let cell = tblViewHome.cellForRow(at: indexPath) as? HomeTableViewCell else {
            
            return
        }
        
        
        
        if cell.audioView.amplitude <= cell.audioView.idleAmplitude || cell.audioView.amplitude > 1.0 {
            self.change *= -1.0
        }
        
        
        cell.audioView.amplitude += self.change
        
        
        
        
    }
    
    
    
    
    
    
    @objc func btnCommentTapped1(sender: UIButton){
        
        
        rowNumber = sender.tag
        
        
        
        if(isPlaying)
        {
            let btnTag = UserDefaults.standard.value(forKey: "ASABTNTAG") as? Int ?? 0
            
            
            
            let indexPath = IndexPath(row: btnTag, section: 0)
            
            guard let cell = tblViewHome.cellForRow(at: indexPath) as? HomeTableViewCell else {
                
                return
            }
            
            
            
            player!.pause()
            
            timerCountASa?.invalidate()
            timerCountASa = nil
            timerASa?.invalidate()
            timerASa = nil
            sec = 0
            hr = 0
            min = 0
            
            cell.btnPlayPausedRef.setImage(#imageLiteral(resourceName: "home_play_a"), for: .normal)
            
            isPlaying = false
            cell.audioView.amplitude = 0.0
            
            let totalTimeString = String(format: "%02d:%02d", min, sec)
            cell.lblTotalTimer.text = totalTimeString
        }
        
        
        UserDefaults.standard.set("FROMAFTERSEARCH", forKey: "ISCOMINGFORNOTIFICATION")
        print(sender.tag)
        
        rowNumber = sender.tag
        
        
        let dataDict = postDataArray[sender.tag]
        
        
        print(dataDict)
        
        
        
        
        
        
        
        
        
        let audioID = dataDict.post_id ?? ""
        let user_id = dataDict.user_id ?? ""
        let user_image = dataDict.user_image ?? ""
        let fullname = dataDict.fullname ?? ""
        let tag_list = dataDict.tag_list ?? ""
        let audio_url = dataDict.audio_url ?? ""
        let otherurl = dataDict.otherurl ?? ""
        let duration = dataDict.duration ?? ""
        let descriptionPost = dataDict.description ?? ""
        
        
        
        
        
        print(audioID)
        
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "CommentsWithPostVC") as! CommentsWithPostVC
        
        vc.audioID = audioID
        print(vc.audioID)
        
        //vc.user_id = user_id
        
        vc.user_image = user_image
        
        vc.fullname = fullname
        
        vc.tag_list = tag_list
        
        vc.audio_url = otherurl
        
        vc.duration = duration
        
        vc.descriptionPost = descriptionPost
        
        
        
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    
    
    
    
    
    @objc func btnCommentTapped(sender: UIButton){
        
        
        rowNumber = sender.tag
        
        
        if(isPlaying)
        {
            let btnTag = UserDefaults.standard.value(forKey: "ASABTNTAG") as? Int ?? 0
            
            
            
            let indexPath = IndexPath(row: btnTag, section: 0)
            
            guard let cell = tblViewHome.cellForRow(at: indexPath) as? HomeTableViewCell else {
                
                return
            }
            
            
            
            player!.pause()
            
            timerCountASa?.invalidate()
            timerCountASa = nil
            timerASa?.invalidate()
            timerASa = nil
            sec = 0
            hr = 0
            min = 0
            
            cell.btnPlayPausedRef.setImage(#imageLiteral(resourceName: "home_play_a"), for: .normal)
            
            isPlaying = false
            cell.audioView.amplitude = 0.0
            
            let totalTimeString = String(format: "%02d:%02d", min, sec)
            cell.lblTotalTimer.text = totalTimeString
        }
        
        
        
        
        UserDefaults.standard.set("FROMAFTERSEARCH", forKey: "ISCOMINGFORNOTIFICATION")
        print(sender.tag)
        
        rowNumber = sender.tag
        
        
        let dataDict = postDataArray[sender.tag]
        
        
        
        let audioID = dataDict.post_id ?? ""
        
        
        
        print(audioID)
        
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "CommentMikeVC") as! CommentMikeVC
        
        vc.audioID = audioID
        print(vc.audioID )
        
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    @objc func btnShareTapped(sender: UIButton){
        print(sender.tag)
        let dataDict = postDataArray[sender.tag]
        
        
        
        let audioUrl = dataDict.otherurl ?? ""
        
        
        
        print(audioUrl)
        
        // let vc = UIActivityViewController(activityItems: [shareText, image], applicationActivities: [])
        
        let vc = UIActivityViewController(activityItems: [audioUrl], applicationActivities: [])
        
        present(vc, animated: true)
        
        print(sender.tag)
        
    }
    
    
    @objc func btnReplyTapped(sender: UIButton){
        
        
        UserDefaults.standard.set("FROMAFTERSEARCH", forKey: "ISCOMINGFORNOTIFICATION")
        print(sender.tag)
        
        rowNumber = sender.tag
        
        
        if(isPlaying)
        {
            let btnTag = UserDefaults.standard.value(forKey: "ASABTNTAG") as? Int ?? 0
            
            
            
            let indexPath = IndexPath(row: btnTag, section: 0)
            
            guard let cell = tblViewHome.cellForRow(at: indexPath) as? HomeTableViewCell else {
                
                return
            }
            
            
            
            player!.pause()
            
            timerCountASa?.invalidate()
            timerCountASa = nil
            timerASa?.invalidate()
            timerASa = nil
            sec = 0
            hr = 0
            min = 0
            
            cell.btnPlayPausedRef.setImage(#imageLiteral(resourceName: "home_play_a"), for: .normal)
            
            isPlaying = false
            cell.audioView.amplitude = 0.0
            
            let totalTimeString = String(format: "%02d:%02d", min, sec)
            cell.lblTotalTimer.text = totalTimeString
        }
        
        
        
        
        let dataDict = postDataArray[sender.tag]
        
        
        
        let audioID = dataDict.post_id ?? ""
        
        
        
        print(audioID)
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "RepliesVC") as! RepliesVC
        
        vc.audioID = audioID
        
        
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    
    
}





//MARK:- EXTENTION TABLE VIEW
//MARK:

extension AfterSearchPostListVC:UITableViewDelegate,UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return postDataArray.count
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        
        //        let dataDict = postDataArray[btnTag]
        
        if(isPlaying)
        {
            
            
            let btnTag = UserDefaults.standard.value(forKey: "ASABTNTAG") as? Int ?? 0
            let indexPath = IndexPath(row: btnTag, section: 0)
            
            guard let cell = tblViewHome.cellForRow(at: indexPath) as? HomeTableViewCell else {
                
                return
            }
            
            
            
            player!.pause()
            
            timerCountASa?.invalidate()
            timerCountASa = nil
            timerASa?.invalidate()
            timerASa = nil
            sec = 0
            hr = 0
            min = 0
            
            cell.btnPlayPausedRef.setImage(#imageLiteral(resourceName: "home_play_a"), for: .normal)
            
            isPlaying = false
            cell.audioView.amplitude = 0.0
            
            let totalTimeString = String(format: "%02d:%02d", min, sec)
            cell.lblTotalTimer.text = totalTimeString
        }
        
        
        
    }
    
    
    
    
    
    
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        print("Prefetch: \(indexPaths)")
        
        for indexPath in indexPaths {
            
            let obj = self.postDataArray[indexPath.row]
            
            print(obj)
            //            let obj = self.receivedData[indexPath.row] as String
            //            self.dataArray[indexPath.row] = obj as String
            //            print("update upcoming \(self.dataArray[indexPath.row])")
        }
        
        
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        tblViewHome.register(UINib(nibName: "HomeTableViewCell", bundle: nil), forCellReuseIdentifier: "HomeTableViewCell")
        
        
        let cell = tblViewHome.dequeueReusableCell(withIdentifier: "HomeTableViewCell", for: indexPath) as! HomeTableViewCell
        
        if postDataArray.count > 0{
            
        
            let dataDict = postDataArray[indexPath.row]
            
            let image = dataDict.user_image ?? ""
            
            cell.imgView_user.sd_setImage(with: URL(string: image as? String ?? ""), placeholderImage: UIImage(named: "user_signup"))
            
            cell.lblFullName.text = dataDict.fullname ?? ""
            
            cell.lblDescription.text = dataDict.description ?? ""
            
            cell.lblUserName.text = dataDict.tag_list ?? ""
            
            
            //            cell.lblUserName.text = "@\(dataDict.username ??  "")"
            
            let likes = dataDict.like_count ?? ""
            
            if likes == "0"{
                cell.lblTotalLikes.text = "\(dataDict.like_count ?? "") Like"
            }else if likes == "1"{
                cell.lblTotalLikes.text = "\(dataDict.like_count ?? "") Like"
            }else{
                cell.lblTotalLikes.text = "\(dataDict.like_count ?? "") Likes"
            }
            
            
            
            
            let reply_count = dataDict.reply_count ?? ""
            
            if reply_count == "0" || reply_count == ""{
                
                cell.btnViewAllReplyRef.isHidden = true
                
            }else{
                
                cell.btnViewAllReplyRef.isHidden = false
                
                if reply_count == "1"{
                    cell.btnViewAllReplyRef.setTitle("\(dataDict.reply_count ?? "") reply", for: .normal)
                }else{
                    cell.btnViewAllReplyRef.setTitle("\(dataDict.reply_count ?? "") replies", for: .normal)
                }
                
            }
            
            
            cell.lblTotalTimer.text = dataDict.duration ?? ""
            
            
            //            let duration = Int(dataDict.duration ?? "") ?? 0
            //
            //            if duration < 10{
            //
            //                cell.lblTotalTimer.text = "00:00:0\(duration)"
            //            }else{
            //                cell.lblTotalTimer.text = "00:00:\(duration)"
            //            }
            //
            
//            if dataDict.reply_count == "0"{
//                
//                cell.btnReplyRef.isHidden = true
//            }
//            else{
//                cell.btnReplyRef.isHidden = false
//            }
            
            if dataDict.like_flag == "0"{
                
                cell.btnLikeRef.setImage(#imageLiteral(resourceName: "home_like"), for: .normal)
                
                
                
            }else{
                cell.btnLikeRef.setImage(#imageLiteral(resourceName: "home_like_unselected"), for: .normal)
            }
            
            if dataDict.user_id == self.user_id  {
                
                cell.btnOtherProfileRef.isHidden = true
            }
            else{
                cell.btnOtherProfileRef.isHidden = false
            }
            
            
            cell.btnLikeRef.tag = indexPath.row
            cell.btnLikeRef.addTarget(self, action: #selector(btnLikeTapped), for: .touchUpInside)
            
            cell.btnOtherProfileRef.tag = indexPath.row
            cell.btnOtherProfileRef.addTarget(self, action: #selector(btnOtherProfileTapped), for: .touchUpInside)
            
            cell.btnPlayPausedRef.tag = indexPath.row
            cell.btnPlayPausedRef.addTarget(self, action: #selector(btnPlayPausedTapped), for: .touchUpInside)
            
            cell.btnCommentRef.tag = indexPath.row
            cell.btnCommentRef.addTarget(self, action: #selector(btnCommentTapped1), for: .touchUpInside)
            
            cell.btnShareRef.tag = indexPath.row
            cell.btnShareRef.addTarget(self, action: #selector(btnShareTapped), for: .touchUpInside)
            
            cell.btnReplyRef.tag = indexPath.row
            cell.btnReplyRef.addTarget(self, action: #selector(btnCommentTapped), for: .touchUpInside)
            
            
            cell.btnViewAllReplyRef.tag = indexPath.row
            cell.btnViewAllReplyRef.addTarget(self, action: #selector(btnReplyTapped), for: .touchUpInside)
            
            
            
            
            
        }
        
        return cell
        
        
    }
    

    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableViewAutomaticDimension
        
    }
    
}


