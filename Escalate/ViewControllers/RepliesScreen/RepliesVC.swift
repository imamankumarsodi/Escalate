//
//  RepliesVC.swift
//  Escalate
//
//  Created by call soft on 19/07/18.
//  Copyright © 2018 call soft. All rights reserved.
//

import UIKit
import AVFoundation
import Pulsator


class RepliesVC: UIViewController,AVAudioRecorderDelegate, AVAudioPlayerDelegate,UIScrollViewDelegate {
    
    
    
    //MARK:- OUTLETS
    //MARK:
    
    
    @IBOutlet var tblViewProfile: UITableView!
    
    @IBOutlet weak var sourceView: UIView!
    
    
    @IBOutlet weak var record_btn_ref: UIButton!
    
    
    //MARK:- VARIABLES
    //MARK
    
    
    
    
    
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
    
    var audioUrl: URL!
    
    var timer4:Timer?
    
    var change:CGFloat = 0.01
    
    var timerCount4:Timer?
    var count = 0
    var hr = 0
    var min = 0
    var sec = 0
    
    
    var player:AVPlayer?
    var playerItem:AVPlayerItem?
    
    
    
    //******Variables for 40 timer
    
    var countLimit = 40
    
    var timerLimit:Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initialSetUp()
        
        // Do any additional setup after loading the view.
    }
    
//    override var prefersStatusBarHidden: Bool {
//        return true
//    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        userPostList()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    //MARK:- METHODS
    //MARK:
    
    func initialSetUp(){
        
        
        
        
          NotificationCenter.default.addObserver(self, selector: #selector(RepliesVC.stopRecordingAndPlaying(_:)), name: NSNotification.Name(rawValue: "stopRecordingAndPlaying"), object: nil)
        
        userPostList()
        check_record_permission()
       
    }
    
    
    
    
    
    
    
    
    func stopTableAudio(){
        
        
        
        print("TIMERCOUNT")
        print(count)
        timerLimit?.invalidate()
        timerLimit = nil
        
        
        if(isPlaying)
        {
            let btnTag = UserDefaults.standard.value(forKey: "BTNTAG") as? Int ?? 0
            
            
            
            let indexPath = IndexPath(row: btnTag, section: 0)
            
            guard let cell = tblViewProfile.cellForRow(at: indexPath) as? RepliesTableViewCell else {
                
                return
            }
            
            
            
            player!.pause()
            
            timerCount4?.invalidate()
            timerCount4 = nil
            timer4?.invalidate()
            timer4 = nil
            sec = 0
            hr = 0
            min = 0
            
            cell.btnPlayPausedRef.setImage(#imageLiteral(resourceName: "home_play_a"), for: .normal)
            
            isPlaying = false
            cell.audioView.amplitude = 0.0
            
            let totalTimeString = String(format: "%02d:%02d:%02d", hr, min, sec )
            cell.lblTotalTimer.text = totalTimeString
        }
        
    }
    
    
    
    
    
    func addHalo() {
        
        pulsator.position = .init(x: 65, y: 37.5)
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
    
    func stopRecordings(){
        
        
        
        
        
        
        
        if(isRecording)
        {
            
            let sec = 0
            let hr = 0
            let min = 0
            
            
            print("TIMERCOUNT")
            print(count)
            timerLimit?.invalidate()
            timerLimit = nil
            countLimit = 40
            
            //lblInstructions.text = "tap to record"
            
            let totalTimeString = String(format: "%02d:%02d:%02d", hr, min, sec)
        
            pulsator.stop()
            
            finishAudioRecording(success: true)
            isRecording = false
            
        }
        
    }
    
    
    
    
    func userPostList(){
        
        let infoArray = UserDefaults.standard.value(forKey: "USERINFO") as? NSArray ?? []
        //print(infoArray)
        let infoDict = infoArray.object(at: 0) as? NSDictionary ?? [:]
        
        //print(infoDict)
        
        let user_id = infoDict.value(forKey: "user_id") as? String ?? ""
        
        //print(user_id)
        
        
        if InternetConnection.internetshared.isConnectedToNetwork() {
            
            //Indicator.shared.showProgressView(self.view)
            
            
            
            WebserviceConnection.requestGETURL("commentlist/\(audioID)", success: { (responseJson) in
                
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
    
    //COUNTER FOR WAVE AND AUDIO TIME
    
    func countDownTimet(){
        
        timerCount4 = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.update), userInfo: nil, repeats: true)
        
    }
    
    @objc internal func refreshAudioView(_:Timer) {
        
        let btnTag = UserDefaults.standard.value(forKey: "BTNTAG") as? Int ?? 0
        
        
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
        
        
        let btnTag = UserDefaults.standard.value(forKey: "BTNTAG") as? Int ?? 0
        
        let indexPath = IndexPath(row: btnTag, section: 0)
        
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
            
            let totalTimeString = String(format: "%02d:%02d:%02d", hr, min, sec)
            cell.lblTotalTimer.text = totalTimeString
            
        }
        else{
            print("TIMERCOUNT")
            print(count)
            sec = 0
            hr = 0
            min = 0
            
            timer4?.invalidate()
            timer4 = nil
            
           
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
    
    
    @objc func stopRecordingAndPlaying(_ notification: Notification) {
        
        stopRecordings()
        stopTableAudio()
        
        
    }
    
    @objc func btnPlayPausedTapped(sender: UIButton){
        
        
        if isRecording == true{
            
            
            
            let sec = 0
            let hr = 0
            let min = 0
            
            
            print("TIMERCOUNT")
            print(count)
            timerLimit?.invalidate()
            timerLimit = nil
            countLimit = 40
            
            //lblInstructions.text = "tap to record"
            
            let totalTimeString = String(format: "%02d:%02d:%02d", hr, min, sec)
            
            pulsator.stop()
            finishAudioRecording(success: true)
            isRecording = false
            
            
            
            
            
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "CommentVC") as! CommentVC
            
            vc.audioUrl = getFileUrl()
            vc.audioID = self.audioID
            
            self.navigationController?.present(vc, animated: true, completion: nil)
            
            
        }else{
            
            
            
            UserDefaults.standard.set(sender.tag, forKey: "BTNTAG")
            
            timerCount4?.invalidate()
            timerCount4 = nil
            timer4?.invalidate()
            timer4 = nil
            
            let prevTag = UserDefaults.standard.value(forKey: "PBTNTAG") as? Int ?? 0
            print(prevTag)
            let btnTag = UserDefaults.standard.value(forKey: "BTNTAG") as? Int ?? 0
            
            print(btnTag)
            
            if btnTag != prevTag{
                
                
                if(isPlaying)
                {
                    
                    
                    let prevIndexPath = IndexPath(row: prevTag, section: 0)
                    guard let prevCell = tblViewProfile.cellForRow(at: prevIndexPath) as? RepliesTableViewCell else {
                        
                        return
                    }
                    
                    
                    
                    //player!.pause()
                    
                    timerCount4?.invalidate()
                    timerCount4 = nil
                    timer4?.invalidate()
                    timer4 = nil
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
            let cell = tblViewProfile.cellForRow(at: indexPath) as! RepliesTableViewCell
            
            
            
            
            let dataDict = postDataArray[sender.tag] as? NSDictionary ?? [:]
            
            
            
            audioUrl = NSURL(string: dataDict["message"] as? String ?? "")! as URL
            
            
            
            print(audioUrl)
            
            
            if(isPlaying)
            {
                
                player!.pause()
                
                timerCount4?.invalidate()
                timerCount4 = nil
                timer4?.invalidate()
                timer4 = nil
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
                    
                    
                    let asset = AVAsset(url: audioUrl)
                    
                    let duration = asset.duration
                    let durationTime = CMTimeGetSeconds(duration)
                    
                    
                    count = Int(ceil(durationTime))
                    
                    
                    countDownTimet()
                    
                    
                    
                    
                    
                    timer4 = Timer.scheduledTimer(timeInterval: 0.009, target: self, selector: #selector(self.refreshAudioView(_:)), userInfo: nil, repeats: true)
                    
                    cell.btnPlayPausedRef.setImage(UIImage(named: "home_pause_a"),for: .normal)
                    player!.play()
                    
                    
                    isPlaying = true
                }
                else
                {
                    
                    
                    _ = SweetAlert().showAlert("Escalate", subTitle: "Audio file is missing.", style: AlertStyle.error)
                    
                }
            }
            
            
            let prevBtnTag = UserDefaults.standard.value(forKey: "BTNTAG") as? Int ?? 0
            
            print(prevBtnTag)
            
            UserDefaults.standard.set(prevBtnTag, forKey: "PBTNTAG")
            
  
 

        }

        

    }
    
    
    @IBAction func btnBackTapped(_ sender: Any) {
        
        stopRecordings()
        stopTableAudio()
        
        self.navigationController?.popViewController(animated: true)
        
    }

    
    @IBAction func btnReplyTapped(_ sender: Any) {
        
        
        

        
        if(isPlaying)
        {
            let btnTag = UserDefaults.standard.value(forKey: "BTNTAG") as? Int ?? 0
            
            
            
            let indexPath = IndexPath(row: btnTag, section: 0)
            
            guard let cell = tblViewProfile.cellForRow(at: indexPath) as? RepliesTableViewCell else {
                
                return
            }
            
            
          stopTableAudio()
        }
        
        
        
        
        
        if(isRecording)
        {
            
            let sec = 0
            let hr = 0
            let min = 0
            
            
            print("TIMERCOUNT")
            print(count)
            timerLimit?.invalidate()
            timerLimit = nil
            countLimit = 40
            
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
            
            
            countDownTimet1()
            
            setup_recorder()
            
            //lblInstructions.text = "tap to stop"
            
            audioRecorder.record()
            
            isRecording = true
            
            
        }
        
        

       
    
    }
    
    
    //ONE MINUTE TIMER
    
    func countDownTimet1(){
        
        timerLimit = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.update1), userInfo: nil, repeats: true)
    }
    
    
    @objc func update1() {
        if(countLimit > 0) {
            
            
            countLimit = countLimit - 1
            print(countLimit)
        }
        else{
            print("TIMERCOUNT")
            print(countLimit)
            timerLimit?.invalidate()
            timerLimit = nil
            
            countLimit = 40
            
            let sec = 0
            let hr = 0
            let min = 0
            
            
            
//            lblInstructions.text = "tap to record"
//
//            let totalTimeString = String(format: "%02d:%02d:%02d", hr, min, sec)
//            recordingTimeLabel.text = totalTimeString
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
            let totalTimeString = String(format: "%02d:%02d:%02d", hr, min, sec)
            //recordingTimeLabel.text = totalTimeString
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

extension RepliesVC:UITableViewDelegate,UITableViewDataSource{
    
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
            
//            "user_image": "http://mobulous.app/escalate/public/users-photos/90ed887c4bd7915.jpg",
//            "username": "ambalika",
//            "message": "http://mobulous.app/escalate/public/audio_comment/96af235f30dca14.mp3",
//            "created_at": "2018-08-07 05:26:15"
            
            
             dataDict = postDataArray.object(at: indexPath.row) as? NSDictionary ?? [:]
            
            let image = dataDict.value(forKey: "user_image") as? String ?? ""
            
            cell.imgView_user.sd_setImage(with: URL(string: image as? String ?? ""), placeholderImage: UIImage(named: "user_signup"))
            
            cell.lblFullName.text = dataDict.value(forKey: "fullname") as? String ?? ""
            
            cell.lblDescription.text = dataDict.value(forKey: "description") as? String ?? ""
            
            
            cell.lblUserName.text = "@\(dataDict.value(forKey: "username") as? String ?? "")"
            
          
           // let duration = Int(dataDict.value(forKey: "duration") as? String ?? "") ?? 0
            
           cell.lblTotalTimer.text = dataDict.value(forKey: "msg_duration") as? String ?? ""
            
            
//            if duration < 10{
//
//                cell.lblTotalTimer.text = "00:00:0\(duration)"
//            }else{
//                cell.lblTotalTimer.text = "00:00:\(duration)"
//            }
//
            
            
            
        
           
            
//            cell.btnOtherProfileRef.tag = indexPath.row
//            cell.btnOtherProfileRef.addTarget(self, action: #selector(btnOtherProfileTapped), for: .touchUpInside)
//
            cell.btnPlayPausedRef.tag = indexPath.row
            cell.btnPlayPausedRef.addTarget(self, action: #selector(btnPlayPausedTapped), for: .touchUpInside)
            
          
     
            
            
        }
        
        return cell
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        
        stopTableAudio()
        
//        if(isPlaying)
//        {
//            let btnTag = UserDefaults.standard.value(forKey: "BTNTAG") as? Int ?? 0
//
//
//
//            let indexPath = IndexPath(row: btnTag, section: 0)
//
//            guard let cell = tblViewProfile.cellForRow(at: indexPath) as? RepliesTableViewCell else {
//
//                return
//            }
//
//
//
//            player!.pause()
//
//            timerCount4?.invalidate()
//            timerCount4 = nil
//            timer4?.invalidate()
//            timer4 = nil
//            sec = 0
//            hr = 0
//            min = 0
//
//            cell.btnPlayPausedRef.setImage(#imageLiteral(resourceName: "home_play_a"), for: .normal)
//
//            isPlaying = false
//            cell.audioView.amplitude = 0.0
//
//            let totalTimeString = String(format: "%02d:%02d:%02d", hr, min, sec)
//            cell.lblTotalTimer.text = totalTimeString
//        }
//
//        //        timer3?.invalidate()
//        //        timer3 = nil
//        //        timerCount3?.invalidate()
//        //        timerCount3 = nil
//
        
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableViewAutomaticDimension
        
    }
    
}

