//
//  CommentsWithPostVC.swift
//  Escalate
//
//  Created by abc on 12/09/18.
//  Copyright © 2018 call soft. All rights reserved.
//

import UIKit
import AVFoundation
import Pulsator
import SDWebImage
import SwiftSiriWaveformView

class CommentsWithPostVC:  UIViewController,AVAudioRecorderDelegate, AVAudioPlayerDelegate,UIScrollViewDelegate {
    
    
    
    //MARK:- OUTLETS
    //MARK:
    
    @IBOutlet weak var audioView: SwiftSiriWaveformView!
    
    
    @IBOutlet weak var btnPlayRef: UIButton!
    
    @IBOutlet weak var imgView_user_image: UIImageView!
    
    @IBOutlet weak var lbl_fullname: UILabel!
    
    @IBOutlet var tblViewProfile: UITableView!
    
    @IBOutlet weak var sourceView: UIView!
    
    @IBOutlet weak var lbl_tag_list: UILabel!
    
    @IBOutlet weak var record_btn_ref: UIButton!
    
    
    @IBOutlet weak var lbl_description_post: UILabel!
    
    
    @IBOutlet weak var lbl_duration: UILabel!

    
    
    //MARK:- VARIABLES
    //MARK
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var durationForApi = ""
    
    var dataDict = NSDictionary()
    
    var audioRecorder: AVAudioRecorder!
    var audioPlayer : AVAudioPlayer!
    var meterTimer:Timer!
    var isAudioRecordingGranted: Bool!
    var isRecording = false
    
    let pulsator = Pulsator()
    
    
    var contoller =  UIViewController()
    
    let WebserviceConnection  = AlmofireWrapper()
    
    var postDataArray = NSArray()
    
    var audioID = ""
    
    
    var isPlaying = false
    
    var isPlaying1 = false
    
    var audioUrl: URL!
    
    var timerCP:Timer?
    
    
    
    var timerCPA:Timer?
    
    var timerCountCPA:Timer?
    
    
    
    var change:CGFloat = 0.01
    
    var timerCountCP:Timer?
    var count = 0
    var hr = 0
    var min = 0
    var sec = 0
    
    var hr1 = 0
    var min1 = 0
    var sec1 = 0
    
    
    var player:AVPlayer?
    var playerItem:AVPlayerItem?
    
    var player1:AVPlayer?
    var playerItem1:AVPlayerItem?
    
    var user_image = ""
    var fullname = ""
    var tag_list = ""
    var audio_url = ""
    var duration = ""
    var descriptionPost = ""
    var isComing = String()
    
    
    
    //******Variables for 40 timer
    
    var countLimit = 39
    
    var timerLimit:Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initialSetUp()
        
        // Do any additional setup after loading the view.
    }
    
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    override func viewWillAppear(_ animated: Bool) {
        userPostList()
    }
    
    
    //MARK:- METHODS
    //MARK:
    
    func initialSetUp(){
        
        NotificationCenter.default.addObserver(self, selector: #selector(CommentsWithPostVC.resetUI(_:)), name: NSNotification.Name(rawValue: "resetUIBTN"), object: nil)
        
        imgView_user_image.sd_setImage(with: URL(string: user_image as? String ?? ""), placeholderImage: UIImage(named: "user_signup"))
        
        lbl_fullname.text = fullname as? String ?? ""
        
        lbl_tag_list.text = tag_list as? String ?? ""
        
        lbl_description_post.text = descriptionPost as? String ?? ""
        
       lbl_duration.text = duration as? String ?? ""
        
        
    
        
        
      
        
        NotificationCenter.default.addObserver(self, selector: #selector(CommentsWithPostVC.stopRecordingAndPlaying(_:)), name: NSNotification.Name(rawValue: "stopRecordingAndPlaying"), object: nil)
        
        
        check_record_permission()
        userPostList()
        
    }
    @objc func resetUI(_ notification: Notification) {
        
        
        record_btn_ref.setTitle(" Reply", for: .normal)
        
    }
    
    
    func stopPlayingMusic(){
        
        
        
        
        if(isPlaying1)
        {
            
            player1!.pause()
            
            timerCountCPA?.invalidate()
            timerCountCPA = nil
            timerCPA?.invalidate()
            timerCPA = nil
            sec1 = 0
            hr1 = 0
            min1 = 0
            
            btnPlayRef.setImage(UIImage(named: "home_play_a"),for: .normal)
            isPlaying1 = false
            audioView.amplitude = 0.0
            
            let totalTimeString = duration
            lbl_duration.text = totalTimeString
            
        }
        
    }
    
    
    func setTimerLabel(){
        
        let asset = AVAsset(url: audioUrl)
        
        let duration = asset.duration
        let durationTime = Int(ceil(CMTimeGetSeconds(duration)))
        
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
        
        
        lbl_duration.text = durationForApi
        
    }
    
    
    
    
    func stopRecordings(){
        if(isRecording)
        {
            
            let sec = 0
            let hr = 0
            let min = 0
            
            
            timerLimit?.invalidate()
            timerLimit = nil
            countLimit = 39
            //lblInstructions.text = "tap to record"
            
            let totalTimeString = String(format: "%02d:%02d:%02d", hr, min, sec)
            
            pulsator.stop()
            finishAudioRecording(success: true)
            isRecording = false
            
            
            
            
            
//            let vc = self.storyboard?.instantiateViewController(withIdentifier: "CommentVC") as! CommentVC
//
//            vc.audioUrl = getFileUrl()
//            vc.audioID = self.audioID
//
//            self.navigationController?.present(vc, animated: true, completion: nil)
        }
    }
    
    
    
    
    
    func stopTableAudio(){
        
        
        
        
        
        
        if(isPlaying)
        {
            let btnTag = UserDefaults.standard.value(forKey: "CPBTNTAG") as? Int ?? 0
            
            let dataDict = postDataArray[btnTag] as? NSDictionary ?? [:]
            
            let indexPath = IndexPath(row: btnTag, section: 0)
            
            guard let cell = tblViewProfile.cellForRow(at: indexPath) as? RepliesTableViewCell else {
                
                return
            }
            
            
            
            player!.pause()
            
            timerCountCP?.invalidate()
            timerCountCP = nil
            timerCP?.invalidate()
            timerCP = nil
            sec = 0
            hr = 0
            min = 0
            
            cell.btnPlayPausedRef.setImage(#imageLiteral(resourceName: "home_play_a"), for: .normal)
            
            isPlaying = false
            cell.audioView.amplitude = 0.0
            
            let totalTimeString = dataDict.value(forKey: "msg_duration") as? String ?? ""
            cell.lblTotalTimer.text = totalTimeString
        }
        
    }
    
    
    
    
    
    func addHalo() {
        
        pulsator.position = .init(x: 100, y: 37.5)
        pulsator.numPulse = 5
        pulsator.radius = 45
        
        pulsator.animationDuration = 3
        pulsator.backgroundColor = UIColor.white.cgColor
        sourceView.layer.addSublayer(pulsator)
        pulsator.start()
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
    
//    func stopRecordings(){
//
//        if(isRecording)
//        {
//
//            let sec = 0
//            let hr = 0
//            let min = 0
//
//            //lblInstructions.text = "tap to record"
//
//            let totalTimeString = String(format: "%02d:%02d:%02d", hr, min, sec)
//
//            pulsator.stop()
//
//            finishAudioRecording(success: true)
//            isRecording = false
//
//        }
//
//    }
    
    
    
    
    func userPostList(){
        
        let infoArray = UserDefaults.standard.value(forKey: "USERINFO") as? NSArray ?? []
        //print(infoArray)
        let infoDict = infoArray.object(at: 0) as? NSDictionary ?? [:]
        
        //print(infoDict)
        
        let user_id = infoDict.value(forKey: "user_id") as? String ?? ""
        
        //print(user_id)
        
        
        if InternetConnection.internetshared.isConnectedToNetwork() {
            
            //Indicator.shared.showProgressView(self.view)
            
            print(self.audioID)
            
            WebserviceConnection.requestGETURL("commentlist/\(self.audioID)", success: { (responseJson) in
                
                if responseJson["status"].stringValue == "SUCCESS" {
                    
                    Indicator.shared.hideProgressView()
                    
                    print(responseJson)
                    
                    self.postDataArray = responseJson["data"].arrayObject as? NSArray ?? []
                    
                    self.tblViewProfile.dataSource = self
                    self.tblViewProfile.delegate = self
                    
                    self.tblViewProfile.reloadData()
                    
                    
                    
                    
                    
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
    
    
    
    
    
    func playPost(){
        
      let audioUrl1 = NSURL(string: audio_url as? String ?? "") as! URL
        
        if audio_url != ""{
            
            if(isPlaying1)
            {
                
                player1!.pause()
                
                timerCountCPA?.invalidate()
                timerCountCPA = nil
                timerCPA?.invalidate()
                timerCPA = nil
                sec1 = 0
                hr1 = 0
                min1 = 0
                
                btnPlayRef.setImage(UIImage(named: "home_play_a"),for: .normal)
                isPlaying1 = false
                audioView.amplitude = 0.0
                
                let totalTimeString = duration
                lbl_duration.text = totalTimeString
            }
            else
            {
                if audioUrl1 != nil
                {
                    let playerItem:AVPlayerItem = AVPlayerItem(url: audioUrl1)
                    player1 = AVPlayer(playerItem: playerItem)
                    
                    
                    let asset = AVAsset(url: audioUrl1)
                    
                    let duration = asset.duration
                    let durationTime = CMTimeGetSeconds(duration)
                    count = Int(ceil(durationTime))
                    
                    countDownTimet1()
                    timerCPA = Timer.scheduledTimer(timeInterval: 0.009, target: self, selector: #selector(self.refreshAudioView1(_:)), userInfo: nil, repeats: true)
                    
                    btnPlayRef.setImage(UIImage(named: "home_pause_a"),for: .normal)
                    player1!.play()
                    
                    
                    isPlaying1 = true
                }
                else
                {
                    
                    
                    _ = SweetAlert().showAlert("Escalate", subTitle: "Audio file is missing.", style: AlertStyle.error)
                    //display_alert(msg_title: "Error", msg_desc: "Audio file is missing.", action_title: "OK")
                }
            }
            
            
        }else{
            _ = SweetAlert().showAlert("Escalate", subTitle: "Audio file is missing.", style: AlertStyle.error)
        }
        
        
    }
    
    //COUNTER FOR WAVE AND AUDIO TIME
    
    func countDownTimet1(){
        
        timerCountCPA = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.update1), userInfo: nil, repeats: true)
    }
    
    
    @objc func update1() {
        if(count > 0) {
            
            sec1 += 1
            
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
            
            count = count - 1
            print(count)
            
            let totalTimeString = String(format: "%02d:%02d", min1, count)
            lbl_duration.text = totalTimeString
            
        }
        else{
            print("TIMERCOUNT")
            print(count)
            sec1 = 0
            hr1 = 0
            min1 = 0
            
            timerCPA?.invalidate()
            timerCPA = nil
            timerCountCPA?.invalidate()
            timerCountCPA = nil
            
            let totalTimeString = duration
            lbl_duration.text = totalTimeString
            
            btnPlayRef.setImage(UIImage(named: "home_play_a"),for: .normal)
            
            audioView.amplitude = 0.0
            isPlaying1 = false
            //STOP PLAYING AND ANIMATION
            
            
        }
    }
    
    
    
    
    
    
    
    
    //COUNTER FOR WAVE AND AUDIO TIME
    
    func countDownTimet(){
        
        timerCountCP = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.update), userInfo: nil, repeats: true)
        
    }
    
    
    @objc internal func refreshAudioView1(_:Timer) {
        if self.audioView.amplitude <= self.audioView.idleAmplitude || self.audioView.amplitude > 1.0 {
            self.change *= -1.0
        }
        
        
        // Simply set the amplitude to whatever you need and the view will update itself.
        self.audioView.amplitude += self.change
    }
    
    
    
    @objc internal func refreshAudioView(_:Timer) {
        
        let btnTag = UserDefaults.standard.value(forKey: "CPBTNTAG") as? Int ?? 0
        
        
        let indexPath = IndexPath(row: btnTag, section: 0)
        
        
        guard let cell = tblViewProfile.cellForRow(at: indexPath) as? RepliesTableViewCell else {
            
            return
        }
        
        //let cell = tblViewHome.cellForRow(at: indexPath) as! HomeTableViewCell
        
        if cell.audioView.amplitude <= cell.audioView.idleAmplitude || cell.audioView.amplitude > 1.0 {
            self.change *= -1.0
        }
        
        
        // Simply set the amplitude to whatever you need and the view will update itself.
        cell.audioView.amplitude += self.change
        
        
        
        
    }
    
    
    @objc func update() {
        
        
        let btnTag = UserDefaults.standard.value(forKey: "CPBTNTAG") as? Int ?? 0
        
        let indexPath = IndexPath(row: btnTag, section: 0)
        
        
         let dataDict = postDataArray[btnTag] as? NSDictionary ?? [:]
        
        // let cell = tblViewHome.cellForRow(at: indexPath) as! HomeTableViewCell
        
        guard let cell = tblViewProfile.cellForRow(at: indexPath) as? RepliesTableViewCell else {
            
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
            
            timerCP?.invalidate()
            timerCP = nil
            
            
            let totalTimeString = dataDict.value(forKey: "msg_duration") as? String ?? ""
            cell.lblTotalTimer.text = totalTimeString
            
            cell.btnPlayPausedRef.setImage(UIImage(named: "home_play_a"),for: .normal)
            
            cell.audioView.amplitude = 0.0
            isPlaying = false
            //STOP PLAYING AND ANIMATION
            
            
        }
    }
    
    
    
    
    
    //MARK:- ACTIONS
    //MARK:
    
    @IBAction func play_recording(_ sender: Any)
    {
        
        if isRecording == true{
            
            
            
            let sec = 0
            let hr = 0
            let min = 0
            
            timerLimit?.invalidate()
            timerLimit = nil
            countLimit = 39
            //lblInstructions.text = "tap to record"
            
            let totalTimeString = String(format: "%02d:%02d", min, sec)
            
            pulsator.stop()
            finishAudioRecording(success: true)
            isRecording = false
            
            
            
            
            
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "CommentVC") as! CommentVC
            
            vc.audioUrl = getFileUrl()
            vc.audioID = self.audioID
            
            self.navigationController?.present(vc, animated: true, completion: nil)
            
            
        }else{
        
        
        
        stopTableAudio()
        
        
        playPost()
        
        
        
    }
        
        
    }
    
    
    
    
    
    
    
    @objc func stopRecordingAndPlaying(_ notification: Notification) {
        
        stopRecordings()
        stopPlayingMusic()
        stopTableAudio()
        
        
    }
    
    @objc func btnPlayPausedTapped(sender: UIButton){
        
        
        stopPlayingMusic()
        
        if isRecording == true{
            
            
            
            let sec = 0
            let hr = 0
            let min = 0
            
            
            timerLimit?.invalidate()
            timerLimit = nil
            countLimit = 39
            
            //lblInstructions.text = "tap to record"
            
            let totalTimeString = String(format: "%02d:%02d", min, sec)
            
            pulsator.stop()
            finishAudioRecording(success: true)
            isRecording = false

            
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "CommentVC") as! CommentVC
            
            vc.audioUrl = getFileUrl()
            vc.audioID = self.audioID
            
            self.navigationController?.present(vc, animated: true, completion: nil)
            
            
        }else{
            
            
            
            UserDefaults.standard.set(sender.tag, forKey: "CPBTNTAG")
            
            timerCountCP?.invalidate()
            timerCountCP = nil
            timerCP?.invalidate()
            timerCP = nil
            
            let prevTag = UserDefaults.standard.value(forKey: "CPPBTNTAG") as? Int ?? 0
            print(prevTag)
            let btnTag = UserDefaults.standard.value(forKey: "CPBTNTAG") as? Int ?? 0
            
            print(btnTag)
            
            if btnTag != prevTag{
                
                
                if(isPlaying)
                {
                    
                    
                    let prevIndexPath = IndexPath(row: prevTag, section: 0)
                    guard let prevCell = tblViewProfile.cellForRow(at: prevIndexPath) as? RepliesTableViewCell else {
                        
                        return
                    }
                    
                     let dataDict = postDataArray[prevTag] as? NSDictionary ?? [:]
                    
                    //player!.pause()
                    
                    timerCountCP?.invalidate()
                    timerCountCP = nil
                    timerCP?.invalidate()
                    timerCP = nil
                    sec = 0
                    hr = 0
                    min = 0
                    
                    
                    
                    prevCell.btnPlayPausedRef.setImage(#imageLiteral(resourceName: "home_play_a"), for: .normal)
                    prevCell.audioView.amplitude = 0.0
                    
        
                    prevCell.lblTotalTimer.text = dataDict.value(forKey: "msg_duration") as? String ?? ""
                    
                    isPlaying = false
                    
                    
                    
                }else{
                    
                }
                
                
                
            }
            
            
            
            
            
            
            let indexPath = IndexPath(row: btnTag, section: 0)
            let cell = tblViewProfile.cellForRow(at: indexPath) as! RepliesTableViewCell
            
            
            
            
            let dataDict = postDataArray[btnTag] as? NSDictionary ?? [:]
            
            
            
            audioUrl = NSURL(string: dataDict["message"] as? String ?? "")! as URL
            
            
            
            print(audioUrl)
            
            
            if(isPlaying)
            {
                
                player!.pause()
                
                timerCountCP?.invalidate()
                timerCountCP = nil
                timerCP?.invalidate()
                timerCP = nil
                sec = 0
                hr = 0
                min = 0
                
                cell.btnPlayPausedRef.setImage(#imageLiteral(resourceName: "home_play_a"), for: .normal)
                
                isPlaying = false
                cell.audioView.amplitude = 0.0
                
                let totalTimeString = dataDict.value(forKey: "msg_duration") as? String ?? ""
                cell.lblTotalTimer.text = totalTimeString
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
                    
                    
                    
                    
                    
                    timerCP = Timer.scheduledTimer(timeInterval: 0.009, target: self, selector: #selector(self.refreshAudioView(_:)), userInfo: nil, repeats: true)
                    
                    cell.btnPlayPausedRef.setImage(UIImage(named: "home_pause_a"),for: .normal)
                    player!.play()
                    
                    
                    isPlaying = true
                }
                else
                {
                    
                    
                    _ = SweetAlert().showAlert("Escalate", subTitle: "Audio file is missing.", style: AlertStyle.error)
                    
                }
            }
            
            
            let prevBtnTag = UserDefaults.standard.value(forKey: "CPBTNTAG") as? Int ?? 0
            
            print(prevBtnTag)
            
            UserDefaults.standard.set(prevBtnTag, forKey: "CPPBTNTAG")
            
            
            
            
        }
        
        
        
    }
    
    
    @IBAction func btnBackTapped(_ sender: Any) {
        
        stopRecordings()
        stopTableAudio()
        stopPlayingMusic()
        
            
                if isComing == "NOTI"{
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "TabBarVC") as! TabBarVC
                    let navController = UINavigationController(rootViewController: vc)
                    navController.navigationBar.isHidden = true
                    self.appDelegate.window?.rootViewController = navController
                    self.appDelegate.window?.makeKeyAndVisible()
                }else{
                    self.navigationController?.popViewController(animated: true)
                }
        
        
    }
    
    
    @IBAction func btnReplyTapped(_ sender: Any) {
        
        
        
        if(isPlaying)
        {
            let btnTag = UserDefaults.standard.value(forKey: "CPBTNTAG") as? Int ?? 0
            
            
            
            let indexPath = IndexPath(row: btnTag, section: 0)
            
            guard let cell = tblViewProfile.cellForRow(at: indexPath) as? RepliesTableViewCell else {
                
                return
            }
            
            
            stopTableAudio()
        }
        
        
        stopPlayingMusic()
        
        

        
        
        
        if(isRecording)
        {
            
            let sec = 0
            let hr = 0
            let min = 0
            
            
            timerLimit?.invalidate()
            timerLimit = nil
            countLimit = 39
            //lblInstructions.text = "tap to record"
            
            let totalTimeString = String(format: "%02d:%02d:%02d", hr, min, sec)
            
            pulsator.stop()
            finishAudioRecording(success: true)
            isRecording = false
            
            
            
            
            
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "CommentVC") as! CommentVC
            
            vc.audioUrl = getFileUrl()
            vc.audioID = self.audioID
            
            self.navigationController?.present(vc, animated: true, completion: nil)
        }
        else
        {
            meterTimer = Timer.scheduledTimer(timeInterval: 0.1, target:self, selector:#selector(self.updateAudioMeter(timer:)), userInfo:nil, repeats:true)
            addHalo()
            
            countDownTimet2()
            
            setup_recorder()
            
            //lblInstructions.text = "tap to stop"
            
            audioRecorder.record()
            
            isRecording = true
            
            
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
            
            _ = SweetAlert().showAlert("Escalate", subTitle: "Recording limit(40 sec) reached!", style: AlertStyle.warning)
            
    
            pulsator.stop()
            finishAudioRecording(success: true)
            isRecording = false
            
            
            
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "CommentVC") as! CommentVC
            
            vc.audioUrl = getFileUrl()
            
            vc.audioID = self.audioID
            
            self.navigationController?.present(vc, animated: true, completion: nil)
            
            
        }
    }
    
    
    
    
    
    
    
    
    
    @objc func updateAudioMeter(timer: Timer)
    {
        if audioRecorder.isRecording
        {
            let hr = Int((audioRecorder.currentTime / 60) / 60)
            let min = Int(audioRecorder.currentTime / 60)
            let sec = Int(audioRecorder.currentTime.truncatingRemainder(dividingBy: 60))
            let totalTimeString = String(format: "%02d:%02d", min, sec)
            record_btn_ref.setTitle(totalTimeString, for: .normal)
            audioRecorder.updateMeters()
        }
    }
    
    
    
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
    
    
    
}



//MARK:- EXTENTION TABLE VIEW
//MARK:-

extension CommentsWithPostVC:UITableViewDelegate,UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return postDataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        tblViewProfile.register(UINib(nibName: "RepliesTableViewCell", bundle: nil), forCellReuseIdentifier: "RepliesTableViewCell")
        
        let cell = tblViewProfile.dequeueReusableCell(withIdentifier: "RepliesTableViewCell", for: indexPath) as! RepliesTableViewCell
        
        if postDataArray.count > 0{
            
           
            
            dataDict = postDataArray.object(at: indexPath.row) as? NSDictionary ?? [:]
            
            let image = dataDict.value(forKey: "user_image") as? String ?? ""
            
            cell.imgView_user.sd_setImage(with: URL(string: image as? String ?? ""), placeholderImage: UIImage(named: "user_signup"))
            
            cell.lblFullName.text = dataDict.value(forKey: "fullname") as? String ?? ""
            
            cell.lblDescription.text = dataDict.value(forKey: "description") as? String ?? ""
            
            
            cell.lblUserName.text = "@\(dataDict.value(forKey: "username") as? String ?? "")"
            
            
          
            
            cell.lblTotalTimer.text = dataDict.value(forKey: "msg_duration") as? String ?? ""
            
          
            cell.btnPlayPausedRef.tag = indexPath.row
            cell.btnPlayPausedRef.addTarget(self, action: #selector(btnPlayPausedTapped), for: .touchUpInside)
            
            
            
            
            
        }
        
        return cell
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        stopPlayingMusic()
        stopTableAudio()
      
        
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableViewAutomaticDimension
        
    }
    
}


