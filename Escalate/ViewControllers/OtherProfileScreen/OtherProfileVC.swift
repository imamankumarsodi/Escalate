//
//  OtherProfileVC.swift
//  Escalate
//
//  Created by call soft on 19/07/18.
//  Copyright © 2018 call soft. All rights reserved.
//

import UIKit

import SDWebImage

import AVFoundation

import SwiftSiriWaveformView

import RealmSwift

class OtherProfileVC: UIViewController,AVAudioRecorderDelegate, AVAudioPlayerDelegate {
    
    
    
    //MARK:- OUTLETS
    //MARK:
    
    
    @IBOutlet weak var viewPostCounts: UIView!
    
    @IBOutlet weak var lblPosts: UILabel!
    
    @IBOutlet weak var viewFollowers: UIView!
    
    
    @IBOutlet weak var lblFollowers: UILabel!
    
    
    @IBOutlet weak var viewFollowing: UIView!
    
    @IBOutlet weak var lblFollowings: UILabel!
    
    
    
    
    
    
    @IBOutlet weak var btnFollowRef: UIButton!
    
    @IBOutlet weak var lblFullname: UILabel!
    
    @IBOutlet weak var lblUserName: UILabel!
    
    @IBOutlet weak var lblCategories: UILabel!
    
    @IBOutlet weak var lblFollowersCount: UILabel!
    
    @IBOutlet weak var imgProfile: UIImageView!
    
    
    @IBOutlet var tblViewProfile: UITableView!
    
    
    @IBOutlet weak var lblFollowingCount: UILabel!
    

    @IBOutlet weak var btnPlayRef: UIButton!
    
    @IBOutlet weak var lblRecordingTime: UILabel!
    
    @IBOutlet weak var audioView: SwiftSiriWaveformView!
    
    @IBOutlet weak var lblPostsCount: UILabel!
    
  
    
    
    
    
    
    
    //MARK:- VARIABLES
    //MARK:
    
    
    var userDict = NSDictionary()
    
     var login_user_id = ""
    
    var audioUrlString = ""
    
    var tag = 1
    
    let WebserviceConnection  = AlmofireWrapper()
    
    var user_id = ""
    
    var audioUrl: URL!
    
     var isPlaying = false
    
    var timerA:Timer?
    
    var change:CGFloat = 0.01
    
    var timerCountA:Timer?
    var count = 0
    var hr = 0
    var min = 0
    var sec = 0
    
    var dataArray = NSArray()
    
    
    var player:AVPlayer?
    var playerItem:AVPlayerItem?
    var postDataArray = [SavedPostsDataModel]()
    
    //TABLEVIEW VARIABLES
    var isPlaying1 = false
    
    var audioUrl1: URL!
    
    var timerB:Timer?
    
    var change1:CGFloat = 0.01
    
    var timerCountB:Timer?
    var count4 = 0
    var hr1 = 0
    var min1 = 0
    var sec1 = 0
    
    
    var player1:AVPlayer?
    var playerItem1:AVPlayerItem?
    
    
    var rowNumber = Int()
    
    var listButtonTapped = false
    
    var count1 = 0
    
    
    //VARIABLES FOR FOLLOWING
    
    
    var followingArray = [FollowingFollowerDataModel]()
    
    var timerCountC:Timer?
    
    
    var isPlaying2 = false
    
    var bioURL1: URL!
    
    
    var player2:AVPlayer?
    
    
    
    //VARIABLES FOR FOLLOWERS
    
    var followersArray = [FollowingFollowerDataModel]()
    
    var timerCountD:Timer?
    
    var isPlaying3 = false
    
    var bioURL2: URL!
    
    
    var player3:AVPlayer?
    
    //VARIABLES FOR CHATTING
    let realm = try! Realm()
   
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

         NotificationCenter.default.addObserver(self, selector: #selector(OtherProfileVC.stopRecordingAndPlaying(_:)), name: NSNotification.Name(rawValue: "stopRecordingAndPlaying"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(OtherProfileVC.refreshListOtherProfile(_:)), name: NSNotification.Name(rawValue: "refreshListOtherProfile"), object: nil)
        viewProfile()
       // userPostList()
        
        // viewProfile()
        // Do any additional setup after loading the view.
    }
    
//    override var prefersStatusBarHidden: Bool {
//        return true
//    }
    
    override func viewWillAppear(_ animated: Bool) {
        viewProfile()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    //MARK:- METHODS
    //MARK:
    
    
    
    func stopTableAudio(){
        
        
        if(isPlaying1)
        {
            let btnTag = UserDefaults.standard.value(forKey: "OBTNTAG") as? Int ?? 0
            
            
             let dataDict = postDataArray[btnTag]
            let indexPath = IndexPath(row: btnTag, section: 0)
            
            guard let cell = tblViewProfile.cellForRow(at: indexPath) as? ProfileTableViewCell else {
                
                return
            }
            
            
            
            player1!.pause()
            
            timerCountB?.invalidate()
            timerCountB = nil
            timerB?.invalidate()
            timerB = nil
            sec1 = 0
            hr1 = 0
            min1 = 0
            
            cell.btnPlayPausedRef.setImage(#imageLiteral(resourceName: "home_play_a"), for: .normal)
            
            isPlaying1 = false
            cell.audioView.amplitude = 0.0
            
            cell.lblTotalTimer.text = dataDict.duration
        }
        
    }
    
    
    
    func stopFollowingTable(){
        
        
        
        
        let btnTag = UserDefaults.standard.value(forKey: "OFOLLOWINGBTNTAG") as? Int ?? 0
        
        print(btnTag)
        
        if(isPlaying2)
        {
            
            
            let btnTag = UserDefaults.standard.value(forKey: "OFOLLOWINGBTNTAG") as? Int ?? 0
            
            print(btnTag)
            
            let prevIndexPath = IndexPath(row: btnTag, section: 0)
            guard let prevCell = tblViewProfile.cellForRow(at: prevIndexPath) as? FollowFollowingXibAndCe else {
                
                return
            }
            
            
            player2!.pause()
            
            timerCountC?.invalidate()
            timerCountC = nil
            
            
            prevCell.btnPlayBioRef.setImage(#imageLiteral(resourceName: "home_play_a"), for: .normal)
            
            
            isPlaying2 = false
            
            
            
        }
        
        
    }
    
    
    
    func stopFollowerTable(){
        
        
        if(isPlaying3)
        {
            
            let btnTag = UserDefaults.standard.value(forKey: "ORFOLLOWINGBTNTAG") as? Int ?? 0
            
            print(btnTag)
            
            let prevIndexPath = IndexPath(row: btnTag, section: 0)
            guard let prevCell = tblViewProfile.cellForRow(at: prevIndexPath) as? FollowFollowingXibAndCe else {
                
                return
            }
            
            
            
            player3!.pause()
            
            timerCountD?.invalidate()
            timerCountD = nil
            
            
            prevCell.btnPlayBioRef.setImage(#imageLiteral(resourceName: "home_play_a"), for: .normal)
            
            
            isPlaying3 = false
            
            
            
        }
        
        
        
        
    }
    
    
    
    
    
    func playBioFromAPI(){
        

        stopFollowerTable()
        
        stopFollowingTable()
        
        stopTableAudio()
        
        
        
        
        print(audioUrlString)
        if audioUrlString != ""{
        
        
        if(isPlaying)
        {
            
            player!.pause()
            
            timerCountA?.invalidate()
            timerCountA = nil
            timerA?.invalidate()
            timerA = nil
            sec = 0
            hr = 0
            min = 0
            
            btnPlayRef.setImage(UIImage(named: "home_play_a"),for: .normal)
            isPlaying = false
            audioView.amplitude = 0.0
            
            let totalTimeString = self.userDict.value(forKey: "bio_duration") as? String ?? ""
            lblRecordingTime.text = totalTimeString
        }
        else
        {
            if audioUrl != nil
            {
                let playerItem:AVPlayerItem = AVPlayerItem(url: audioUrl!)
                player = AVPlayer(playerItem: playerItem)
                
                
                let asset = AVAsset(url: audioUrl)
                
                let duration = asset.duration
                let durationTime = CMTimeGetSeconds(duration)
                count = Int(ceil(durationTime))
                
                countDownTimet()
                timerA = Timer.scheduledTimer(timeInterval: 0.009, target: self, selector: #selector(self.refreshAudioView(_:)), userInfo: nil, repeats: true)
                
                btnPlayRef.setImage(UIImage(named: "home_pause_a"),for: .normal)
                player!.play()
                
                
                isPlaying = true
            }
            else
            {
                
                
                _ = SweetAlert().showAlert("Escalate", subTitle: "Bio not recorded yet!", style: AlertStyle.error)
                //display_alert(msg_title: "Error", msg_desc: "Audio file is missing.", action_title: "OK")
            }
        }
        }
        else{
            _ = SweetAlert().showAlert("Escalate", subTitle: "Bio not recorded yet!", style: AlertStyle.error)
        }
        
        
        
        
    }
    
    

    //TODO:- WEB SERVICES
    
    
    
    
    
    func reportUserAPI() {
        
        
        let infoArray = UserDefaults.standard.value(forKey: "USERINFO") as? NSArray ?? []
        //print(infoArray)
        let infoDict = infoArray.object(at: 0) as? NSDictionary ?? [:]
        
        //print(infoDict)
        
        let token = infoDict.value(forKey: "token") as? String ?? ""
        
        print(token)
        
        let loginUser_id = infoDict.value(forKey: "user_id") as? String ?? ""
        
        print(user_id)
        
        
        let passDict = ["user_id":"\(loginUser_id)",
            "reported_user_id":"\(user_id)",
            "token":"\(token)"] as! [String : AnyObject]
        
        
        
        
        print(passDict)
        
        if InternetConnection.internetshared.isConnectedToNetwork() {
            
            Indicator.shared.showProgressView(self.view)
            
            WebserviceConnection.requestPOSTURL("reportuser", params: passDict as [String : AnyObject], headers:nil, success: { (responseJson) in
                
                if responseJson["status"].stringValue == "SUCCESS" {
                    
                    Indicator.shared.hideProgressView()
                    
                    print(responseJson["status"])
                    print(responseJson)
                     let message  = responseJson["message"].stringValue
                    
                    _ = SweetAlert().showAlert("Escalate", subTitle: "\(message)", style: AlertStyle.success)
                    //self.navigationController?.popViewController(animated: true)
                    
                    
                    
                    
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
    
    
    
    
    
    
    
    
    func followUnfollowingService(user_id:String,index:Int) {
        
        //                follower_id:2
        //                user_id:7
        //                token:brQgz96SV40ES8ZeR2M0FvBk7
        
        
        
        let infoArray = UserDefaults.standard.value(forKey: "USERINFO") as? NSArray ?? []
        //print(infoArray)
        let infoDict = infoArray.object(at: 0) as? NSDictionary ?? [:]
        
        //print(infoDict)
        
        let token = infoDict.value(forKey: "token") as? String ?? ""
        
        print(token)
        
        let loginUser_id = infoDict.value(forKey: "user_id") as? String ?? ""
        
        print(user_id)
        
        
        let passDict = ["follower_id":"\(loginUser_id)",
            "user_id":"\(user_id)",
            "token":"\(token)"] as! [String : AnyObject]
        
        
        //        let passDict = ["follower_id":"\(user_id)",
        //                        "user_id":"\(loginUser_id)",
        //                        "token":"\(token)"] as! [String : AnyObject]
        
        print(passDict)
        
        if InternetConnection.internetshared.isConnectedToNetwork() {
            
            Indicator.shared.showProgressView(self.view)
            
            WebserviceConnection.requestPOSTURL("follow", params: passDict as [String : AnyObject], headers:nil, success: { (responseJson) in
                
                if responseJson["status"].stringValue == "SUCCESS" {
                    
                    Indicator.shared.hideProgressView()
                    
                    print(responseJson["status"])
                    print(responseJson)
                    
                    let dataDict = responseJson["data"].dictionaryObject as? NSDictionary ?? [:]
                    
                    
                    let indexPath = IndexPath(row: index, section: 0)
                    let cell = self.tblViewProfile.cellForRow(at: indexPath) as! FollowFollowingXibAndCe
                    
                    
                    if self.tag == 2{
                        
                        
                        if cell.btnFollowRef.titleLabel?.text == "Follow"{
                            
                            
                            cell.btnFollowRef.setTitle("Unfollow", for: .normal)
                            cell.btnFollowRef.backgroundColor = UIColor(red: 110/255, green: 196/255, blue: 124/255, alpha: 1)
                            let recentSearchModelArray = self.realm.objects(RecentSearchModel.self)
                            for item in recentSearchModelArray{
                                if item.type == "people"{
                                    if item.user_id == user_id{
                                        if item.follower_flag == "0"{
                                            
                                            do{
                                                try self.realm.write {
                                                    print(item.follower_flag)
                                                    item.follower_flag = "1"
                                                    print(item.follower_flag)
                                                }
                                            }catch{
                                                print("Error in saving data :- \(error.localizedDescription)")
                                            }
                                        }else{
                                            
                                            do{
                                                try self.realm.write {
                                                    print(item.follower_flag)
                                                    item.follower_flag = "0"
                                                    print(item.follower_flag)
                                                }
                                            }catch{
                                                print("Error in saving data :- \(error.localizedDescription)")
                                            }
                                        }
                                    }
                                }
                            }
                            
                        }else{
                            
                            
                            
                            cell.btnFollowRef.setTitle("Follow", for: .normal)
                            
                            cell.btnFollowRef.backgroundColor = UIColor(red: 74/255, green: 37/255, blue: 107/255, alpha: 1)
                            let recentSearchModelArray = self.realm.objects(RecentSearchModel.self)
                            for item in recentSearchModelArray{
                                if item.type == "people"{
                                    if item.user_id == user_id{
                                        if item.follower_flag == "0"{
                                            
                                            do{
                                                try self.realm.write {
                                                    print(item.follower_flag)
                                                    item.follower_flag = "1"
                                                    print(item.follower_flag)
                                                }
                                            }catch{
                                                print("Error in saving data :- \(error.localizedDescription)")
                                            }
                                        }else{
                                            
                                            do{
                                                try self.realm.write {
                                                    print(item.follower_flag)
                                                    item.follower_flag = "0"
                                                    print(item.follower_flag)
                                                }
                                            }catch{
                                                print("Error in saving data :- \(error.localizedDescription)")
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        
                        
                        self.followerList()
                        
                    }else if self.tag == 3{
                        
                        
                        if cell.btnFollowRef.titleLabel?.text == "Follow"{
                            
                            
                            cell.btnFollowRef.setTitle("Unfollow", for: .normal)
                            cell.btnFollowRef.backgroundColor = UIColor(red: 110/255, green: 196/255, blue: 124/255, alpha: 1)
                            let recentSearchModelArray = self.realm.objects(RecentSearchModel.self)
                            for item in recentSearchModelArray{
                                if item.type == "people"{
                                    if item.user_id == user_id{
                                        if item.follower_flag == "0"{
                                            
                                            do{
                                                try self.realm.write {
                                                    print(item.follower_flag)
                                                    item.follower_flag = "1"
                                                    print(item.follower_flag)
                                                }
                                            }catch{
                                                print("Error in saving data :- \(error.localizedDescription)")
                                            }
                                        }else{
                                            
                                            do{
                                                try self.realm.write {
                                                    print(item.follower_flag)
                                                    item.follower_flag = "0"
                                                    print(item.follower_flag)
                                                }
                                            }catch{
                                                print("Error in saving data :- \(error.localizedDescription)")
                                            }
                                        }
                                    }
                                }
                            }
                            
                        }else{
                            
                            
                            
                            cell.btnFollowRef.setTitle("Follow", for: .normal)
                            
                            cell.btnFollowRef.backgroundColor = UIColor(red: 74/255, green: 37/255, blue: 107/255, alpha: 1)
                            let recentSearchModelArray = self.realm.objects(RecentSearchModel.self)
                            for item in recentSearchModelArray{
                                if item.type == "people"{
                                    if item.user_id == user_id{
                                        if item.follower_flag == "0"{
                                            
                                            do{
                                                try self.realm.write {
                                                    print(item.follower_flag)
                                                    item.follower_flag = "1"
                                                    print(item.follower_flag)
                                                }
                                            }catch{
                                                print("Error in saving data :- \(error.localizedDescription)")
                                            }
                                        }else{
                                            
                                            do{
                                                try self.realm.write {
                                                    print(item.follower_flag)
                                                    item.follower_flag = "0"
                                                    print(item.follower_flag)
                                                }
                                            }catch{
                                                print("Error in saving data :- \(error.localizedDescription)")
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        
                        
                        //self.followingList()
                    }
                    
                    
                    self.viewProfile()
                    
                    
                    
                    
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
            
         //   Indicator.shared.showProgressView(self.view)
            
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
                    let cell = self.tblViewProfile.cellForRow(at: indexPath) as! ProfileTableViewCell
                    
                    
                    
                    
                    
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
    
    
    func followingList(){
        
     
        
        if InternetConnection.internetshared.isConnectedToNetwork() {
            
            //Indicator.shared.showProgressView(self.view)
            
            
            
            WebserviceConnection.requestGETURL( "followingList/\(user_id)/\(login_user_id)", success: { (responseJson) in
                
                if responseJson["status"].stringValue == "SUCCESS" {
                    
                    Indicator.shared.hideProgressView()
                    
                    print(responseJson)
                    
                    if self.followingArray.count > 0{
                        
                        self.followingArray.removeAll()
                    }
                    
                    self.dataArray = responseJson["data"].arrayObject as? NSArray ?? []
                    
                    
                    print(self.dataArray)
                    
                    self.lblFollowingCount.text = "\(self.dataArray.count)"
                    
                    
                    //                    var user_id: String?
                    //                    var user_image: String?
                    //                    var fullname: String?
                    //                    var username: String?
                    //                    var bio: String?
                    //                    var follower_flag: String?
                    
                    
                    
                    for item in self.dataArray {
                        
                        let dict = item as? NSDictionary ?? [:]
                        
                        
                        let user_id = dict.object(forKey: "user_id") as? String ?? ""
                        
                        let user_image = dict.object(forKey: "user_image") as? String ?? ""
                        
                        let fullname = dict.object(forKey: "fullname") as? String ?? ""
                        
                        let username = dict.object(forKey: "username") as? String ?? ""
                        
                        let bio = dict.object(forKey: "bio") as? String ?? ""
                        
                        let follower_flag = dict.object(forKey: "follower_flag") as? String ?? ""
                        
                        
                        
                        let followingItems = FollowingFollowerDataModel(user_id: user_id, user_image: user_image, fullname: fullname, username: username, bio: bio, follower_flag: follower_flag)
                        
                        self.followingArray.append(followingItems)
                        
                    }
                    
                    
                    print(self.followingArray)
                    
                    self.tblViewProfile.dataSource = self
                    self.tblViewProfile.delegate = self
                    
                    UIView.setAnimationsEnabled(false)
                    self.tblViewProfile.beginUpdates()
                    self.tblViewProfile.reloadSections(NSIndexSet(index: 0) as IndexSet, with: UITableViewRowAnimation.none)
                    self.tblViewProfile.endUpdates()
                    
                    
                    
                }else{
                    
                    print(responseJson)
                    Indicator.shared.hideProgressView()
                    
                    print("WOW Failure")
                    
                    _ = SweetAlert().showAlert("ESCALATE", subTitle: "Something went wrong!", style: AlertStyle.error)
                    
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
    
    
    
    
    
    
    func followerList(){
        
        
        
        if InternetConnection.internetshared.isConnectedToNetwork() {
            
            //Indicator.shared.showProgressView(self.view)
            
            
            
            WebserviceConnection.requestGETURL("followersList/\(user_id)/\(login_user_id)", success: { (responseJson) in
                
                if responseJson["status"].stringValue == "SUCCESS" {
                    
                    Indicator.shared.hideProgressView()
                    
                    print(responseJson)
                    
                    if self.followersArray.count > 0{
                        
                        self.followersArray.removeAll()
                    }
                    
                    self.dataArray = responseJson["data"].arrayObject as? NSArray ?? []
                    
                    
                    
                    for item in self.dataArray {
                        
                        let dict = item as? NSDictionary ?? [:]
                        
                        
                        let user_id = dict.object(forKey: "user_id") as? String ?? ""
                        
                        let user_image = dict.object(forKey: "user_image") as? String ?? ""
                        
                        let fullname = dict.object(forKey: "fullname") as? String ?? ""
                        
                        let username = dict.object(forKey: "username") as? String ?? ""
                        
                        let bio = dict.object(forKey: "bio") as? String ?? ""
                        
                        let follower_flag = dict.object(forKey: "follower_flag") as? String ?? ""
                        
                        
                        
                        let followerItem = FollowingFollowerDataModel(user_id: user_id, user_image: user_image, fullname: fullname, username: username, bio: bio, follower_flag: follower_flag)
                        self.followersArray.append(followerItem)
                        
                    }
                    
                    
                    self.tblViewProfile.dataSource = self
                    self.tblViewProfile.delegate = self
                    self.tblViewProfile.reloadData()
                    //                    UIView.setAnimationsEnabled(false)
                    //                    self.tblViewProfile.beginUpdates()
                    //                    self.tblViewProfile.reloadSections(NSIndexSet(index: 0) as IndexSet, with: UITableViewRowAnimation.none)
                    //                    self.tblViewProfile.endUpdates()
                    
                    
                    
                }else{
                    
                    print(responseJson)
                    Indicator.shared.hideProgressView()
                    
                    print("WOW Failure")
                    
                    _ = SweetAlert().showAlert("ESCALATE", subTitle: "Something went wrong!", style: AlertStyle.error)
                    
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
    
    
    
    
    
    
    func userPostList(){
        
        
        if InternetConnection.internetshared.isConnectedToNetwork() {
            
            //Indicator.shared.showProgressView(self.view)
            
            
            
            WebserviceConnection.requestGETURL( "audioListbypostnum/\(user_id)/\(user_id)", success: { (responseJson) in
                
                if responseJson["status"].stringValue == "SUCCESS" {
                    
                    Indicator.shared.hideProgressView()
                    
                    print(responseJson)
                    
                    if self.postDataArray.count > 0{
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
                        
                        let description = dict.object(forKey: "description") as? String ?? ""
                        
                        let topic_name = dict.object(forKey: "topic_name") as? String ?? ""
                        
                        let duration = dict.object(forKey: "duration") as? String ?? ""
                        
                        let post_id = dict.object(forKey: "post_id") as? String ?? ""
                        
                        let like_flag = dict.object(forKey: "like_flag") as? String ?? ""
                        
                        let like_count = dict.object(forKey: "like_count") as? String ?? ""
                        
                        let reply_count = dict.object(forKey: "reply_count") as? String ?? ""
                        
                        let tag_list = dict.object(forKey: "tag_list") as? String ?? ""
                        
                        let postItem = SavedPostsDataModel(user_id: user_id, user_image: user_image, fullname: fullname, username: username, audio_url: audio_url, description: description, topic_name: topic_name, duration: duration, post_id: post_id, like_flag: like_flag, like_count: like_count, reply_count: reply_count, tag_list: tag_list,otherurl:otherurl)
                        self.postDataArray.append(postItem)
                        
                    }
                    
                    
                    self.tblViewProfile.dataSource = self
                    self.tblViewProfile.delegate = self
                    
                    UIView.setAnimationsEnabled(false)
                    self.tblViewProfile.beginUpdates()
                    self.tblViewProfile.reloadSections(NSIndexSet(index: 0) as IndexSet, with: UITableViewRowAnimation.none)
                    self.tblViewProfile.endUpdates()
                    
                    
                    
                }else{
                    
                    print(responseJson)
                    Indicator.shared.hideProgressView()
                    
                    print("WOW Failure")
                    
                    _ = SweetAlert().showAlert("ESCALATE", subTitle: "Something went wrong!", style: AlertStyle.error)
                    
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
    
    
    
    
    func viewProfile(){
        
//        lblCategories.text = UserDefaults.standard.value(forKey: "CATEGORIES") as? String ?? ""
//
        let infoArray = UserDefaults.standard.value(forKey: "USERINFO") as? NSArray ?? []
        //print(infoArray)
        let infoDict = infoArray.object(at: 0) as? NSDictionary ?? [:]
        
        

        //print(infoDict)

        login_user_id = infoDict.value(forKey: "user_id") as? String ?? ""

        print(login_user_id)
        
        
        if InternetConnection.internetshared.isConnectedToNetwork() {
            
            Indicator.shared.showProgressView(self.view)
            
            
            
            WebserviceConnection.requestGETURL("userdetail/\(user_id)/\(login_user_id)", success: { (responseJson) in
                
                if responseJson["status"].stringValue == "SUCCESS" {
                    
                    Indicator.shared.hideProgressView()
                    
                    print("SUCCESS")
                    
                    print(responseJson)
                    
                    self.userDict = responseJson["data"].dictionaryObject as? NSDictionary ?? [:]
                    
                    self.lblFullname.text = self.userDict["fullname"] as? String ?? ""
                    
                   // self.lblUserName.text = "@ \(userDict["username"] as? String ?? "")"
                    
                    self.lblRecordingTime.text = self.userDict["bio_duration"] as? String ?? ""

                    
                    let userName = self.userDict["username"] as? String ?? ""
                    
                    
                    
                    if userName == ""{
                        
                        
                        
                    }
                    else{
                        
                        self.lblUserName.text = "@ \(userName)"
                        
                    }
                    
                    
                    
                  
                    
                  
                    
                    
                    
                    
                    
                    self.lblFollowersCount.text = self.userDict["number_of_followers"] as? String ?? ""
                    
                    self.lblFollowingCount.text = self.userDict["number_of_following"] as? String ?? ""
                    
                    self.lblCategories.text = self.userDict["topic_id"] as? String ?? ""
                    
                    let followFlag = self.userDict["flag_follow"] as? String ?? ""
                    
                    
                    if followFlag == "0"{
                        
                        self.btnFollowRef.setTitle("Follow", for: .normal)
                        self.btnFollowRef.backgroundColor = UIColor(red: 74/255, green: 37/255, blue: 107/255, alpha: 1)
                    }else{
                        
                        self.btnFollowRef.setTitle("Unfollow", for: .normal)
                        self.btnFollowRef.backgroundColor = UIColor(red: 110/255, green: 196/255, blue: 124/255, alpha: 1)
                    }
                    //self.lblPhone.text = userDict["phone"] as? String ?? ""
                    
                    //self.lblEmail.text = userDict["email"] as? String ?? ""
                    
                    self.audioUrlString = self.userDict["bio"] as? String ?? ""
                    
                    self.audioUrl = NSURL(string: self.userDict["bio"] as? String ?? "") as! URL
                    
                    //self.lblCategories.text = userDict["topic_id"] as? String ?? ""
                    
                    self.lblPostsCount.text = self.userDict["num_of_post"] as? String ?? ""
                    
                   
                    
                    let image = self.userDict["image"] as? String ?? ""
                    
                    self.imgProfile.sd_setImage(with: URL(string: image as? String ?? ""), placeholderImage: UIImage(named: "user_signup"))
                    
                    if self.tag == 1{
                        self.userPostList()
                    }else if self.tag == 2{
                        
                        self.followerList()
                        
                    }else{
                        self.followingList()
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
                
                _ = SweetAlert().showAlert("Escalate", subTitle: "Something went wrong.Please try again!", style: AlertStyle.error)
                Indicator.shared.hideProgressView()
                
                
            })
            
            
        }else{
            
            _ = SweetAlert().showAlert("Escalate", subTitle: "No interter connection!", style: AlertStyle.error)
            Indicator.shared.hideProgressView()
            
        }
        
        
        
    }
    
    
    
    
    //TODO:-WEBSERVICES
    
    
    func followUnfollowingService() {
        
//        follower_id:2
//        user_id:7
//        token:brQgz96SV40ES8ZeR2M0FvBk7
        
        
        
        let infoArray = UserDefaults.standard.value(forKey: "USERINFO") as? NSArray ?? []
        //print(infoArray)
        let infoDict = infoArray.object(at: 0) as? NSDictionary ?? [:]
        
        //print(infoDict)
        
        let token = infoDict.value(forKey: "token") as? String ?? ""
        
        print(token)
        
        let loginUser_id = infoDict.value(forKey: "user_id") as? String ?? ""
        
        print(user_id)
        

        let passDict = ["follower_id":"\(loginUser_id)",
            "user_id":"\(user_id)",
            "token":"\(token)"] as! [String : AnyObject]
        
        
        
        print(passDict)
        
        if InternetConnection.internetshared.isConnectedToNetwork() {
            
            Indicator.shared.showProgressView(self.view)
            
            WebserviceConnection.requestPOSTURL("follow", params: passDict as [String : AnyObject], headers:nil, success: { (responseJson) in
                
                if responseJson["status"].stringValue == "SUCCESS" {
                    
                    Indicator.shared.hideProgressView()
                    
                    print(responseJson["status"])
                    print(responseJson)
                    
                    let dataDict = responseJson["data"].dictionaryObject as? NSDictionary ?? [:]
                    let recentSearchModelArray = self.realm.objects(RecentSearchModel.self)
                    for item in recentSearchModelArray{
                        if item.type == "people"{
                            if item.user_id == self.user_id{
                                if item.follower_flag == "0"{
                                    
                                    do{
                                        try self.realm.write {
                                            print(item.follower_flag)
                                            item.follower_flag = "1"
                                            print(item.follower_flag)
                                        }
                                    }catch{
                                        print("Error in saving data :- \(error.localizedDescription)")
                                    }
                                }else{
                                    do{
                                        try self.realm.write {
                                            print(item.follower_flag)
                                            item.follower_flag = "0"
                                            print(item.follower_flag)
                                        }
                                    }catch{
                                        print("Error in saving data :- \(error.localizedDescription)")
                                    }
                                }
                            }
                        }
                    }
                    self.viewProfile()
                    
                    
                    
                    
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
    
    
    
    
    
    //MARK:- ACTIONS
    //MARK:
    
    
    @IBAction func ReportUserTapped(_ sender: UIButton) {
        
        reportUserAPI()
        
    }
    
    
    
    
    
    
    
    
    @IBAction func btnFollowersTapped(_ sender: Any) {
        
        
        
        
        viewFollowers.backgroundColor = UIColor(red: 76/255,green: 40/255, blue: 107/255, alpha:1)
        lblFollowersCount.textColor = UIColor.white
        lblFollowers.textColor = UIColor.white
        
        
        viewPostCounts.backgroundColor = UIColor.white
        lblPosts.textColor = UIColor.black
        lblPostsCount.textColor = UIColor.black
        
        
        viewFollowing.backgroundColor = UIColor.white
        lblFollowings.textColor = UIColor.black
        lblFollowingCount.textColor = UIColor.black
        
        tag = (sender as AnyObject).tag
        stopPlayingMusic()
        
        stopFollowerTable()
        
        stopFollowingTable()
        
        stopTableAudio()
        
        
        
        followerList()
        
    }
    
    
    
    @IBAction func btnFollowingTapped(_ sender: UIButton) {
        
        
        viewFollowers.backgroundColor = UIColor.white
        lblFollowersCount.textColor = UIColor.black
        lblFollowers.textColor = UIColor.black
        
        
        viewPostCounts.backgroundColor = UIColor.white
        lblPosts.textColor = UIColor.black
        lblPostsCount.textColor = UIColor.black
        
        
        viewFollowing.backgroundColor = UIColor(red: 76/255,green: 40/255, blue: 107/255, alpha:1)
        lblFollowings.textColor = UIColor.white
        lblFollowingCount.textColor = UIColor.white
        
        
        
        tag = sender.tag
        stopPlayingMusic()
        
        stopPlayingMusic()
        
        stopFollowerTable()
        
        stopTableAudio()
        
        
        followingList()
        
        
        
    }
    
    
    @IBAction func btnPostTapped(_ sender: UIButton) {
        
        
        viewFollowers.backgroundColor = UIColor.white
        lblFollowersCount.textColor = UIColor.black
        lblFollowers.textColor = UIColor.black
        
        
        viewPostCounts.backgroundColor = UIColor(red: 76/255,green: 40/255, blue: 107/255, alpha:1)
        lblPosts.textColor = UIColor.white
        lblPostsCount.textColor = UIColor.white
        
        
        viewFollowing.backgroundColor = UIColor.white
        lblFollowings.textColor = UIColor.black
        lblFollowingCount.textColor = UIColor.black
        
        
        
        
        tag = sender.tag
        
        stopPlayingMusic()
        
        stopFollowerTable()
        
        stopFollowingTable()
        
        stopTableAudio()
        
        
        userPostList()
        
        
    }
    
    
    
    @IBAction func play_recording(_ sender: Any)
    {
        stopTableAudio()
        
        stopFollowerTable()
        
        stopFollowingTable()
        
        
        
        playBioFromAPI()
        
        
    }
    
    
    
    @IBAction func btnFollowTapped(_ sender: UIButton) {
        
        stopPlayingMusic()
        
        stopFollowerTable()
        
        stopFollowingTable()
        
        stopTableAudio()
        
        followUnfollowingService()
        
    }
    
    
    @IBAction func btnChoicesTapped(_ sender: UIButton) {
        
        tag = sender.tag
        
        tblViewProfile.reloadData()
    }
    
    
    @IBAction func btnBackTapped(_ sender: UIButton) {
        
        stopPlayingMusic()
        
        stopFollowerTable()
        
        stopFollowingTable()
        
        stopTableAudio()
        
        
       self.navigationController?.popViewController(animated: true)
        
    }
    
    
    @IBAction func btnFilterTapped(_ sender: UIButton) {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "OtherProfileFilterVC") as! OtherProfileFilterVC
        self.navigationController?.present(vc, animated: false, completion: nil)
        
        
    }
    
    
    @IBAction func btnChatTapped(_ sender: Any) {
        
        stopPlayingMusic()
        
        stopFollowerTable()
        
        stopFollowingTable()
        
        stopTableAudio()
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ChatRepliesVC") as! ChatRepliesVC
        vc.user_id = user_id
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    
    
    //MARK:- TABLEVIEW CELL BUTTONS ACTIONS
    //MARK:
    
    
    
    @objc func btnOtherProfileTapped(sender: UIButton){
        print(sender.tag)
        
        if tag == 2{
            
            print("aman")
            
            
            let dataDict = followersArray[sender.tag]
            
            print(dataDict)
            
            let userID = dataDict.user_id ?? ""
            
            
            
            
            
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "OtherProfileVC") as! OtherProfileVC
            
            vc.user_id = userID
            
            self.navigationController?.pushViewController(vc, animated: true)
            
        }else{
            
            print("aman")
            
            
            let dataDict = followingArray[sender.tag]
            
            print(dataDict)
            
            let userID = dataDict.user_id ?? ""
            
            
            
            
            
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "OtherProfileVC") as! OtherProfileVC
            
            vc.user_id = userID
            
            self.navigationController?.pushViewController(vc, animated: true)
            
        }
        
        
    }
    
    
    @objc func btnFollowUnfollowTapped(sender: UIButton){
        print(sender.tag)
        //asdfasdf
        
        if tag == 2{
            
            let dataDict = followersArray[sender.tag]
            
            print(dataDict)
            
            let userID = dataDict.user_id ?? ""
            
            followUnfollowingService(user_id:userID, index: sender.tag)
            
            
        }else if tag == 3{
            let dataDict = followingArray[sender.tag]
            
            print(dataDict)
            
            let userID = dataDict.user_id ?? ""
            
            followUnfollowingService(user_id:userID, index: sender.tag)
            
        }
        
        
    }
    
    
    
    func countDownTimet2(){
        
        timerCountC = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.update2), userInfo: nil, repeats: true)
        
    }
    
    
    @objc func update2() {
        
        
        let btnTag = UserDefaults.standard.value(forKey: "OFOLLOWINGBTNTAG") as? Int ?? 0
        
        let indexPath = IndexPath(row: btnTag, section: 0)
        
        
        guard let cell = tblViewProfile.cellForRow(at: indexPath) as? FollowFollowingXibAndCe else {
            
            return
        }
        
        
        if(count1 > 0) {
            
            
            count1 = count1 - 1
            print(count1)
        }
        else{
            
            
            timerCountC?.invalidate()
            timerCountC = nil
            
            cell.btnPlayBioRef.setImage(#imageLiteral(resourceName: "home_play_a"), for: .normal)
            
            
            isPlaying2 = false
            //STOP PLAYING AND ANIMATION
            
            
        }
    }
    
    
    
    
    
    func countDownTimet3(){
        
        timerCountD = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.update3), userInfo: nil, repeats: true)
        
    }
    
    
    @objc func update3() {
        
        
        let btnTag = UserDefaults.standard.value(forKey: "ORFOLLOWINGBTNTAG") as? Int ?? 0
        
        let indexPath = IndexPath(row: btnTag, section: 0)
        
        
        guard let cell = tblViewProfile.cellForRow(at: indexPath) as? FollowFollowingXibAndCe else {
            
            return
        }
        
        
        if(count1 > 0) {
            
            
            count1 = count1 - 1
            print(count1)
        }
        else{
            
            
            timerCountD?.invalidate()
            timerCountD = nil
            
            cell.btnPlayBioRef.setImage(#imageLiteral(resourceName: "home_play_a"), for: .normal)
            
            
            isPlaying3 = false
            //STOP PLAYING AND ANIMATION
            
            
        }
    }
    
    
    
    
    
    
    
    @objc func btnPlayBioTapped(sender: UIButton){
        
        
        
        stopPlayingMusic()
        
        stopTableAudio()
        
        
        if tag == 3{
            
            UserDefaults.standard.set(sender.tag, forKey: "OFOLLOWINGBTNTAG")
            
            timerCountC?.invalidate()
            timerCountC = nil
            
            
            let prevTag = UserDefaults.standard.value(forKey: "OFOLLOWINGPBTNTAG") as? Int ?? 0
            print(prevTag)
            let btnTag = UserDefaults.standard.value(forKey: "OFOLLOWINGBTNTAG") as? Int ?? 0
            
            print(btnTag)
            
            if btnTag != prevTag{
                
                
                if(isPlaying2)
                {
                    
                    let prevIndexPath = IndexPath(row: prevTag, section: 0)
                    guard let prevCell = tblViewProfile.cellForRow(at: prevIndexPath) as? FollowFollowingXibAndCe else {
                        
                        return
                    }
                    
                    
                    
                    //player!.pause()
                    
                    timerCountC?.invalidate()
                    timerCountC = nil
                    
                    
                    prevCell.btnPlayBioRef.setImage(#imageLiteral(resourceName: "home_play_a"), for: .normal)
                    
                    
                    isPlaying2 = false
                    
                    
                    
                }else{
                    
                }
                
                
                
            }
            
            
            
            
            
            
            let indexPath = IndexPath(row: btnTag, section: 0)
            let cell = tblViewProfile.cellForRow(at: indexPath) as! FollowFollowingXibAndCe
            
            
            
            
            let dataDict = followingArray[sender.tag]
            
            ////
            
            if dataDict.bio != ""{
                
                bioURL1 = NSURL(string: dataDict.bio ?? "")! as URL
                
                
                
                print(bioURL1)
                
                
                if(isPlaying2)
                {
                    
                    player2!.pause()
                    
                    timerCountC?.invalidate()
                    timerCountC = nil
                    
                    
                    cell.btnPlayBioRef.setImage(#imageLiteral(resourceName: "home_play_a"), for: .normal)
                    
                    isPlaying2 = false
                    
                    
                    
                }
                else
                {
                    if bioURL1 != nil
                    {
                        
                        
                        let playerItem2:AVPlayerItem = AVPlayerItem(url: bioURL1!)
                        player2 = AVPlayer(playerItem: playerItem2)
                        
                        
                        let asset = AVAsset(url: bioURL1)
                        
                        
                        let duration = asset.duration
                        let durationTime = CMTimeGetSeconds(duration)
                        
                        
                        count1 = Int(ceil(durationTime))
                        
                        
                        cell.btnPlayBioRef.setImage( #imageLiteral(resourceName: "home_pause_a"),for: .normal)
                        player2!.play()
                        
                        countDownTimet2()
                        
                        isPlaying2 = true
                    }
                    else
                    {
                        
                        
                        _ = SweetAlert().showAlert("Escalate", subTitle: "Audio file is missing.", style: AlertStyle.error)
                        
                    }
                }
                
                
            }
                
            else{
                
                _ = SweetAlert().showAlert("Escalate", subTitle: "Audio file is missing.", style: AlertStyle.error)
                
            }
            ///
            
            
            let prevBtnTag = UserDefaults.standard.value(forKey: "OFOLLOWINGBTNTAG") as? Int ?? 0
            
            print(prevBtnTag)
            
            UserDefaults.standard.set(prevBtnTag, forKey: "OFOLLOWINGPBTNTAG")
            
        }
            
        else if tag == 2{
            
            UserDefaults.standard.set(sender.tag, forKey: "ORFOLLOWINGBTNTAG")
            
            timerCountD?.invalidate()
            timerCountD = nil
            
            
            let prevTag = UserDefaults.standard.value(forKey: "ORFOLLOWINGPBTNTAG") as? Int ?? 0
            print(prevTag)
            
            let btnTag = UserDefaults.standard.value(forKey: "ORFOLLOWINGBTNTAG") as? Int ?? 0
            
            print(btnTag)
            
            if btnTag != prevTag{
                
                
                if(isPlaying3)
                {
                    
                    let prevIndexPath = IndexPath(row: prevTag, section: 0)
                    guard let prevCell = tblViewProfile.cellForRow(at: prevIndexPath) as? FollowFollowingXibAndCe else {
                        
                        return
                    }
                    
                    
                    
                    //player!.pause()
                    
                    timerCountD?.invalidate()
                    timerCountD = nil
                    
                    
                    prevCell.btnPlayBioRef.setImage(#imageLiteral(resourceName: "home_play_a"), for: .normal)
                    
                    
                    isPlaying3 = false
                    
                    
                    
                }else{
                    
                }
                
                
                
            }
            
            
            
            
            
            
            let indexPath = IndexPath(row: btnTag, section: 0)
            let cell = tblViewProfile.cellForRow(at: indexPath) as! FollowFollowingXibAndCe
            
            
            let dataDict = followersArray[sender.tag]
            
            
            
            ////
            
            if dataDict.bio != ""{
                
                bioURL2 = NSURL(string: dataDict.bio ?? "")! as URL
                
                
                
                print(bioURL2)
                
                
                if(isPlaying3)
                {
                    
                    player3!.pause()
                    
                    timerCountD?.invalidate()
                    timerCountD = nil
                    
                    
                    cell.btnPlayBioRef.setImage(#imageLiteral(resourceName: "home_play_a"), for: .normal)
                    
                    isPlaying3 = false
                    
                    
                    
                }
                else
                {
                    if bioURL2 != nil
                    {
                        
                        
                        let playerItem3:AVPlayerItem = AVPlayerItem(url: bioURL2!)
                        player3 = AVPlayer(playerItem: playerItem3)
                        
                        
                        let asset = AVAsset(url: bioURL2)
                        
                        
                        let duration = asset.duration
                        let durationTime = CMTimeGetSeconds(duration)
                        
                        
                        count1 = Int(ceil(durationTime))
                        
                        
                        cell.btnPlayBioRef.setImage( #imageLiteral(resourceName: "home_pause_a"),for: .normal)
                        player3!.play()
                        
                        countDownTimet3()
                        
                        isPlaying3 = true
                    }
                    else
                    {
                        
                        
                        _ = SweetAlert().showAlert("Escalate", subTitle: "Audio file is missing.", style: AlertStyle.error)
                        
                    }
                }
                
                
            }
                
            else{
                
                _ = SweetAlert().showAlert("Escalate", subTitle: "Audio file is missing.", style: AlertStyle.error)
                
            }
            ///
            
            
            let prevBtnTag = UserDefaults.standard.value(forKey: "ORFOLLOWINGBTNTAG") as? Int ?? 0
            
            print(prevBtnTag)
            
            UserDefaults.standard.set(prevBtnTag, forKey: "ORFOLLOWINGPBTNTAG")
            
        }
        
        
        
    }
    
    
 
    
    
    @objc internal func refreshAudioView1(_:Timer) {
        
        let btnTag = UserDefaults.standard.value(forKey: "OBTNTAG") as? Int ?? 0
        
        
        let indexPath = IndexPath(row: btnTag, section: 0)
        
        
        guard let cell = tblViewProfile.cellForRow(at: indexPath) as? ProfileTableViewCell else {
            
            return
        }
        
        
        
        if cell.audioView.amplitude <= cell.audioView.idleAmplitude || cell.audioView.amplitude > 1.0 {
            self.change1 *= -1.0
        }
        
        
        cell.audioView.amplitude += self.change1
        
        
        
        
    }
    
    
    func countDownTimet1(){
        
        timerCountB = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.update1), userInfo: nil, repeats: true)
        
    }
    
    
    @objc func update1() {
        
        
        let btnTag = UserDefaults.standard.value(forKey: "OBTNTAG") as? Int ?? 0
        
        let indexPath = IndexPath(row: btnTag, section: 0)
        
        
        let dataDict = postDataArray[btnTag]
        
        
        guard let cell = tblViewProfile.cellForRow(at: indexPath) as? ProfileTableViewCell else {
            
            return
        }
        
        
        if(count1 > 0) {
            
            sec1 = count1
            
            if sec1 == 60{
                min1 += 1
                sec1 = 0
            }
            if min1 == 60{
                hr1 += 1
                min1 = 0
                sec1 = 0
            }
            if hr1 == 24{
                hr1 = 0
                min1 = 0
                sec1 = 0
            }
            
            count1 = count1 - 1
            print(count1)
            
            let totalTimeString = String(format: "%02d:%02d",min1, count1)
            cell.lblTotalTimer.text = totalTimeString
            
        }
        else{
            print("TIMERCOUNT")
            print(count1)
            count1 = sec1
            hr1 = 0
            min1 = 0
            
            timerB?.invalidate()
            timerB = nil
            timerCountB?.invalidate()
            timerCountB = nil
            
            let totalTimeString = dataDict.duration
            cell.lblTotalTimer.text = totalTimeString
            
            cell.btnPlayPausedRef.setImage(UIImage(named: "home_play_a"),for: .normal)
            
            cell.audioView.amplitude = 0.0
            isPlaying1 = false
            //STOP PLAYING AND ANIMATION
            
            
        }
    }
    
    
    
    func stopPlayingMusic(){
        if(isPlaying)
        {
            
            player!.pause()
            
            timerCountA?.invalidate()
            timerCountA = nil
            timerA?.invalidate()
            timerA = nil
            sec = 0
            hr = 0
            min = 0
            
            btnPlayRef.setImage(UIImage(named: "home_play_a"),for: .normal)
            isPlaying = false
            audioView.amplitude = 0.0
            
            let totalTimeString = self.userDict.value(forKey: "bio_duration") as? String ?? ""
            lblRecordingTime.text = totalTimeString
            
        }
        
    }
    
    
    
    @objc internal func refreshAudioView(_:Timer) {
        if self.audioView.amplitude <= self.audioView.idleAmplitude || self.audioView.amplitude > 1.0 {
            self.change *= -1.0
        }
        
        
        // Simply set the amplitude to whatever you need and the view will update itself.
        self.audioView.amplitude += self.change
    }
    
    
    func countDownTimet(){
        
        timerCountA = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.update), userInfo: nil, repeats: true)
    }
    
    
    @objc func update() {
        if(count > 0) {
            sec = count
            
            
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
            print("TIMERCOUNT")
            print(count)
           count = sec
            hr = 0
            min = 0
            
            timerA?.invalidate()
            timerA = nil
            timerCountA?.invalidate()
            timerCountA = nil
            
            let totalTimeString = self.userDict.value(forKey: "bio_duration") as? String ?? ""
            lblRecordingTime.text = totalTimeString
            
            btnPlayRef.setImage(UIImage(named: "home_play_a"),for: .normal)
            
            audioView.amplitude = 0.0
            isPlaying = false
            //STOP PLAYING AND ANIMATION
            
            
        }
    }
    
    
    
    
    
    @objc func stopRecordingAndPlaying(_ notification: Notification) {
        
        
        stopPlayingMusic()
        
        stopFollowerTable()
        
        stopFollowingTable()
        
        stopTableAudio()
        
        
    }
    
    
    
    
    
    
    @objc func refreshListOtherProfile(_ notification: Notification) {
        
        
        if rowNumber < postDataArray.count{
        
        var replyCounts = Int(postDataArray[rowNumber].reply_count as? String ?? "") as? Int ?? 0
        print(replyCounts)
        
        replyCounts = replyCounts + 1
        
        
        let indexPath = IndexPath(row: rowNumber, section: 0)
        
        
            guard let cell = self.tblViewProfile.cellForRow(at: indexPath) as? ProfileTableViewCell else {
                
                return
            }

        
        
        
        cell.btnViewAllReplyRef.setTitle("View all \(replyCounts) replies", for: .normal)
        
            
        }else{
                print("Do nothing")
            }

        
        
    }
    
    
    
    @objc func btnLikeTapped(sender: UIButton){
        print(sender.tag)
        
        stopPlayingMusic()
        
        listButtonTapped = true
        rowNumber = sender.tag
        
        
        
        let dataDict = postDataArray[sender.tag]
        
        
        let audioID = dataDict.post_id ?? ""
        
        
        
        
        print(audioID)
        
        postLikeDislike(audio_id: audioID, index: sender.tag)
        
        
        
        
        
        
    }
    
    @objc func buttonSelected(sender: UIButton){
        print(sender.tag)
    }
    
    
    
    @objc func btnPlayPausedTapped(sender: UIButton){
        
        stopPlayingMusic()
        
        UserDefaults.standard.set(sender.tag, forKey: "OBTNTAG")
        
        timerCountB?.invalidate()
        timerCountB = nil
        timerB?.invalidate()
        timerB = nil
        
        let prevTag = UserDefaults.standard.value(forKey: "OPBTNTAG") as? Int ?? 0
        print(prevTag)
        let btnTag = UserDefaults.standard.value(forKey: "OBTNTAG") as? Int ?? 0
        
        print(btnTag)
        
        if btnTag != prevTag{
            
            
            if(isPlaying1)
            {
                
                
                let prevIndexPath = IndexPath(row: prevTag, section: 0)
                guard let prevCell = tblViewProfile.cellForRow(at: prevIndexPath) as? ProfileTableViewCell else {
                    
                    return
                }
                
                let dataDict = postDataArray[prevTag]
                
                //player!.pause()
                
                timerCountB?.invalidate()
                timerCountB = nil
                timerB?.invalidate()
                timerB = nil
                sec1 = 0
                hr1 = 0
                min1 = 0
                
                
                
                prevCell.btnPlayPausedRef.setImage(#imageLiteral(resourceName: "home_play_a"), for: .normal)
                prevCell.audioView.amplitude = 0.0
                
                
                prevCell.lblTotalTimer.text = dataDict.duration
                isPlaying1 = false
                
                
                
            }else{
                
            }
            
            
            
        }
        
        
        
        
        
        
        let indexPath = IndexPath(row: btnTag, section: 0)
        let cell = tblViewProfile.cellForRow(at: indexPath) as! ProfileTableViewCell
        
        
        
        
         let dataDict = postDataArray[btnTag]
        
        
        
        audioUrl1 = NSURL(string: dataDict.otherurl ?? "")! as URL
        
        
        
        print(audioUrl1)
        
        
        if(isPlaying1)
        {
            
            player1!.pause()
            
            timerCountB?.invalidate()
            timerCountB = nil
            timerB?.invalidate()
            timerB = nil
            sec1 = 0
            hr1 = 0
            min1 = 0
            
            cell.btnPlayPausedRef.setImage(#imageLiteral(resourceName: "home_play_a"), for: .normal)
            
            isPlaying1 = false
            cell.audioView.amplitude = 0.0
            
            let totalTimeString = String(format: "%02d:%02d", min1, sec1)
            cell.lblTotalTimer.text = dataDict.duration
        }
        else
        {
            if audioUrl1 != nil
            {
                let playerItem1:AVPlayerItem = AVPlayerItem(url: audioUrl1!)
                player1 = AVPlayer(playerItem: playerItem1)
                
                
                let asset = AVAsset(url: audioUrl1)
                
                let duration = asset.duration
                let durationTime = CMTimeGetSeconds(duration)
                
                
                count1 = Int(ceil(durationTime))
                
                
                countDownTimet1()
                
                
                
                
                
                timerB = Timer.scheduledTimer(timeInterval: 0.009, target: self, selector: #selector(self.refreshAudioView1(_:)), userInfo: nil, repeats: true)
                
                cell.btnPlayPausedRef.setImage(UIImage(named: "home_pause_a"),for: .normal)
                player1!.play()
                
                
                isPlaying1 = true
            }
            else
            {
                
                
                _ = SweetAlert().showAlert("Escalate", subTitle: "Audio file is missing.", style: AlertStyle.error)
                
            }
        }
        
        
        let prevBtnTag = UserDefaults.standard.value(forKey: "OBTNTAG") as? Int ?? 0
        
        print(prevBtnTag)
        
        UserDefaults.standard.set(prevBtnTag, forKey: "OPBTNTAG")
        
        
        
        
        
    }
    
    
    
    @objc func btnQuickReplyTapped(sender: UIButton){
        
        UserDefaults.standard.set("FROMOTHERPROFILE", forKey: "ISCOMINGFORNOTIFICATION")
        print(sender.tag)
        
        rowNumber = sender.tag
        
        
        let dataDict = postDataArray[sender.tag]
        
        
        
        let audioID = dataDict.post_id ?? ""
        
        
        
        print(audioID)
        
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "CommentMikeVC") as! CommentMikeVC
        
        vc.audioID = audioID
        
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    
    
    @objc func btnCommentTapped(sender: UIButton){
        
        
        rowNumber = sender.tag
        
        
        if(isPlaying)
        {
            let btnTag = UserDefaults.standard.value(forKey: "BTNTAG") as? Int ?? 0
            
            
            
            let indexPath = IndexPath(row: btnTag, section: 0)
            
            guard let cell = tblViewProfile.cellForRow(at: indexPath) as? HomeTableViewCell else {
                
                return
            }
            
            
            
            
            
            player1!.pause()
            
            timerCountB?.invalidate()
            timerCountB = nil
            timerB?.invalidate()
            timerB = nil
           
            sec1 = 0
            hr1 = 0
            min1 = 0
            
            cell.btnPlayPausedRef.setImage(#imageLiteral(resourceName: "home_play_a"), for: .normal)
            
            isPlaying1 = false
            cell.audioView.amplitude = 0.0
            
            let totalTimeString = String(format: "%02d:%02d", min1, sec1)
            cell.lblTotalTimer.text = totalTimeString
        }
        
        
        
        
        UserDefaults.standard.set("FROMOTHERPROFILE", forKey: "ISCOMINGFORNOTIFICATION")
        print(sender.tag)
        
        rowNumber = sender.tag
        
        
        let dataDict = postDataArray[sender.tag]
        
        
        print(dataDict)
        
        
        
        
        
        
        
        
        
        let audioID = dataDict.post_id ?? ""
        let user_id = dataDict.user_id ?? ""
        let user_image = dataDict.user_image ?? ""
        let fullname = dataDict.fullname ?? ""
        let tag_list = dataDict.tag_list ?? ""
        let audio_url = dataDict.otherurl ?? ""
        let duration = dataDict.duration ?? ""
        let descriptionPost = dataDict.description ?? ""
        
        
        
        
        
        print(audioID)
        
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "CommentsWithPostVC") as! CommentsWithPostVC
        
        vc.audioID = audioID
        
        //vc.user_id = user_id
        
        vc.user_image = user_image
        
        vc.fullname = fullname
        
        vc.tag_list = tag_list
        
        vc.audio_url = audio_url
        
        vc.duration = duration
        
        vc.descriptionPost = descriptionPost
        
        
        
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    @objc func btnShareTapped(sender: UIButton){
        print(sender.tag)
         stopPlayingMusic()
        let dataDict = postDataArray[sender.tag]
        
        
        
        let audioUrl = dataDict.otherurl ?? ""
        
        
        
        print(audioUrl)
        
        // let vc = UIActivityViewController(activityItems: [shareText, image], applicationActivities: [])
        
        let vc = UIActivityViewController(activityItems: [audioUrl], applicationActivities: [])
        
        present(vc, animated: true)
        
        print(sender.tag)
    }
    
    
    @objc func btnReplyTapped(sender: UIButton){
        
        UserDefaults.standard.set("FROMOTHERPROFILE", forKey: "ISCOMINGFORNOTIFICATION")
        print(sender.tag)
        
        rowNumber = sender.tag
        
        
        stopPlayingMusic()
        print(sender.tag)
        
        let dataDict = postDataArray[sender.tag]
        
        
        
        let audioID = dataDict.post_id ?? ""
        
        
        
        print(audioID)
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "RepliesVC") as! RepliesVC
        
        vc.audioID = audioID
        
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    
}



//MARK:- EXTENTION TABLE VIEW
//MARK:-

extension OtherProfileVC:UITableViewDelegate,UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        if tag == 1{
            return postDataArray.count
        }else if tag == 2{
            return followersArray.count
        }else if tag == 3{
            return followingArray.count
        }else{
            return postDataArray.count
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        stopPlayingMusic()
        
        stopFollowerTable()
        
        stopFollowingTable()
        
        stopTableAudio()
        

        
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tag == 1{
            
            tblViewProfile.register(UINib(nibName: "ProfileTableViewCell", bundle: nil), forCellReuseIdentifier: "ProfileTableViewCell")
            
            let cell = tblViewProfile.dequeueReusableCell(withIdentifier: "ProfileTableViewCell", for: indexPath) as! ProfileTableViewCell
            
            
            
            
            if postDataArray.count > 0{
                
                
                
                let dataDict = postDataArray[indexPath.row]
                
                let image = dataDict.user_image ?? ""
                
                cell.imgView_user.sd_setImage(with: URL(string: image as? String ?? ""), placeholderImage: UIImage(named: "user_signup"))
                
                cell.lblFullName.text = dataDict.fullname ?? ""
                
                cell.lblDescription.text = dataDict.description ?? ""
                
                cell.lblUserName.text = dataDict.tag_list ?? ""
                
                //cell.lblUserName.text = "@\(dataDict.username ??  "")"
                
                
                
                 cell.lblTotalTimer.text = dataDict.duration ?? ""
                
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
                
//                if dataDict.reply_count == "0"{
//
//                    cell.btnReplyRef.isHidden = true
//                }
//                else{
//                    cell.btnReplyRef.isHidden = false
//                }
                
                if dataDict.like_flag == "0"{
                    
                    cell.btnLikeRef.setImage(#imageLiteral(resourceName: "home_like"), for: .normal)
                    
                    
                    
                }else{
                    cell.btnLikeRef.setImage(#imageLiteral(resourceName: "home_like_unselected"), for: .normal)
                }
                
                
                cell.btnLikeRef.tag = indexPath.row
                cell.btnLikeRef.addTarget(self, action: #selector(btnLikeTapped), for: .touchUpInside)
                
//                cell.btnOtherProfileRef.tag = indexPath.row as? Int ?? 0
//                cell.btnOtherProfileRef.addTarget(self, action: #selector(btnOtherProfileTapped), for: .touchUpInside)
                
                cell.btnPlayPausedRef.tag = indexPath.row
                cell.btnPlayPausedRef.addTarget(self, action: #selector(btnPlayPausedTapped), for: .touchUpInside)
                
                cell.btnCommentRef.tag = indexPath.row
                cell.btnCommentRef.addTarget(self, action: #selector(btnCommentTapped), for: .touchUpInside)
                
                cell.btnShareRef.tag = indexPath.row
                cell.btnShareRef.addTarget(self, action: #selector(btnShareTapped), for: .touchUpInside)
                
                cell.btnReplyRef.tag = indexPath.row
                cell.btnReplyRef.addTarget(self, action: #selector(btnQuickReplyTapped), for: .touchUpInside)
                
                cell.btnViewAllReplyRef.tag = indexPath.row 
                cell.btnViewAllReplyRef.addTarget(self, action: #selector(btnReplyTapped), for: .touchUpInside)
                
                cell.btnDeleteRef.isHidden = true
                
                
                
            }
            
            return cell
        }
        else if tag == 2{
            
            tblViewProfile.register(UINib(nibName: "FollowFollowingXibAndCe", bundle: nil), forCellReuseIdentifier: "FollowFollowingXibAndCe")
            
            let cell = tblViewProfile.dequeueReusableCell(withIdentifier: "FollowFollowingXibAndCe", for: indexPath) as! FollowFollowingXibAndCe
            
 
            
            if followersArray.count > 0{
                
                
                let dataDict = followersArray[indexPath.row]
                
                let image = dataDict.user_image ?? ""
                
                cell.imgView_user.sd_setImage(with: URL(string: image as? String ?? ""), placeholderImage: UIImage(named: "user_signup"))
                
                let user_id = dataDict.user_id ?? ""
              
                
                
                if login_user_id == user_id{
                    
                    cell.btnFollowRef.isHidden = true
                    
                }else{
                    
                    cell.btnFollowRef.isHidden = false
                    
                    if dataDict.follower_flag == "1"{
                        
                        cell.btnFollowRef.setTitle("Unfollow", for: .normal)
                        cell.btnFollowRef.backgroundColor = UIColor(red: 110/255, green: 196/255, blue: 124/255, alpha: 1)
                    }else{
                        
                        cell.btnFollowRef.setTitle("Follow", for: .normal)
                        cell.btnFollowRef.backgroundColor = UIColor(red: 74/255, green: 37/255, blue: 107/255, alpha: 1)
                        
                        
                    }
                }
                
                
              
                
                
                cell.btnFullName.setTitle(dataDict.fullname ?? "", for: .normal)
                
                
                
                cell.btnPlayBioRef.tag = indexPath.row
               cell.btnPlayBioRef.addTarget(self, action: #selector(btnPlayBioTapped), for: .touchUpInside)
                
                cell.btnOtherProfileRef.tag = indexPath.row
                cell.btnOtherProfileRef.addTarget(self, action: #selector(btnOtherProfileTapped), for: .touchUpInside)
                
                cell.btnFullName.tag = indexPath.row
                cell.btnFullName.addTarget(self, action: #selector(btnOtherProfileTapped), for: .touchUpInside)
                
                cell.btnFollowRef.tag = indexPath.row
                
               cell.btnFollowRef.addTarget(self, action: #selector(btnFollowUnfollowTapped), for: .touchUpInside)
                
                
            }
            
            
            
            return cell
            
        }
            
        else if tag == 3{
            
            tblViewProfile.register(UINib(nibName: "FollowFollowingXibAndCe", bundle: nil), forCellReuseIdentifier: "FollowFollowingXibAndCe")
            
            let cell = tblViewProfile.dequeueReusableCell(withIdentifier: "FollowFollowingXibAndCe", for: indexPath) as! FollowFollowingXibAndCe
            
            
            if followingArray.count > 0{
                
                
                let dataDict = followingArray[indexPath.row]
                
                let image = dataDict.user_image ?? ""
                
                cell.imgView_user.sd_setImage(with: URL(string: image as? String ?? ""), placeholderImage: UIImage(named: "user_signup"))
                
                
                let user_id = dataDict.user_id ?? ""
                
                if login_user_id == user_id{
                    
                    cell.btnFollowRef.isHidden = true
                    
                }else{
                    
                    cell.btnFollowRef.isHidden = false
                    
                    if dataDict.follower_flag == "1"{
                        
                        cell.btnFollowRef.setTitle("Unfollow", for: .normal)
                        cell.btnFollowRef.backgroundColor = UIColor(red: 110/255, green: 196/255, blue: 124/255, alpha: 1)
                    }else{
                        
                        cell.btnFollowRef.setTitle("Follow", for: .normal)
                        cell.btnFollowRef.backgroundColor = UIColor(red: 74/255, green: 37/255, blue: 107/255, alpha: 1)
                        
                        
                    }
                }
                
              
                
                cell.btnFullName.setTitle(dataDict.fullname ?? "", for: .normal)
                
                
                cell.btnPlayBioRef.tag = indexPath.row
                cell.btnPlayBioRef.addTarget(self, action: #selector(btnPlayBioTapped), for: .touchUpInside)
                
                cell.btnOtherProfileRef.tag = indexPath.row
                cell.btnOtherProfileRef.addTarget(self, action: #selector(btnOtherProfileTapped), for: .touchUpInside)
                
                cell.btnFullName.tag = indexPath.row
                cell.btnFullName.addTarget(self, action: #selector(btnOtherProfileTapped), for: .touchUpInside)
                
                cell.btnFollowRef.tag = indexPath.row
                
                cell.btnFollowRef.addTarget(self, action: #selector(btnFollowUnfollowTapped), for: .touchUpInside)
                
            }
            
            
            
            
            
            
            
            
            return cell
            
            
        }
        else{
            tblViewProfile.register(UINib(nibName: "ProfileTableViewCell", bundle: nil), forCellReuseIdentifier: "ProfileTableViewCell")
            
            let cell = tblViewProfile.dequeueReusableCell(withIdentifier: "ProfileTableViewCell", for: indexPath) as! ProfileTableViewCell
            
            
            
            if postDataArray.count > 0{
                
                
                let dataDict = postDataArray[indexPath.row]
                
                let image = dataDict.user_image ?? ""
                
                cell.imgView_user.sd_setImage(with: URL(string: image as? String ?? ""), placeholderImage: UIImage(named: "user_signup"))
                
                cell.lblFullName.text = dataDict.fullname ?? ""
                
                cell.lblDescription.text = dataDict.description ?? ""
                
                 cell.lblUserName.text = dataDict.tag_list ?? ""
                
                
                //cell.lblUserName.text = "@\(dataDict.username ??  "")"
                
                cell.lblTotalLikes.text = "\(dataDict.like_count ?? "") Likes"
                
                
                
                 cell.lblTotalTimer.text = dataDict.duration ?? ""
                
                
//                let duration = Int(dataDict.duration ?? "") ?? 0
//
//                if duration < 10{
//
//                    cell.lblTotalTimer.text = "00:00:0\(duration)"
//                }else{
//                    cell.lblTotalTimer.text = "00:00:\(duration)"
//                }
                
                
                cell.btnViewAllReplyRef.setTitle("View all \(dataDict.reply_count ?? "") replies", for: .normal)
                
                
//                if dataDict.reply_count == "0"{
//                    
//                    cell.btnReplyRef.isHidden = true
//                }
//                else{
//                    cell.btnReplyRef.isHidden = false
//                }
                
                if dataDict.like_flag == "0"{
                    
                    cell.btnLikeRef.setImage(#imageLiteral(resourceName: "home_like"), for: .normal)
                    
                    
                    
                }else{
                    cell.btnLikeRef.setImage(#imageLiteral(resourceName: "home_like_unselected"), for: .normal)
                }
                
                
                cell.btnLikeRef.tag = indexPath.row
                cell.btnLikeRef.addTarget(self, action: #selector(btnLikeTapped), for: .touchUpInside)
                
                
                
                cell.btnPlayPausedRef.tag = indexPath.row
                cell.btnPlayPausedRef.addTarget(self, action: #selector(btnPlayPausedTapped), for: .touchUpInside)
                
                cell.btnCommentRef.tag = indexPath.row
                cell.btnCommentRef.addTarget(self, action: #selector(btnCommentTapped), for: .touchUpInside)
                
                cell.btnShareRef.tag = indexPath.row
                cell.btnShareRef.addTarget(self, action: #selector(btnShareTapped), for: .touchUpInside)
                
                cell.btnReplyRef.tag = indexPath.row
                
                cell.btnReplyRef.addTarget(self, action: #selector(btnQuickReplyTapped), for: .touchUpInside)
                
                //self.rowNumber = indexPath.row
                
                cell.btnViewAllReplyRef.tag = indexPath.row
                cell.btnViewAllReplyRef.addTarget(self, action: #selector(btnReplyTapped), for: .touchUpInside)
                
                cell.btnDeleteRef.isHidden = true
                
                
                
                
            }
            
            
            return cell
            
        }
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableViewAutomaticDimension
        
    }
    
}

