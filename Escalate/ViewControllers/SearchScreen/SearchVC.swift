//
//  SearchVC.swift
//  Escalate
//
//  Created by call soft on 20/07/18.
//  Copyright © 2018 call soft. All rights reserved.
//

import UIKit
import AVFoundation
import RealmSwift


class SearchVC: UIViewController,AVAudioRecorderDelegate,AVAudioPlayerDelegate,UISearchBarDelegate{
    
    
    
    //MARK:- OUTLETS
    //MARK:
    
    @IBOutlet weak var btnTagRef: UIButton!
    
    @IBOutlet weak var btnRecentRef: UIButton!
    @IBOutlet weak var btnTopicRef: UIButton!
    @IBOutlet weak var btnPeopleRef: UIButton!
    
    @IBOutlet weak var searchBarRef: UISearchBar!
    
    
    @IBOutlet var tblSearch: UITableView!
    
    @IBOutlet weak var lblPeople: UILabel!
    
    @IBOutlet weak var viewPeople: UIView!
    
    @IBOutlet weak var lblTopics: UILabel!
    
    
    @IBOutlet weak var viewTopics: UIView!
    
    
    @IBOutlet weak var lblRecents: UILabel!
    
    @IBOutlet weak var viewRecents: UIView!
    
    @IBOutlet weak var lblTags: UILabel!
    
    @IBOutlet weak var viewTags: UIView!
    
    //MARK:- VARIABLES
    //MARK:
    
    var flag = false
    
    let WebserviceConnection  = AlmofireWrapper()
    var user_id = ""
    
    var dataArray = NSArray()
    
    var tag = 1
    
    //****variables for locations

    
    var lat = ""
    var log = ""
    
    
    
    //*******variables for search according to people
    
    
    var peopleDataArray = [PeopleSearchDataModel]()
    
    
    //*******variables for search according to recents
    
    
    var postDataArray = [SavedPostsDataModel]()
    
    var audioUrlArray = [String]()
    
    var rowNumber = Int()
    
    var listButtonTapped = false
    
    var likeCountsString = ""
    
    var currentAudioIndex = 0
    
    
    var audioUrl: URL!
    
    var timerSa:Timer?
    
    var change:CGFloat = 0.01
    
    var timerCountSa:Timer?
    var count = 0
    var hr = 0
    var min = 0
    var sec = 0
    
    var isPlaying = false
    
    var player:AVPlayer?
    var playerItem:AVPlayerItem?
    
    
    
    //*********Variables for tags
    
    
    var tagArray = [TagDataModel]()
    var tagArray1 = [TagDataModel]()
    
    var searchActive = false
    
    //**********Variables for search
    
    
    var filteredArray:NSArray = NSArray()
    
    var searchPeopleArray:NSMutableArray = NSMutableArray()
    
    
    var peopleResponseArray:NSMutableArray = NSMutableArray()
    
    
    var tempsearchfilteredArray:NSMutableArray = NSMutableArray()
    
    
    //*************Variables for topic
    
    
    var searchTopicArray:NSMutableArray = NSMutableArray()
    
    
    var topicResponseArray:NSMutableArray = NSMutableArray()
    
    
    //*************Variables for recents
    
    var searchName = ""
    
    var recentSearchModelArray:Results<RecentSearchModel>!
    
    var tempsearchfilteredModelArray = [RecentSearchModelFilter]()
    
    var recenttArray = NSArray()
    
    
    var recentArray:NSMutableArray = NSMutableArray()
    
    var recentSearchArray:NSMutableArray = NSMutableArray()
    
    var recentResponseArray:NSMutableArray = NSMutableArray()
    
    
    //*************Variables for tags
    
    
    var searchTagArray:NSMutableArray = NSMutableArray()
    
    var tagSearchArray:NSMutableArray = NSMutableArray()
    
    var tagResponseArray:NSMutableArray = NSMutableArray()
    
    
    let realm = try! Realm()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //        recentSearchModelArray.removeAll()
        //
        //        recentArray.removeAllObjects()
        
        initialSetup()
        
        // Do any additional setup after loading the view.
    }
    
    
    //    override var prefersStatusBarHidden: Bool {
    //        return true
    //    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        btnTagRef.isUserInteractionEnabled = true
        btnRecentRef.isUserInteractionEnabled = true
        btnTopicRef.isUserInteractionEnabled = true
        btnPeopleRef.isUserInteractionEnabled = true
        if tag == 1{
   
            viewPeople.backgroundColor = UIColor(red: 76/255,green: 40/255, blue: 107/255, alpha:1)
            lblPeople.textColor = UIColor(red: 76/255,green: 40/255, blue: 107/255, alpha:1)
            
            viewTopics.backgroundColor = UIColor.lightGray
            lblTopics.textColor = UIColor.darkGray
            
            viewRecents.backgroundColor = UIColor.lightGray
            lblRecents.textColor = UIColor.darkGray
            
            viewTags.backgroundColor = UIColor.lightGray
            lblTags.textColor = UIColor.darkGray
            
            
            
            stopMusic()
            print(tag)
            
            peopleListAPI()
            
        }else if tag == 2{
            
            viewTopics.backgroundColor = UIColor(red: 76/255,green: 40/255, blue: 107/255, alpha:1)
            lblTopics.textColor = UIColor(red: 76/255,green: 40/255, blue: 107/255, alpha:1)
            
            viewPeople.backgroundColor = UIColor.lightGray
            lblPeople.textColor = UIColor.darkGray
            
            viewRecents.backgroundColor = UIColor.lightGray
            lblRecents.textColor = UIColor.darkGray
            
            viewTags.backgroundColor = UIColor.lightGray
            lblTags.textColor = UIColor.darkGray
            
            stopMusic()
            print(tag)
            
            topicAndTagListAPI(apiName: "topgenre")
            
            //userPostList()
            
        }else if tag == 3{
            viewRecents.backgroundColor = UIColor(red: 76/255,green: 40/255, blue: 107/255, alpha:1)
            lblRecents.textColor = UIColor(red: 76/255,green: 40/255, blue: 107/255, alpha:1)
            
            viewPeople.backgroundColor = UIColor.lightGray
            lblPeople.textColor = UIColor.darkGray
            
            viewTopics.backgroundColor = UIColor.lightGray
            lblTopics.textColor = UIColor.darkGray
            
            viewTags.backgroundColor = UIColor.lightGray
            lblTags.textColor = UIColor.darkGray
            recentSearchModelArray = realm.objects(RecentSearchModel.self)
            self.currentLocationAPI()
        }else if tag == 4{
            
            
            viewTags.backgroundColor = UIColor(red: 76/255,green: 40/255, blue: 107/255, alpha:1)
            lblTags.textColor = UIColor(red: 76/255,green: 40/255, blue: 107/255, alpha:1)
            
            viewPeople.backgroundColor = UIColor.lightGray
            lblPeople.textColor = UIColor.darkGray
            
            viewRecents.backgroundColor = UIColor.lightGray
            lblRecents.textColor = UIColor.darkGray
            
            viewTopics.backgroundColor = UIColor.lightGray
            lblTopics.textColor = UIColor.darkGray
            
            print(tag)
            stopMusic()
            topicAndTagListAPI(apiName: "toptags")
            // print(tag)
        }else{
            print("Do nothing")
        }
        
    }
    
    
    
    
    
    override func viewWillDisappear(_ animated: Bool) {
        
        
        
        
        if(isPlaying)
        {
            let btnTag = UserDefaults.standard.value(forKey: "SBTNTAG") as? Int ?? 0
            
            
            
            let indexPath = IndexPath(row: btnTag, section: 0)
            
            guard let cell = tblSearch.cellForRow(at: indexPath) as? HomeTableViewCell else {
                
                return
            }
            
            
            
            player!.pause()
            
            timerCountSa?.invalidate()
            timerCountSa = nil
            timerSa?.invalidate()
            timerSa = nil
            sec = 0
            hr = 0
            min = 0
            
            cell.btnPlayPausedRef.setImage(#imageLiteral(resourceName: "home_play_a"), for: .normal)
            
            isPlaying = false
            cell.audioView.amplitude = 0.0
            
            let totalTimeString = String(format: "%02d:%02d:%02d", hr, min, sec)
            cell.lblTotalTimer.text = totalTimeString
        }
        
    }
    
    
    //MARK:- METHODS
    //MARK:
    
    
    func initialSetup(){
        
        self.tblSearch.tableFooterView = UIView()
        
        NotificationCenter.default.addObserver(self, selector: #selector(SearchVC.stopRecordingAndPlaying(_:)), name: NSNotification.Name(rawValue: "stopRecordingAndPlaying"), object: nil)
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(SearchVC.refreshList(_:)), name: NSNotification.Name(rawValue: "refreshListSearch"), object: nil)
        
        searchBarRef.delegate = self
        
//        AccessCurrentLocationuser()
        peopleListAPI()
        //        currentLocationAPI()
    }
    
    
    
    
    func stopMusic(){
        
        
        
        
        if(isPlaying)
        {
            let btnTag = UserDefaults.standard.value(forKey: "SBTNTAG") as? Int ?? 0
            
            
            
            let indexPath = IndexPath(row: btnTag, section: 0)
            
            guard let cell = tblSearch.cellForRow(at: indexPath) as? HomeTableViewCell else {
                
                return
            }
            
            
            
            player!.pause()
            
            timerCountSa?.invalidate()
            timerCountSa = nil
            timerSa?.invalidate()
            timerSa = nil
            sec = 0
            hr = 0
            min = 0
            
            cell.btnPlayPausedRef.setImage(#imageLiteral(resourceName: "home_play_a"), for: .normal)
            
            isPlaying = false
            cell.audioView.amplitude = 0.0
            
            let totalTimeString = String(format: "%02d:%02d:%02d", hr, min, sec)
            cell.lblTotalTimer.text = totalTimeString
        }
    }
    
    
    
    
    
    //MARK:- WEB SERVICES
    //MARK:
    
    //TODO : IMPLEMENT CURRENT LOCATION API
    
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
                    
                    
                    self.tblSearch.dataSource = self
                    self.tblSearch.delegate = self
                    
                    UIView.setAnimationsEnabled(false)
                    self.tblSearch.beginUpdates()
                    self.tblSearch.reloadSections(NSIndexSet(index: 0) as IndexSet, with: UITableViewRowAnimation.none)
                    self.tblSearch.endUpdates()
                    
                    
                    self.btnTagRef.isUserInteractionEnabled = true
                    self.btnRecentRef.isUserInteractionEnabled = true
                    self.btnTopicRef.isUserInteractionEnabled = true
                    self.btnPeopleRef.isUserInteractionEnabled = true
                    
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
                    
                    guard let cell = self.tblSearch.cellForRow(at: indexPath) as? HomeTableViewCell else {
                        
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
    
    
    
    
    
    
    func userPostList(){
        
        let infoArray = UserDefaults.standard.value(forKey: "USERINFO") as? NSArray ?? []
        //print(infoArray)
        let infoDict = infoArray.object(at: 0) as? NSDictionary ?? [:]
        
        //print(infoDict)
        
        user_id = infoDict.value(forKey: "user_id") as? String ?? ""
        
        //print(user_id)
        
        let token = infoDict.value(forKey: "token") as? String ?? ""
        
        
        if InternetConnection.internetshared.isConnectedToNetwork() {
            
            Indicator.shared.showProgressView(self.view)
            
            
            
            let Passdict = ["token":token] as [String : Any]
            
            print(Passdict)
            
            
            
            WebserviceConnection.requestPOSTURL("postlist/\(user_id)", params: Passdict as [String : AnyObject], headers:nil, success: { (responseJson) in
                
                
                
                if responseJson["status"].stringValue == "SUCCESS" {
                    
                    Indicator.shared.hideProgressView()
                    
                    print(responseJson)
                    
                    if self.postDataArray.count>0{
                        self.postDataArray.removeAll()
                        
                        //  self.recentArray.removeAllObjects()
                        
                        
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
                        
                        let post_id = dict.object(forKey: "post_id") as? String ?? ""
                        
                        let like_flag = dict.object(forKey: "like_flag") as? String ?? ""
                        
                        let like_count = dict.object(forKey: "like_count") as? String ?? ""
                        
                        let reply_count = dict.object(forKey: "reply_count") as? String ?? ""
                        
                        let tag_list = dict.object(forKey: "tag_list") as? String ?? ""
                        
                        
                        //FOR GETTING ALL TOPICS FROM ARRAY
                        self.recentArray.adding(fullname)
                        
                        
                        
                        let postItem = SavedPostsDataModel(user_id: user_id, user_image: user_image, fullname: fullname, username: username, audio_url: audio_url, description: description, topic_name: topic_name, duration: duration, post_id: post_id, like_flag: like_flag, like_count: like_count, reply_count: reply_count, tag_list: tag_list,otherurl:otherurl)
                        self.postDataArray.append(postItem)
                        
                    }
                    
                    
                    self.recentResponseArray = self.dataArray as? NSMutableArray ?? []
                    
                    print(self.audioUrlArray)
                    
                    
                    
                    
                    
                    self.recentResponseArray = self.dataArray.mutableCopy() as? NSMutableArray ?? []
                    
                    print(self.recentResponseArray)
                    
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
                    let cell = self.tblSearch.cellForRow(at: indexPath) as! SearchTableViewCell
                    
                    
                    if self.tag == 1{
                        
                        if self.searchActive == true{
                            
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
                                print(self.recentSearchModelArray)
                                if self.recentSearchModelArray.count > 0{
                                for item in self.recentSearchModelArray{
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
                            }
                            
                        }else{
                            
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
                            
                            
                            self.peopleListAPI()
                        }
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
                        
                        
                        
                        //                        self.currentLocationAPI()
                        
                        
                        
                        
                        
                    }else{
                        
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
                        
                        
                        //   self.peopleListAPI()
                        
                    }
                    
                    
                    // self.viewProfile()
                    
                    
                    
                    
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
    
    
    
    
    
    
    func peopleListAPI(){
        
        let infoArray = UserDefaults.standard.value(forKey: "USERINFO") as? NSArray ?? []
        //print(infoArray)
        let infoDict = infoArray.object(at: 0) as? NSDictionary ?? [:]
        
        //print(infoDict)
        
        let user_id = infoDict.value(forKey: "user_id") as? String ?? ""
        
        //print(user_id)
        
        
        if InternetConnection.internetshared.isConnectedToNetwork() {
            
            Indicator.shared.showProgressView(self.view)
            
            
            
            WebserviceConnection.requestGETURL("topprofile/\(user_id)", success: { (responseJson) in
                
                if responseJson["status"].stringValue == "SUCCESS" {
                    
                    Indicator.shared.hideProgressView()
                    
                    print(responseJson)
                    
                    if self.peopleDataArray.count > 0{
                        self.peopleDataArray.removeAll()
                        self.searchPeopleArray.removeAllObjects()
                        
                    }
                    
                    
                    self.dataArray = responseJson["data"].arrayObject as? NSArray ?? []
                    
                    
                    
                    for item in self.dataArray {
                        
                        let dict = item as? NSDictionary ?? [:]
                        
                        let user_id = dict.object(forKey: "user_id") as? String ?? ""
                        
                        let user_image = dict.object(forKey: "user_image") as? String ?? ""
                        
                        let fullname = dict.object(forKey: "fullname") as? String ?? ""
                        
                        let user_name = dict.object(forKey: "user_name") as? String ?? ""
                        
                        let number_of_post = dict.object(forKey: "number_of_post") as? String ?? ""
                        
                        let topic_match = dict.object(forKey: "topic_match") as? String ?? ""
                        
                        let follower_flag = dict.object(forKey: "follower_flag") as? String ?? ""
                        
                        //FOR GETTING ALL NAMES FROM ARRAY
                        self.searchPeopleArray.add(fullname)
                        
                        
                        let peopleItem = PeopleSearchDataModel(user_id: user_id, user_image: user_image, fullname: fullname, user_name: user_name, topic_match: topic_match, follower_flag: follower_flag, number_of_post: number_of_post)
                        self.peopleDataArray.append(peopleItem)
                        
                    }
                    
                    print(self.searchPeopleArray)
                    
                    
                    self.peopleResponseArray = self.dataArray.mutableCopy() as? NSMutableArray ?? []
                    
                    print(self.peopleResponseArray)
                    
                    self.currentLocationAPI()
                    
                    
                    
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
    
    
    
    func saveToRealm(_ recentSearchModelItem:RecentSearchModel,_ search_name:String){
        recentSearchModelArray = realm.objects(RecentSearchModel.self)
        print(recentSearchModelArray)
        if recentSearchModelArray.count == 0{
            do {
                try realm.write {
                    realm.add(recentSearchModelItem)
                }
            }catch{
                print("Error in saving data: \(error.localizedDescription)")
            }
        }else{
            for item in recentSearchModelArray{
                if item.search_name  == search_name{
                    flag = true
                    break
                }else{
                    flag = false
                }
            }
            if flag == false{
                do {
                    try realm.write {
                        realm.add(recentSearchModelItem)
                    }
                    
                }catch{
                    print("Error in saving data: \(error.localizedDescription)")
                }
               
                self.recentSearchModelArray = self.recentSearchModelArray.sorted(byKeyPath: "created", ascending:false)
                self.recentArray.add(search_name)
            }else{

                print("do nothing")
            }
        }
        
        
       
    }
    
    func topicAndTagListAPI(apiName:String){
        
        
        
        if InternetConnection.internetshared.isConnectedToNetwork() {
            
            Indicator.shared.showProgressView(self.view)
            
            
            
            WebserviceConnection.requestGETURL(apiName, success: { (responseJson) in
                
                if responseJson["status"].stringValue == "SUCCESS" {
                    
                    Indicator.shared.hideProgressView()
                    
                    print(responseJson)
                    self.btnTagRef.isUserInteractionEnabled = true
                    self.btnRecentRef.isUserInteractionEnabled = true
                    self.btnTopicRef.isUserInteractionEnabled = true
                    self.btnPeopleRef.isUserInteractionEnabled = true
                    
                    if self.tagArray1.count > 0 && apiName == "toptags"{
                        self.tagArray1.removeAll()
                        self.searchTopicArray.removeAllObjects()
                        self.searchTagArray.removeAllObjects()
                    }else{
                        self.tagArray.removeAll()
                        self.searchTopicArray.removeAllObjects()
                        self.searchTagArray.removeAllObjects()
                    }
                    
                    
                    self.dataArray = responseJson["data"].arrayObject as? NSArray ?? []
                    
                    if apiName == "toptags"{
                        
                        for item in self.dataArray {
                            
                            let dict = item as? NSDictionary ?? [:]
                            
                            
                            let tag_id = dict.object(forKey: "tag_id") as? String ?? ""
                            
                            let num_of_post = dict.object(forKey: "num_of_post") as? String ?? ""
                            
                            let tag_name = dict.object(forKey: "tag_name") as? String ?? ""
                            
                            
                            
                            //FOR GETTING ALL TOPICS FROM ARRAY
                            self.searchTagArray.add(tag_name)
                            
                            let tagItem = TagDataModel(tag_id: tag_id, num_of_post: num_of_post, tag_name: tag_name, icon: "hash_tag")
                            self.tagArray1.append(tagItem)
                            
                        }
                        
                        
                        self.tagResponseArray = self.dataArray.mutableCopy() as? NSMutableArray ?? []
                        
                        print(self.tagResponseArray)
                        
                        
                        
                    }else{
                        
                        for item in self.dataArray {
                            
                            let dict = item as? NSDictionary ?? [:]
                            
                            
                            let tag_id = dict.object(forKey: "topic_id") as? String ?? ""
                            
                            let num_of_post = dict.object(forKey: "num_of_post") as? String ?? ""
                            
                            let tag_name = dict.object(forKey: "topic_name") as? String ?? ""
                            
                            let icon = dict.object(forKey: "icon") as? String ?? ""
                            
                            
                            //FOR GETTING ALL TOPICS FROM ARRAY
                            self.searchTopicArray.add(tag_name)
                            
                            
                            let tagItem = TagDataModel(tag_id: tag_id, num_of_post: num_of_post, tag_name: tag_name, icon: icon)
                            self.tagArray.append(tagItem)
                            
                        }
                        
                        
                        
                        
                        
                    }
                    
                    self.topicResponseArray = self.dataArray.mutableCopy() as? NSMutableArray ?? []
                    
                    print(self.topicResponseArray)
                    
                    self.currentLocationAPI()
                    
                    
                    
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
    
    
    
    
    
    
    
    
    
    
    //MARK:- ACTIONS
    //MARK:
    
    
    @IBAction func btnChoiceForSearchTapped(_ sender: UIButton) {
        
        tag = sender.tag
        
        searchBarRef.text = ""
        
        searchActive = false
        
        
        
        
        
        if tag == 1{
            
            
            
            
            
            viewPeople.backgroundColor = UIColor(red: 76/255,green: 40/255, blue: 107/255, alpha:1)
            lblPeople.textColor = UIColor(red: 76/255,green: 40/255, blue: 107/255, alpha:1)
            
            viewTopics.backgroundColor = UIColor.lightGray
            lblTopics.textColor = UIColor.darkGray
            
            viewRecents.backgroundColor = UIColor.lightGray
            lblRecents.textColor = UIColor.darkGray
            
            viewTags.backgroundColor = UIColor.lightGray
            lblTags.textColor = UIColor.darkGray
            
            
            
            stopMusic()
            print(tag)
            
            peopleListAPI()
            
        }else if tag == 2{
            
            viewTopics.backgroundColor = UIColor(red: 76/255,green: 40/255, blue: 107/255, alpha:1)
            lblTopics.textColor = UIColor(red: 76/255,green: 40/255, blue: 107/255, alpha:1)
            
            viewPeople.backgroundColor = UIColor.lightGray
            lblPeople.textColor = UIColor.darkGray
            
            viewRecents.backgroundColor = UIColor.lightGray
            lblRecents.textColor = UIColor.darkGray
            
            viewTags.backgroundColor = UIColor.lightGray
            lblTags.textColor = UIColor.darkGray
            
            stopMusic()
            print(tag)
            
            topicAndTagListAPI(apiName: "topgenre")
            
            //userPostList()
            
        }else if tag == 3{
            viewRecents.backgroundColor = UIColor(red: 76/255,green: 40/255, blue: 107/255, alpha:1)
            lblRecents.textColor = UIColor(red: 76/255,green: 40/255, blue: 107/255, alpha:1)
            
            viewPeople.backgroundColor = UIColor.lightGray
            lblPeople.textColor = UIColor.darkGray
            
            viewTopics.backgroundColor = UIColor.lightGray
            lblTopics.textColor = UIColor.darkGray
            
            viewTags.backgroundColor = UIColor.lightGray
            lblTags.textColor = UIColor.darkGray
            recentSearchModelArray = realm.objects(RecentSearchModel.self)
            self.currentLocationAPI()
        }else if tag == 4{
            
            
            viewTags.backgroundColor = UIColor(red: 76/255,green: 40/255, blue: 107/255, alpha:1)
            lblTags.textColor = UIColor(red: 76/255,green: 40/255, blue: 107/255, alpha:1)
            
            viewPeople.backgroundColor = UIColor.lightGray
            lblPeople.textColor = UIColor.darkGray
            
            viewRecents.backgroundColor = UIColor.lightGray
            lblRecents.textColor = UIColor.darkGray
            
            viewTopics.backgroundColor = UIColor.lightGray
            lblTopics.textColor = UIColor.darkGray
            
            print(tag)
            stopMusic()
            topicAndTagListAPI(apiName: "toptags")
            // print(tag)
        }else{
            print("Do nothing")
        }
        
    }
    
    
    @objc func stopRecordingAndPlaying(_ notification: Notification) {
        
        
        stopMusic()
        
        
    }
    
    
    
    @objc func refreshList(_ notification: Notification) {
        
        
        if rowNumber < postDataArray.count{
            
            
            var replyCounts = Int(postDataArray[rowNumber].reply_count as? String ?? "") as? Int ?? 0
            print(replyCounts)
            
            replyCounts = replyCounts + 1
            
            
            let indexPath = IndexPath(row: rowNumber, section: 0)
            
            
            guard let cell = self.tblSearch.cellForRow(at: indexPath) as? HomeTableViewCell else {
                
                return
            }
            
            
            
            cell.btnViewAllReplyRef.setTitle("View all \(replyCounts) replies", for: .normal)
            
            
        }
            
        else{
            print("Do nothing")
        }
        
        
        
        
    }
    
    
    @objc func btnCommentTapped1(sender: UIButton){
        
        
        rowNumber = sender.tag
        
        
        stopMusic()
        
        UserDefaults.standard.set("FROMSEARCH", forKey: "ISCOMINGFORNOTIFICATION")
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
        
        
        stopMusic()
        
        
        
        UserDefaults.standard.set("FROMSEARCH", forKey: "ISCOMINGFORNOTIFICATION")
        print(sender.tag)
        
        rowNumber = sender.tag
        
        
        let dataDict = postDataArray[sender.tag]
        
        
        
        let audioID = dataDict.post_id ?? ""
        
        
        
        print(audioID)
        
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "CommentMikeVC") as! CommentMikeVC
        
        vc.audioID = audioID
        
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    @objc func btnShareTapped(sender: UIButton){
        stopMusic()
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
        
        
        UserDefaults.standard.set("FROMSEARCH", forKey: "ISCOMINGFORNOTIFICATION")
        print(sender.tag)
        
        rowNumber = sender.tag
        
        
        
        stopMusic()
        
        
        let dataDict = postDataArray[sender.tag]
        
        
        
        let audioID = dataDict.post_id ?? ""
        
        
        
        print(audioID)
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "RepliesVC") as! RepliesVC
        
        vc.audioID = audioID
        
        
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    
    
    
    
    
    @objc func btnPlayPausedTapped(sender: UIButton){
        
        UserDefaults.standard.set(sender.tag, forKey: "SBTNTAG")
        currentAudioIndex = sender.tag
        
        timerCountSa?.invalidate()
        timerCountSa = nil
        timerSa?.invalidate()
        timerSa = nil
        
        
        let prevTag = UserDefaults.standard.value(forKey: "SPBTNTAG") as? Int ?? 0
        print(prevTag)
        let btnTag = UserDefaults.standard.value(forKey: "SBTNTAG") as? Int ?? 0
        
        print(btnTag)
        
        if btnTag != prevTag{
            
            
            if(isPlaying)
            {
                
                
                let prevIndexPath = IndexPath(row: prevTag, section: 0)
                guard let prevCell = tblSearch.cellForRow(at: prevIndexPath) as? HomeTableViewCell else {
                    
                    return
                }
                
                
                
                //player!.pause()
                
                timerCountSa?.invalidate()
                timerCountSa = nil
                timerSa?.invalidate()
                timerSa = nil
                sec = 0
                hr = 0
                min = 0
                
                
                
                prevCell.btnPlayPausedRef.setImage(#imageLiteral(resourceName: "home_play_a"), for: .normal)
                prevCell.audioView.amplitude = 0.0
                
                let totalTimeString = String(format: "%02d:%02d:%02d", hr, min, sec)
                prevCell.lblTotalTimer.text = totalTimeString
                
                isPlaying = false
                
                
                
            }else{
                
            }
            
            
            
        }
        
        
        
        
        
        
        let indexPath = IndexPath(row: btnTag, section: 0)
        let cell = tblSearch.cellForRow(at: indexPath) as! HomeTableViewCell
        
        
        
        
        let dataDict = postDataArray[sender.tag]
        
        
        
        audioUrl = NSURL(string: dataDict.otherurl ?? "")! as URL
        
        
        
        print(audioUrl)
        
        
        if(isPlaying)
        {
            
            player!.pause()
            
            timerCountSa?.invalidate()
            timerCountSa = nil
            timerSa?.invalidate()
            timerSa = nil
            sec = 0
            hr = 0
            min = 0
            
            cell.btnPlayPausedRef.setImage(#imageLiteral(resourceName: "home_play_a"), for: .normal)
            
            isPlaying = false
            cell.audioView.amplitude = 0.0
            
            let totalTimeString = String(format: "%02d:%02d:%02d", hr, min, sec)
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
                
                
                
                
                
                timerSa = Timer.scheduledTimer(timeInterval: 0.009, target: self, selector: #selector(self.refreshAudioView(_:)), userInfo: nil, repeats: true)
                
                cell.btnPlayPausedRef.setImage(UIImage(named: "home_pause_a"),for: .normal)
                player!.play()
                
                
                isPlaying = true
            }
            else
            {
                
                
                _ = SweetAlert().showAlert("Escalate", subTitle: "Audio file is missing.", style: AlertStyle.error)
                
            }
        }
        
        
        let prevBtnTag = UserDefaults.standard.value(forKey: "SBTNTAG") as? Int ?? 0
        
        print(prevBtnTag)
        
        UserDefaults.standard.set(prevBtnTag, forKey: "SPBTNTAG")
        
        
        
        
        
    }
    
    
    
    func countDownTimet(){
        
        timerCountSa = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.update), userInfo: nil, repeats: true)
        
    }
    
    
    
    @objc internal func refreshAudioView(_:Timer) {
        
        let btnTag = UserDefaults.standard.value(forKey: "SBTNTAG") as? Int ?? 0
        
        
        let indexPath = IndexPath(row: btnTag, section: 0)
        
        
        guard let cell = tblSearch.cellForRow(at: indexPath) as? HomeTableViewCell else {
            
            return
        }
        
        
        
        if cell.audioView.amplitude <= cell.audioView.idleAmplitude || cell.audioView.amplitude > 1.0 {
            self.change *= -1.0
        }
        
        
        cell.audioView.amplitude += self.change
        
        
        
        
    }
    
    
    @objc func update() {
        
        
        let btnTag = UserDefaults.standard.value(forKey: "SBTNTAG") as? Int ?? 0
        
        let indexPath = IndexPath(row: btnTag, section: 0)
        
        let dataDict = postDataArray[btnTag]
        
        
        guard let cell = tblSearch.cellForRow(at: indexPath) as? HomeTableViewCell else {
            
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
            
            let totalTimeString = String(format: "%02d:%02d:%02d", hr, min, sec)
            cell.lblTotalTimer.text = totalTimeString
            
        }
        else{
            print("TIMERCOUNT")
            print(count)
            sec = 0
            hr = 0
            min = 0
            
            timerSa?.invalidate()
            timerSa = nil
            timerCountSa?.invalidate()
            timerCountSa = nil
            
            let totalTimeString = dataDict.duration ?? ""
            cell.lblTotalTimer.text = totalTimeString
            
            
            cell.btnPlayPausedRef.setImage(UIImage(named: "home_play_a"),for: .normal)
            
            cell.audioView.amplitude = 0.0
            isPlaying = false
            //STOP PLAYING AND ANIMATION
            
            //autoPlayList()
            
            
            
            
            
            
        }
    }
    
    
    
    
    
    
    
    
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
        if tag == 1{
            if searchActive == true{
                print("aman")
                
                let dataDict = tempsearchfilteredArray.object(at: sender.tag) as? NSDictionary ?? [:]
                
                print(dataDict)
                
                let userID = dataDict.value(forKey: "user_id") as? String ?? ""
                
                let fullname = dataDict.value(forKey: "fullname") as? String ?? ""
                
                let follower_flag = dataDict.value(forKey: "follower_flag") as? String ?? ""
                
                let number_of_post = dataDict.value(forKey: "number_of_post") as? String ?? ""
                
                let topic_match = dataDict.value(forKey: "topic_match") as? String ?? ""
                
                let user_id = dataDict.value(forKey: "user_id") as? String ?? ""
                
                let user_image = dataDict.value(forKey: "user_image") as? String ?? ""
                
                let user_name = dataDict.value(forKey: "user_name") as? String ?? ""
                
                let recentSearchItem = RecentSearchModel()
                recentSearchItem.type = "people"
                recentSearchItem.search_name = fullname
                recentSearchItem.follower_flag = follower_flag
                recentSearchItem.fullname = fullname
                recentSearchItem.number_of_post = number_of_post
                recentSearchItem.topic_match = topic_match
                recentSearchItem.user_id = user_id
                recentSearchItem.user_image = user_image
                recentSearchItem.user_name = user_name
                recentSearchItem.tag_id = ""
                recentSearchItem.num_of_post = ""
                recentSearchItem.tag_name = ""
                recentSearchItem.icon = ""
                recentSearchItem.created = Date()
                let search_name = recentSearchItem.search_name
                print(search_name)
                self.saveToRealm(recentSearchItem,search_name)
                self.recentArray.add(search_name)
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "OtherProfileVC") as! OtherProfileVC
                vc.user_id = userID
                self.navigationController?.pushViewController(vc, animated: true)
            }else{
                
                
                print("aman")
                
                let dataDict = peopleDataArray[sender.tag]
                
                print(dataDict)
                
                let userID = dataDict.user_id ?? ""
                
                let fullname = dataDict.fullname ?? ""
                
                let follower_flag = dataDict.follower_flag ?? ""
                
                let number_of_post = dataDict.number_of_post ?? ""
                
                let topic_match = dataDict.topic_match ?? ""
                
                let user_id = dataDict.user_id ?? ""
                
                let user_image = dataDict.user_image ?? ""
                
                let user_name = dataDict.user_name ?? ""
                
                let recentSearchItem = RecentSearchModel()
                recentSearchItem.type = "people"
                recentSearchItem.search_name = fullname
                recentSearchItem.follower_flag = follower_flag
                recentSearchItem.fullname = fullname
                recentSearchItem.number_of_post = number_of_post
                recentSearchItem.topic_match = topic_match
                recentSearchItem.user_id = user_id
                recentSearchItem.user_image = user_image
                recentSearchItem.user_name = user_name
                recentSearchItem.tag_id = ""
                recentSearchItem.num_of_post = ""
                recentSearchItem.tag_name = ""
                recentSearchItem.icon = ""
                recentSearchItem.created = Date()
                let search_name = recentSearchItem.search_name ?? ""
                print(search_name)
                self.saveToRealm(recentSearchItem,search_name)
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "OtherProfileVC") as! OtherProfileVC
                vc.user_id = userID
                
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }else{
            print("YAHA AYA")
            if searchActive == true{
                
                print("aman")
                
                
                let dataDict = tempsearchfilteredModelArray[sender.tag]
                
                print(dataDict)
                
                let userID = dataDict.user_id ?? ""
                
                
                
                
                
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "OtherProfileVC") as! OtherProfileVC
                
                vc.user_id = userID
                
                self.navigationController?.pushViewController(vc, animated: true)
                
            }else{
                print("aman")
                
                
                let dataDict = recentSearchModelArray[sender.tag]

                print(dataDict)

                let userID = dataDict.user_id ?? ""





                let vc = self.storyboard?.instantiateViewController(withIdentifier: "OtherProfileVC") as! OtherProfileVC

                vc.user_id = userID

                self.navigationController?.pushViewController(vc, animated: true)
                
            }
            
        }
    }
    
    
    @objc func btnFollowUnfollowTapped(sender: UIButton){
        print(sender.tag)
        //asdfasdf
        
        if tag == 1{
            
            
            if searchActive == true{
                
                let dataDict = tempsearchfilteredArray.object(at: sender.tag) as? NSDictionary ?? [:]
                
                print(dataDict)
                
                let userID = dataDict.value(forKey: "user_id") as? String ?? ""
                
                followUnfollowingService(user_id:userID, index: sender.tag)
            }else{
                
                let dataDict = peopleDataArray[sender.tag]
                
                print(dataDict)
                
                let userID = dataDict.user_id ?? ""
                
                followUnfollowingService(user_id:userID, index: sender.tag)
            }
            
        }else{
            if searchActive == true{
                let dataDict = tempsearchfilteredModelArray[sender.tag]
                
                print(dataDict)
                
                let userID = dataDict.user_id ?? ""
                
                followUnfollowingService(user_id:userID, index: sender.tag)
            }else{
                let dataDict = recentSearchModelArray![sender.tag]
                
                print(dataDict)
                
                let userID = dataDict.user_id ?? ""
                
                followUnfollowingService(user_id:userID, index: sender.tag)
            }
        }
        
        
    }
    
    
    
    
    // MARK: SEARCH BAR DELEGATE METHODS
    
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
  
        self.btnTagRef.isUserInteractionEnabled = true
        self.btnRecentRef.isUserInteractionEnabled = true
        self.btnTopicRef.isUserInteractionEnabled = true
        self.btnPeopleRef.isUserInteractionEnabled = true
            searchActive = false
  
        
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        self.btnTagRef.isUserInteractionEnabled = true
        self.btnRecentRef.isUserInteractionEnabled = true
        self.btnTopicRef.isUserInteractionEnabled = true
        self.btnPeopleRef.isUserInteractionEnabled = true
        if searchBar.text == ""{
            
            searchActive = false
            peopleListAPI()
            
            
        }else{
            
            searchActive = true
            
        }
        
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.btnTagRef.isUserInteractionEnabled = true
        self.btnRecentRef.isUserInteractionEnabled = true
        self.btnTopicRef.isUserInteractionEnabled = true
        self.btnPeopleRef.isUserInteractionEnabled = true
        searchActive = false
        
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.btnTagRef.isUserInteractionEnabled = true
        self.btnRecentRef.isUserInteractionEnabled = true
        self.btnTopicRef.isUserInteractionEnabled = true
        self.btnPeopleRef.isUserInteractionEnabled = true
        searchActive = false
        self.searchBarRef.endEditing(true)
    }
    
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        self.btnTagRef.isUserInteractionEnabled = true
        self.btnRecentRef.isUserInteractionEnabled = true
        self.btnTopicRef.isUserInteractionEnabled = true
        self.btnPeopleRef.isUserInteractionEnabled = true
        
        if tag == 1{
            
            let dummyFilterArray = filteredArray.mutableCopy() as? NSMutableArray ?? []
            
            dummyFilterArray.removeAllObjects()
            
            filteredArray = dummyFilterArray.mutableCopy() as? NSArray ?? []
            
            
            
            filteredArray = (searchPeopleArray.filter({ (text) -> Bool in
                
                let tmp: NSString = text as! NSString
                
                let range = tmp.range(of: searchText, options: NSString.CompareOptions.caseInsensitive)
                
                return range.location != NSNotFound
                
                
            })  as! NSArray )
            
            
            print("Filter",filteredArray)
            
            
            if(filteredArray.count == 0){
                
                searchActive = false
                
            } else {
                
                searchActive = true
                
                
                
            }
            
            
            print("Filter Array",filteredArray)
            
            
            
            tempsearchfilteredArray.removeAllObjects()
            
            print("Temprary",tempsearchfilteredArray)
            
            
            for i in 0..<self.peopleResponseArray.count {
                
                let temdict = self.peopleResponseArray.object(at: i)as! [String:Any]
                
                let selectedname =  temdict["fullname"] as? String ?? ""
                
                for j in 0..<self.filteredArray.count{
                    
                    let name = self.filteredArray.object(at: j) as! String
                    
                    if name  ==  selectedname {
                        
                        tempsearchfilteredArray.add(temdict)
                        
                    }else{
                        
                        // Do nothing
                        
                    }
                    
                    
                }

                
            }
             print("Temprary aa",tempsearchfilteredArray)
            if tempsearchfilteredArray.count == 0 && searchBar.text == ""{
                
                searchActive = false
            }else{
               searchActive = true
            }
            tblSearch.reloadData()
        }
            
            
            
            
            
            
            
        else if tag == 2{
            
            
            
            let dummyFilterArray = filteredArray.mutableCopy() as? NSMutableArray ?? []
            
            dummyFilterArray.removeAllObjects()
            
            filteredArray = dummyFilterArray.mutableCopy() as? NSArray ?? []
            
            
            
            filteredArray = (searchTopicArray.filter({ (text) -> Bool in
                // fsa
                let tmp: NSString = text as! NSString
                
                let range = tmp.range(of: searchText, options: NSString.CompareOptions.caseInsensitive)
                
                return range.location != NSNotFound
                
                
            })  as! NSArray )
            
            
            
            if(filteredArray.count == 0){
                
                searchActive = false
                
            } else {
                
                searchActive = true
                
                
                
            }
            
            
            print(filteredArray)
            
            
            
            tempsearchfilteredArray.removeAllObjects()
            
            print(tempsearchfilteredArray)
            
            
            for i in 0..<self.topicResponseArray.count {
                
                let temdict = self.topicResponseArray.object(at: i)as! [String:Any]
                
                let selectedname =  temdict["topic_name"] as? String ?? ""
                
                for j in 0..<self.filteredArray.count{
                    
                    let name = self.filteredArray.object(at: j) as! String
                    
                    if name  ==  selectedname {
                        
                        tempsearchfilteredArray.add(temdict)
                        
                    }else{
                        
                        // Do nothing
                        
                    }
                    
                    
                }
               
                
            }
            
            print("Temprary aa",tempsearchfilteredArray)
            if tempsearchfilteredArray.count == 0 && searchBar.text == ""{
                
                searchActive = false
            }else{
                searchActive = true
            }
            
             tblSearch.reloadData()
            
        }else if tag == 3{
            
            if tempsearchfilteredModelArray.count > 0{
                tempsearchfilteredModelArray.removeAll()
            }
            if searchBar.text!.isEmpty {
                searchActive = false
            }
            else {
                searchActive = true
                recentSearchModelArray = realm.objects(RecentSearchModel.self)
                print(recentSearchModelArray)
                if recentSearchModelArray.count >= 1 {
                    for index in 0...recentSearchModelArray.count - 1 {
                        if let dictResponse = recentSearchModelArray[index] as? AnyObject{
                            print(dictResponse)
                            if let search_name = dictResponse.search_name{
                                if (search_name.lowercased().range(of: searchText.lowercased()) != nil) {
                                    guard let tempDict = dictResponse as? AnyObject else{
                                        print("NO tempDict")
                                        return
                                    }
                                    guard let type = tempDict.value(forKey: "type") as? String else{
                                        print("NO type")
                                        return
                                    }
                                    guard let search_name = tempDict.value(forKey: "search_name") as? String else{
                                        print("NO search_name")
                                        return
                                    }
                                    guard let follower_flag = tempDict.value(forKey: "follower_flag") as? String else{
                                        print("NO follower_flag")
                                        return
                                    }
                                    guard let fullname = tempDict.value(forKey: "fullname") as? String else{
                                        print("NO fullname")
                                        return
                                    }
                                    guard let number_of_post = tempDict.value(forKey: "number_of_post") as? String else{
                                        print("NO number_of_post")
                                        return
                                    }
                                    guard let topic_match = tempDict.value(forKey: "topic_match") as? String else{
                                        print("NO topic_match")
                                        return
                                    }
                                    guard let user_id = tempDict.value(forKey: "user_id") as? String else{
                                        print("NO user_id")
                                        return
                                    }
                                    guard let user_image = tempDict.value(forKey: "user_image") as? String else{
                                        print("NO user_image")
                                        return
                                    }
                                    guard let user_name = tempDict.value(forKey: "user_name") as? String else{
                                        print("NO user_name")
                                        return
                                    }
                                    guard let tag_id = tempDict.value(forKey: "tag_id") as? String else{
                                        print("NO tag_id")
                                        return
                                    }
                                    guard let num_of_post = tempDict.value(forKey: "num_of_post") as? String else{
                                        print("NO num_of_post")
                                        return
                                    }
                                    guard let tag_name = tempDict.value(forKey: "tag_name") as? String else{
                                        print("NO tag_name")
                                        return
                                    }
                                    guard let icon = tempDict.value(forKey: "icon") as? String else{
                                        print("NO icon")
                                        return
                                    }
                                    guard let created = tempDict.value(forKey: "created") as? Date else{
                                        print("NO created")
                                        return
                                    }
                                    let filterItem = RecentSearchModelFilter(type: type, search_name: search_name, follower_flag: follower_flag, fullname: fullname, number_of_post: number_of_post, topic_match: topic_match, user_id: user_id, user_image: user_image, user_name: user_name, tag_id: tag_id, num_of_post: num_of_post, tag_name: tag_name, icon: icon, created: created)
                                    tempsearchfilteredModelArray.append(filterItem)
                                }
                            }
                        }else{
                            print("search nai karunga")
                        }
                    }
                }
            }
            tblSearch.reloadData()
        }else{
            
            
            
            let dummyFilterArray = filteredArray.mutableCopy() as? NSMutableArray ?? []
            
            dummyFilterArray.removeAllObjects()
            
            filteredArray = dummyFilterArray.mutableCopy() as? NSArray ?? []
            
            
            
            filteredArray = (searchTagArray.filter({ (text) -> Bool in
                // fsa
                let tmp: NSString = text as! NSString
                
                let range = tmp.range(of: searchText, options: NSString.CompareOptions.caseInsensitive)
                
                return range.location != NSNotFound
                
                
            })  as! NSArray )
            
            
            
            if(filteredArray.count == 0){
                
                searchActive = false
                
            } else {
                
                searchActive = true
                
                
                
            }
            
            
            print(filteredArray)
            
            
            
            tempsearchfilteredArray.removeAllObjects()
            
            print(tempsearchfilteredArray)
            
            
            for i in 0..<self.tagResponseArray.count {
                
                let temdict = self.tagResponseArray.object(at: i)as! [String:Any]
                
                let selectedname =  temdict["tag_name"] as? String ?? ""
                
                for j in 0..<self.filteredArray.count{
                    
                    let name = self.filteredArray.object(at: j) as! String
                    
                    if name  ==  selectedname {
                        
                        tempsearchfilteredArray.add(temdict)
                        
                    }else{
                        
                        // Do nothing
                        
                    }
                    
                    
                }
                
                
            }
            
            
            
            if tempsearchfilteredArray.count == 0 && searchBar.text == ""{
                
                searchActive = false
            }else{
                searchActive = true
            }
            tblSearch.reloadData()
            
            
        }
        
        
        
        
        
        
        
    }
    

    
    
}

//MARK:- EXTENTION TABLE VIEW
//MARK:

extension SearchVC:UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
      btnTagRef.isUserInteractionEnabled = false
        
         btnRecentRef.isUserInteractionEnabled = false
        btnTopicRef.isUserInteractionEnabled = false
         btnPeopleRef.isUserInteractionEnabled = false
        
        
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView){
        
        btnTagRef.isUserInteractionEnabled = true
        btnRecentRef.isUserInteractionEnabled = true
        btnTopicRef.isUserInteractionEnabled = true
        btnPeopleRef.isUserInteractionEnabled = true
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if tag == 1{
            
            
            if searchActive == true {
                
                return tempsearchfilteredArray.count
                
            }else{
                
                return peopleDataArray.count
                
            }
            
            
            
            
        }else if tag == 2{
            
            if searchActive == true {
                
                return tempsearchfilteredArray.count
                
            }else{
                
                return tagArray.count
                
            }
            
            
            
            
            
            
            
        }else if tag == 3{
            
            if searchActive == true {
                
                return tempsearchfilteredModelArray.count
                
            }else{
                
                return recentSearchModelArray?.count ?? 0
                
            }
            
            
            
            
        }else if tag == 4{
            
            
            if searchActive == true {
                
                return tempsearchfilteredArray.count
                
            }else{
                
                return tagArray1.count
                
            }
            
            
            
            
        }else{
            return peopleDataArray.count
        }
    }
    

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var CEll  = UITableViewCell()
        
        //  tblSearch.register(UINib(nibName: "SearchTableViewCell", bundle: nil), forCellReuseIdentifier: "SearchTableViewCell")
        
        
        if tag == 1{
            
            if searchActive == true {
                
                tblSearch.register(UINib(nibName: "SearchTableViewCell", bundle: nil), forCellReuseIdentifier: "SearchTableViewCell")
                
                let cell = tblSearch.dequeueReusableCell(withIdentifier: "SearchTableViewCell", for: indexPath) as! SearchTableViewCell
                
                
                if tempsearchfilteredArray.count > 0{
                    
                    let dataDict = tempsearchfilteredArray.object(at: indexPath.row) as? NSDictionary ?? [:]
                    
                    
                    let image = dataDict.value(forKey: "user_image") as? String ?? ""
                    
                    cell.imgView_user.sd_setImage(with: URL(string: image as? String ?? ""), placeholderImage: UIImage(named: "user_signup"))
                    
                    
                    cell.btnFullName.setTitle(dataDict.value(forKey: "fullname") as? String ?? "", for: .normal)
                    
                    
                    
                    let matchedTopics = dataDict.value(forKey: "topic_match") as? String ??  ""
                    if matchedTopics == "0"{
                        cell.lblUserName.isHidden = true
                    }else{
                        cell.lblUserName.isHidden = false
                        cell.lblUserName.text = "\(matchedTopics) similar interests"
                    }
                    
                    
                    let user_id = dataDict.value(forKey: "user_id") as? String ?? ""
                    
                    if user_id == self.user_id  {
                        
                        cell.btnOtherProfileRef.isHidden = true
                        cell.btnFullName.isUserInteractionEnabled = false
                        cell.btnFollowRef.isHidden = true
                    }
                    else{
                        cell.btnOtherProfileRef.isHidden = false
                        cell.btnFullName.isUserInteractionEnabled = true
                        cell.btnFollowRef.isHidden = false
                        
                        
                        let follower_flag = dataDict.value(forKey: "follower_flag") as? String ?? ""
                        
                        if follower_flag == "1"{
                            
                            cell.btnFollowRef.setTitle("Unfollow", for: .normal)
                            cell.btnFollowRef.backgroundColor = UIColor(red: 110/255, green: 196/255, blue: 124/255, alpha: 1)
                        }else{
                            
                            cell.btnFollowRef.setTitle("Follow", for: .normal)
                            cell.btnFollowRef.backgroundColor = UIColor(red: 74/255, green: 37/255, blue: 107/255, alpha: 1)
                            
                            
                        }
                        
                    }
                    
                    let userID = dataDict.value(forKey: "user_id") as? String ?? ""
                    
                    if userID == self.user_id  {
                        
                        cell.btnOtherProfileRef.isHidden = true
                    }
                    else{
                        cell.btnOtherProfileRef.isHidden = false
                    }
                    
                    cell.btnOtherProfileRef.tag = indexPath.row
                    cell.btnOtherProfileRef.addTarget(self, action: #selector(btnOtherProfileTapped), for: .touchUpInside)
                    
                    cell.btnFullName.tag = indexPath.row
                    cell.btnFullName.addTarget(self, action: #selector(btnOtherProfileTapped), for: .touchUpInside)
                    
                    cell.btnFollowRef.tag = indexPath.row
                    
                    cell.btnFollowRef.addTarget(self, action: #selector(btnFollowUnfollowTapped), for: .touchUpInside)
                    
                    
                    CEll = cell
                    
                }else{
                    print("do nothing")
                }
                
                
            }else{
                
                tblSearch.register(UINib(nibName: "SearchTableViewCell", bundle: nil), forCellReuseIdentifier: "SearchTableViewCell")
                
                let cell = tblSearch.dequeueReusableCell(withIdentifier: "SearchTableViewCell", for: indexPath) as! SearchTableViewCell
                
                
                if peopleDataArray.count > 0{
                    
                    
                    let dataDict = peopleDataArray[indexPath.row]
                    
                    let image = dataDict.user_image ?? ""
                    
                    cell.imgView_user.sd_setImage(with: URL(string: image as? String ?? ""), placeholderImage: UIImage(named: "user_signup"))
                    
                    
                    cell.btnFullName.setTitle(dataDict.fullname ?? "", for: .normal)
                    
                    
                    let matchedTopics = dataDict.topic_match ??  ""
                    if matchedTopics == "0"{
                        cell.lblUserName.isHidden = true
                    }else{
                        cell.lblUserName.isHidden = false
                        cell.lblUserName.text = "\(dataDict.topic_match ??  "") similar interests"
                    }
                    
                    
                    
                    
                    if dataDict.user_id == self.user_id  {
                        
                        cell.btnOtherProfileRef.isHidden = true
                        cell.btnFullName.isUserInteractionEnabled = false
                        cell.btnFollowRef.isHidden = true
                    }
                    else{
                        cell.btnOtherProfileRef.isHidden = false
                        
                        cell.btnFullName.isUserInteractionEnabled = true
                        cell.btnFollowRef.isHidden = false
                        
                        if dataDict.follower_flag == "1"{
                            
                            cell.btnFollowRef.setTitle("Unfollow", for: .normal)
                            cell.btnFollowRef.backgroundColor = UIColor(red: 110/255, green: 196/255, blue: 124/255, alpha: 1)
                        }else{
                            
                            cell.btnFollowRef.setTitle("Follow", for: .normal)
                            cell.btnFollowRef.backgroundColor = UIColor(red: 74/255, green: 37/255, blue: 107/255, alpha: 1)
                            
                            
                        }
                        
                    }
                    
                    
                    
                    cell.btnOtherProfileRef.tag = indexPath.row
                    cell.btnOtherProfileRef.addTarget(self, action: #selector(btnOtherProfileTapped), for: .touchUpInside)
                    
                    cell.btnFullName.tag = indexPath.row
                    cell.btnFullName.addTarget(self, action: #selector(btnOtherProfileTapped), for: .touchUpInside)
                    
                    cell.btnFollowRef.tag = indexPath.row
                    
                    cell.btnFollowRef.addTarget(self, action: #selector(btnFollowUnfollowTapped), for: .touchUpInside)
                    
                    
                    CEll = cell
                }
                
                
            }
            
            return CEll
            
        }
        else if tag == 2{
            
            
            
            if searchActive == true {
                
                tblSearch.register(UINib(nibName: "SearchXibs", bundle: nil), forCellReuseIdentifier: "SearchXibs")
                
                let cell = tblSearch.dequeueReusableCell(withIdentifier: "SearchXibs", for: indexPath) as! SearchXibs
                
                
                if tempsearchfilteredArray.count>0{
                    
                    let dataDict = tempsearchfilteredArray.object(at: indexPath.row) as? NSDictionary ?? [:]
                    
                    cell.lblTitle.text = dataDict.value(forKey: "topic_name") as? String ?? ""
                    //cell.lblTitle.text = dataDict.tag_name ?? ""
                    
                    let icon = dataDict.value(forKey: "icon") as? String ?? ""
                    
                    print(icon)
                    
                    
                    cell.imgSearch.isHidden = true
                    cell.imgLeadingConstraints.constant = 0
                    cell.imgWidthConstarintsOutlet.constant = 0
                    
                    cell.imgSearch.sd_setImage(with: URL(string: icon as? String ?? ""), placeholderImage: UIImage(named: "categories_dialogues"))
                    
                    cell.lblSubTitle.text = "\(dataDict.value(forKey: "num_of_post") as? String ?? "") posts"
                    
                }
                
                CEll = cell
                
            }
            else{
                
                
                tblSearch.register(UINib(nibName: "SearchXibs", bundle: nil), forCellReuseIdentifier: "SearchXibs")
                
                let cell = tblSearch.dequeueReusableCell(withIdentifier: "SearchXibs", for: indexPath) as! SearchXibs
                
                
                if tagArray.count>0{
                    
                    let dataDict = tagArray[indexPath.row]
                    cell.lblTitle.text = dataDict.tag_name ?? ""
                    cell.lblSubTitle.text = "\(dataDict.num_of_post ?? "") posts"
                    let icon = dataDict.icon ?? ""
                    print(icon)
                    
                    cell.imgSearch.isHidden = true
                    cell.imgLeadingConstraints.constant = 0
                    cell.imgWidthConstarintsOutlet.constant = 0
                    
                    cell.imgSearch.sd_setImage(with: URL(string: icon as? String ?? ""), placeholderImage: UIImage(named: "categories_dialogues"))
                    
                }
                
                CEll = cell
                
                
            }
            
            
            
            
            return CEll
            
            
            
        }
            
        else if tag == 3{
            
            
            
            
            if searchActive == true {
                
                
                
                
                if tempsearchfilteredModelArray.count > 0{
                    
                    let dataDict = tempsearchfilteredModelArray[indexPath.row]
                    
                    let type = dataDict.type ?? ""
                    
                    if type == "people"{
                        
                        
                        tblSearch.register(UINib(nibName: "SearchTableViewCell", bundle: nil), forCellReuseIdentifier: "SearchTableViewCell")
                        
                        let cell = tblSearch.dequeueReusableCell(withIdentifier: "SearchTableViewCell", for: indexPath) as! SearchTableViewCell
                        
                        
                        let dataDict = tempsearchfilteredModelArray[indexPath.row]
                        
                        let image = dataDict.user_image ?? ""
                        
                        cell.imgView_user.sd_setImage(with: URL(string: image as? String ?? ""), placeholderImage: UIImage(named: "user_signup"))
                        
                        
                        cell.btnFullName.setTitle(dataDict.fullname ?? "", for: .normal)
                        
                        let matchedTopics = dataDict.topic_match ??  ""
                        if matchedTopics == "0"{
                            cell.lblUserName.isHidden = true
                        }else{
                            cell.lblUserName.isHidden = false
                            cell.lblUserName.text = "\(matchedTopics) similar interests"
                        }
                        
                        
                        if dataDict.user_id == self.user_id  {
                            
                            cell.btnOtherProfileRef.isHidden = true
                            cell.btnFullName.isUserInteractionEnabled = false
                            cell.btnFollowRef.isHidden = true
                        }
                        else{
                            cell.btnOtherProfileRef.isHidden = false
                            
                            cell.btnFullName.isUserInteractionEnabled = true
                            cell.btnFollowRef.isHidden = false
                            
                            if dataDict.follower_flag == "1"{
                                
                                cell.btnFollowRef.setTitle("Unfollow", for: .normal)
                                cell.btnFollowRef.backgroundColor = UIColor(red: 110/255, green: 196/255, blue: 124/255, alpha: 1)
                            }else{
                                
                                cell.btnFollowRef.setTitle("Follow", for: .normal)
                                cell.btnFollowRef.backgroundColor = UIColor(red: 74/255, green: 37/255, blue: 107/255, alpha: 1)
                                
                                
                            }
                            
                        }
                        
                        
                        
                        cell.btnOtherProfileRef.tag = indexPath.row
                        cell.btnOtherProfileRef.addTarget(self, action: #selector(btnOtherProfileTapped), for: .touchUpInside)
                        
                        cell.btnFullName.tag = indexPath.row
                        cell.btnFullName.addTarget(self, action: #selector(btnOtherProfileTapped), for: .touchUpInside)
                        
                        cell.btnFollowRef.tag = indexPath.row
                        
                        cell.btnFollowRef.addTarget(self, action: #selector(btnFollowUnfollowTapped), for: .touchUpInside)
                        
                        
                        CEll = cell
                        
                        
                        
                        
                        
                    }else if type == "topic"{
                        
                        tblSearch.register(UINib(nibName: "SearchXibs", bundle: nil), forCellReuseIdentifier: "SearchXibs")
                        
                        let cell = tblSearch.dequeueReusableCell(withIdentifier: "SearchXibs", for: indexPath) as! SearchXibs
                        
                        
                        let dataDict = tempsearchfilteredModelArray[indexPath.row]
                        cell.lblTitle.text = dataDict.tag_name ?? ""
                        cell.lblSubTitle.text = "\(dataDict.num_of_post ?? "") posts"
                        let icon = dataDict.icon ?? ""
                        print(icon)
                        
                        cell.imgSearch.isHidden = true
                        cell.imgLeadingConstraints.constant = 0
                        cell.imgWidthConstarintsOutlet.constant = 0
                        
                        cell.imgSearch.sd_setImage(with: URL(string: icon as? String ?? ""), placeholderImage: UIImage(named: "categories_dialogues"))
                        
                        
                        CEll = cell
                        
                        
                        
                        
                        
                    }else{
                        
                        tblSearch.register(UINib(nibName: "TagTableViewCell", bundle: nil), forCellReuseIdentifier: "TagTableViewCell")
                        
                        let cell = tblSearch.dequeueReusableCell(withIdentifier: "TagTableViewCell", for: indexPath) as! TagTableViewCell
                        
                        
                        
                        let dataDict = tempsearchfilteredModelArray[indexPath.row]
                        cell.lblTitle.text = dataDict.tag_name ?? ""
                        cell.lblSubTitle.text = "\(dataDict.num_of_post ?? "") posts"
                        
                        cell.imgSearch.image = #imageLiteral(resourceName: "hash_tag")
                        cell.imgSearch.isHidden = false
                        
                        CEll = cell
                        
                        
                    }
                    
                    
                }
                
                
                
                return CEll
                
                
                
                
            }else{
                
                
                if recentSearchModelArray.count > 0{
                    
                    let type = recentSearchModelArray[indexPath.row].type ?? ""
                    
                    
                    if type == "people"{
                        
                        
                        tblSearch.register(UINib(nibName: "SearchTableViewCell", bundle: nil), forCellReuseIdentifier: "SearchTableViewCell")
                        
                        let cell = tblSearch.dequeueReusableCell(withIdentifier: "SearchTableViewCell", for: indexPath) as! SearchTableViewCell
                        
                        
                        let dataDict = recentSearchModelArray[indexPath.row]
                        
                        let image = dataDict.user_image ?? ""
                        
                        cell.imgView_user.sd_setImage(with: URL(string: image as? String ?? ""), placeholderImage: UIImage(named: "user_signup"))
                        
                        
                        cell.btnFullName.setTitle(dataDict.fullname ?? "", for: .normal)
                        
                        
                        let matchedTopics = dataDict.topic_match ??  ""
                        if matchedTopics == "0"{
                            cell.lblUserName.isHidden = true
                        }else{
                            cell.lblUserName.isHidden = false
                            cell.lblUserName.text = "\(matchedTopics) similar interests"
                        }
                        
                        
                        if dataDict.user_id == self.user_id  {
                            
                            cell.btnOtherProfileRef.isHidden = true
                            cell.btnFullName.isUserInteractionEnabled = false
                            cell.btnFollowRef.isHidden = true
                        }
                        else{
                            cell.btnOtherProfileRef.isHidden = false
                            
                            cell.btnFullName.isUserInteractionEnabled = true
                            cell.btnFollowRef.isHidden = false
                            print(dataDict.follower_flag)
                            if dataDict.follower_flag == "1"{
                                
                                cell.btnFollowRef.setTitle("Unfollow", for: .normal)
                                cell.btnFollowRef.backgroundColor = UIColor(red: 110/255, green: 196/255, blue: 124/255, alpha: 1)
                            }else{
                                
                                cell.btnFollowRef.setTitle("Follow", for: .normal)
                                cell.btnFollowRef.backgroundColor = UIColor(red: 74/255, green: 37/255, blue: 107/255, alpha: 1)
                                
                                
                            }
                            
                        }
                        
                        
                        
                        cell.btnOtherProfileRef.tag = indexPath.row
                        cell.btnOtherProfileRef.addTarget(self, action: #selector(btnOtherProfileTapped), for: .touchUpInside)
                        
                        cell.btnFullName.tag = indexPath.row
                        cell.btnFullName.addTarget(self, action: #selector(btnOtherProfileTapped), for: .touchUpInside)
                        
                        cell.btnFollowRef.tag = indexPath.row
                        
                        cell.btnFollowRef.addTarget(self, action: #selector(btnFollowUnfollowTapped), for: .touchUpInside)
                        
                        
                        CEll = cell
                        
                        
                        
                        
                        
                    }else if type == "topic"{
                        
                        tblSearch.register(UINib(nibName: "SearchXibs", bundle: nil), forCellReuseIdentifier: "SearchXibs")
                        
                        let cell = tblSearch.dequeueReusableCell(withIdentifier: "SearchXibs", for: indexPath) as! SearchXibs
                        
                        
                        let dataDict = recentSearchModelArray[indexPath.row]
                        cell.lblTitle.text = dataDict.tag_name ?? ""
                        cell.lblSubTitle.text = "\(dataDict.num_of_post ?? "") posts"
                        let icon = dataDict.icon ?? ""
                        cell.imgSearch.isHidden = true
                        cell.imgLeadingConstraints.constant = 0
                        cell.imgWidthConstarintsOutlet.constant = 0
                        print(icon)
                        
                        cell.imgSearch.sd_setImage(with: URL(string: icon as? String ?? ""), placeholderImage: UIImage(named: "categories_dialogues"))
                        
                        
                        CEll = cell
                        
                        
                        
                        
                        
                    }else{
                        
                        tblSearch.register(UINib(nibName: "TagTableViewCell", bundle: nil), forCellReuseIdentifier: "TagTableViewCell")
                        
                        let cell = tblSearch.dequeueReusableCell(withIdentifier: "TagTableViewCell", for: indexPath) as! TagTableViewCell
                        
                        
                        
                        let dataDict = recentSearchModelArray[indexPath.row]
                        cell.lblTitle.text = dataDict.tag_name ?? ""
                        cell.lblSubTitle.text = "\(dataDict.num_of_post ?? "") posts"
                        
                        cell.imgSearch.isHidden = false
                       
                        
                        cell.imgSearch.image = #imageLiteral(resourceName: "hash_tag")
                        
                        CEll = cell
                        
                        
                    }
                    
                    
                }
                
                
                
            }
            
            
            
            
            return CEll
            
            
            
        }
        else if tag == 4{
            
            
            
            if searchActive == true {
                
                
                tblSearch.register(UINib(nibName: "TagTableViewCell", bundle: nil), forCellReuseIdentifier: "TagTableViewCell")
                
                let cell = tblSearch.dequeueReusableCell(withIdentifier: "TagTableViewCell", for: indexPath) as! TagTableViewCell
                
                
                if tempsearchfilteredArray.count>0{
                    
                    let dataDict = tempsearchfilteredArray.object(at: indexPath.row) as? NSDictionary ?? [:]
                    
                    cell.lblTitle.text = dataDict.value(forKey: "tag_name") as? String ?? ""
                    //cell.lblTitle.text = dataDict.tag_name ?? ""
                    cell.lblSubTitle.text = "\(dataDict.value(forKey: "num_of_post") as? String ?? "") posts"
                    
                    cell.imgSearch.image = #imageLiteral(resourceName: "hash_tag")
                    
                }
                
                CEll = cell
                
            }else{
                
                
                tblSearch.register(UINib(nibName: "TagTableViewCell", bundle: nil), forCellReuseIdentifier: "TagTableViewCell")
                
                let cell = tblSearch.dequeueReusableCell(withIdentifier: "TagTableViewCell", for: indexPath) as! TagTableViewCell
                
                
                if tagArray1.count>0{
                    
                    let dataDict = tagArray1[indexPath.row]
                    cell.lblTitle.text = dataDict.tag_name ?? ""
                    cell.lblSubTitle.text = "\(dataDict.num_of_post ?? "") posts"
                    
                    cell.imgSearch.image = #imageLiteral(resourceName: "hash_tag")
                    
                }
                
                CEll = cell
                
            }
            
            
            
            
            
            
            
            
            
            return CEll
            
            
        }else{
            
            tblSearch.register(UINib(nibName: "SearchTableViewCell", bundle: nil), forCellReuseIdentifier: "SearchTableViewCell")
            
            let cell = tblSearch.dequeueReusableCell(withIdentifier: "SearchTableViewCell", for: indexPath) as! SearchTableViewCell
            
            
            if peopleDataArray.count > 0{
                
                
                let dataDict = peopleDataArray[indexPath.row]
                
                let image = dataDict.user_image ?? ""
                
                cell.imgView_user.sd_setImage(with: URL(string: image as? String ?? ""), placeholderImage: UIImage(named: "user_signup"))
                
                cell.btnFullName.setTitle(dataDict.fullname ?? "", for: .normal)
                
                
                cell.lblUserName.text = "\(dataDict.topic_match ??  "") similar interests"
                
                
                
                
                
                
                if dataDict.user_id == self.user_id  {
                    
                    cell.btnOtherProfileRef.isHidden = true
                    cell.btnFullName.isUserInteractionEnabled = false
                    cell.btnFollowRef.isHidden = true
                }
                else{
                    cell.btnOtherProfileRef.isHidden = false
                    cell.btnFullName.isUserInteractionEnabled = true
                    cell.btnFollowRef.isHidden = false
                    
                    if dataDict.follower_flag == "1"{
                        
                        cell.btnFollowRef.setTitle("Unfollow", for: .normal)
                        cell.btnFollowRef.backgroundColor = UIColor(red: 110/255, green: 196/255, blue: 124/255, alpha: 1)
                    }else{
                        
                        cell.btnFollowRef.setTitle("Follow", for: .normal)
                        cell.btnFollowRef.backgroundColor = UIColor(red: 74/255, green: 37/255, blue: 107/255, alpha: 1)
                        
                        
                    }
                    
                }
                
                
                cell.btnOtherProfileRef.tag = indexPath.row
                cell.btnOtherProfileRef.addTarget(self, action: #selector(btnOtherProfileTapped), for: .touchUpInside)
                
                cell.btnFullName.tag = indexPath.row
                cell.btnFullName.addTarget(self, action: #selector(btnOtherProfileTapped), for: .touchUpInside)
                
                cell.btnFollowRef.tag = indexPath.row
                
                cell.btnFollowRef.addTarget(self, action: #selector(btnFollowUnfollowTapped), for: .touchUpInside)
                
                
                
                
            }
            
            return cell
        }
        
        
        
        
        
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        
        
        if tag == 2{
            
            if searchActive == true{
                
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "AfterSearchPostListVC") as! AfterSearchPostListVC
                
                
                vc.apiName = "genrepostbyid"
                
                
                let dataDict = tempsearchfilteredArray.object(at: indexPath.row) as? NSDictionary ?? [:]
                
                print(dataDict)
                
                print(dataDict.value(forKey: "topic_id") as? String ?? "")
                
                vc.tag_id = String(dataDict.value(forKey: "topic_id") as? String ?? "")
                print(vc.tag_id)
            
                
                let tag_id = dataDict.value(forKey: "topic_id") as? String ?? ""
                
                let tag_name = dataDict.value(forKey: "topic_name") as? String ?? ""
                
                let num_of_post = dataDict.value(forKey: "num_of_post") as? String ?? ""
                
                let icon = dataDict.value(forKey: "icon") as? String ?? ""
                
                let recentSearchItem = RecentSearchModel()
                recentSearchItem.type = "topic"
                recentSearchItem.search_name = tag_name
                recentSearchItem.follower_flag = ""
                recentSearchItem.fullname = ""
                recentSearchItem.number_of_post = ""
                recentSearchItem.topic_match = ""
                recentSearchItem.user_id = ""
                recentSearchItem.user_image = ""
                recentSearchItem.user_name = ""
                recentSearchItem.tag_id = tag_id
                recentSearchItem.num_of_post = num_of_post
                recentSearchItem.tag_name = tag_name
                recentSearchItem.icon = icon
                recentSearchItem.created = Date()
                let search_name = recentSearchItem.search_name
                print(search_name)
                self.saveToRealm(recentSearchItem,search_name)
                self.recentArray.add(search_name)
                self.navigationController?.pushViewController(vc, animated: true)
            }else{
            
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "AfterSearchPostListVC") as! AfterSearchPostListVC
            
            
            vc.apiName = "genrepostbyid"
            
            vc.tag_id = tagArray[indexPath.row].tag_id ?? ""
                print(vc.tag_id)
            
            let tag_id = tagArray[indexPath.row].tag_id ?? ""
            
            let tag_name = tagArray[indexPath.row].tag_name ?? ""
            
            let num_of_post = tagArray[indexPath.row].num_of_post ?? ""
            
            let icon = tagArray[indexPath.row].icon ?? ""
                let recentSearchItem = RecentSearchModel()
                recentSearchItem.type = "topic"
                recentSearchItem.search_name = tag_name
                recentSearchItem.follower_flag = ""
                recentSearchItem.fullname = ""
                recentSearchItem.number_of_post = ""
                recentSearchItem.topic_match = ""
                recentSearchItem.user_id = ""
                recentSearchItem.user_image = ""
                recentSearchItem.user_name = ""
                recentSearchItem.tag_id = tag_id
                recentSearchItem.num_of_post = num_of_post
                recentSearchItem.tag_name = tag_name
                recentSearchItem.icon = icon
                recentSearchItem.created = Date()
                let search_name = recentSearchItem.search_name ?? ""
                print(search_name)
                self.saveToRealm(recentSearchItem,search_name)
                self.recentArray.add(search_name)
            self.navigationController?.pushViewController(vc, animated: true)
        }
        }else if tag == 3{
            
            if searchActive == true{
                
                if tempsearchfilteredModelArray.count > 0{
                    
                    let type = tempsearchfilteredModelArray[indexPath.row].type ?? ""
                    
                    
                    if type == "people"{
                        
                        print("Do nothing")
                        
                    }else if type == "topic"{
                        
                        
                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "AfterSearchPostListVC") as! AfterSearchPostListVC
                        
                        
                        vc.apiName = "genrepostbyid"
                        
                        vc.tag_id = tempsearchfilteredModelArray[indexPath.row].tag_id ?? ""
                        
                        print(vc.tag_id)
                        
                        
                        self.navigationController?.pushViewController(vc, animated: true)
                        
                    }else{
                        
                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "AfterSearchPostListVC") as! AfterSearchPostListVC
                        
                        
                        vc.apiName = "tagpostbyid"
                        
                        vc.tag_id = tempsearchfilteredModelArray[indexPath.row].tag_id ?? ""
                        
                        
                        
                        
                        self.navigationController?.pushViewController(vc, animated: true)
                        
                        
                        
                    }
                    
                    
                    
                    
                }
                
                
            }else{
            
                if (recentSearchModelArray?.count)! > 0{
                
                    let type = recentSearchModelArray![indexPath.row].type ?? ""
                
                
                if type == "people"{
                    
                    print("Do nothing")
                    
                }else if type == "topic"{
                    
                    
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "AfterSearchPostListVC") as! AfterSearchPostListVC
                    
                    
                    vc.apiName = "genrepostbyid"
                    
                    vc.tag_id = recentSearchModelArray![indexPath.row].tag_id ?? ""
                    print(vc.tag_id)
                    
                    
                    
                    self.navigationController?.pushViewController(vc, animated: true)
                    
                }else{
                    
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "AfterSearchPostListVC") as! AfterSearchPostListVC
                    
                    
                    vc.apiName = "tagpostbyid"
                    
                    vc.tag_id = recentSearchModelArray![indexPath.row].tag_id ?? ""
                    
                    print(vc.tag_id)
                    
                    
                    self.navigationController?.pushViewController(vc, animated: true)
                    
                    
                    
                }
                
                
                
                
            }
            
            
        }
            
            
        }else if tag == 4{
            
            if searchActive == true{
                
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "AfterSearchPostListVC") as! AfterSearchPostListVC
                
                vc.apiName = "tagpostbyid"
                
                
                let dataDict = tempsearchfilteredArray.object(at: indexPath.row) as? NSDictionary ?? [:]
                
                
                
                vc.tag_id = dataDict.value(forKey: "tag_id") as? String ?? ""
                print(vc.tag_id)
                
                let tag_id = dataDict.value(forKey: "tag_id") as? String ?? ""
                
                let tag_name = dataDict.value(forKey: "tag_name") as? String ?? ""
                
                let num_of_post = dataDict.value(forKey: "num_of_post") as? String ?? ""
                
                let icon = dataDict.value(forKey: "icon") as? String ?? ""
                let recentSearchItem = RecentSearchModel()
                recentSearchItem.type = "tag"
                recentSearchItem.search_name = tag_name
                recentSearchItem.follower_flag = ""
                recentSearchItem.fullname = ""
                recentSearchItem.number_of_post = ""
                recentSearchItem.topic_match = ""
                recentSearchItem.user_id = ""
                recentSearchItem.user_image = ""
                recentSearchItem.user_name = ""
                recentSearchItem.tag_id = tag_id
                recentSearchItem.num_of_post = num_of_post
                recentSearchItem.tag_name = tag_name
                recentSearchItem.icon = icon
                recentSearchItem.created = Date()
                let search_name = recentSearchItem.search_name
                print(search_name)
                self.saveToRealm(recentSearchItem,search_name)
                self.recentArray.add(search_name)
                self.navigationController?.pushViewController(vc, animated: true)
                
                

            }else{
                
                
                
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "AfterSearchPostListVC") as! AfterSearchPostListVC
                
                vc.apiName = "tagpostbyid"
                
                vc.tag_id = tagArray1[indexPath.row].tag_id ?? ""
                print(vc.tag_id)
                
                
                let tag_id = tagArray1[indexPath.row].tag_id ?? ""
                
                let tag_name = tagArray1[indexPath.row].tag_name ?? ""
                
                let num_of_post = tagArray1[indexPath.row].num_of_post ?? ""
                
                let icon = tagArray1[indexPath.row].icon ?? ""
                let recentSearchItem = RecentSearchModel()
                recentSearchItem.type = "tag"
                recentSearchItem.search_name = tag_name
                recentSearchItem.follower_flag = ""
                recentSearchItem.fullname = ""
                recentSearchItem.number_of_post = ""
                recentSearchItem.topic_match = ""
                recentSearchItem.user_id = ""
                recentSearchItem.user_image = ""
                recentSearchItem.user_name = ""
                recentSearchItem.tag_id = tag_id
                recentSearchItem.num_of_post = num_of_post
                recentSearchItem.tag_name = tag_name
                recentSearchItem.icon = icon
                recentSearchItem.created = Date()
                let search_name = recentSearchItem.search_name ?? ""
                print(search_name)
                self.saveToRealm(recentSearchItem,search_name)
                self.recentArray.add(search_name)
                self.navigationController?.pushViewController(vc, animated: true)
                
                
        
        }
        }else{
            
            print("Do nothong.....")
        }
    }
    
    
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableViewAutomaticDimension
        
    }
    
}
extension Realm {
    public func safeWrite(_ block: (() throws -> Void)) throws {
        if isInWriteTransaction {
            try block()
        } else {
            try write(block)
        }
    }
}
