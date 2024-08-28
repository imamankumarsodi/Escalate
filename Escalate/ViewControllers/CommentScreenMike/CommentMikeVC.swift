//
//  CommentMikeVC.swift
//  Escalate
//
//  Created by call soft on 19/07/18.
//  Copyright © 2018 call soft. All rights reserved.
//

import UIKit
import AVFoundation
import Pulsator


class CommentMikeVC: UIViewController, AVAudioRecorderDelegate, AVAudioPlayerDelegate {
    
    
    //MARK:- OUTLETS
    //MARK:
    
    @IBOutlet weak var imageViewUserProfile: UIImageView!
    
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var lblFullName: UILabel!
    
    @IBOutlet weak var lblInstructions: UILabel!
    
    @IBOutlet weak var sourceView: UIView!
    @IBOutlet var recordingTimeLabel: UILabel!
    @IBOutlet var record_btn_ref: UIButton!
    
    
    
    //MARK:- VARIABLES
    //MARK:
    
    var audioRecorder: AVAudioRecorder!
    var audioPlayer : AVAudioPlayer!
    var meterTimer:Timer!
    var isAudioRecordingGranted: Bool!
    var isRecording = false
    var isPlaying = false
    let pulsator = Pulsator()
    let WebserviceConnection  = AlmofireWrapper()
    
    var audioID = ""
    
    
    var contoller =  UIViewController()
    
    
    //******Variables for 40 timer
    
    var count = 39
    var timerLimit:Timer?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        initialSetUp()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

//    override var prefersStatusBarHidden: Bool {
//        return true
//    }
    
    //TODO:- WEB SERVICES
    func viewProfile(){
        
        
        
        let infoArray = UserDefaults.standard.value(forKey: "USERINFO") as? NSArray ?? []
        //print(infoArray)
        let infoDict = infoArray.object(at: 0) as? NSDictionary ?? [:]
        
        //print(infoDict)
        
        let user_id = infoDict.value(forKey: "user_id") as? String ?? ""
        
        //print(user_id)
        
        
        if InternetConnection.internetshared.isConnectedToNetwork() {
            
            Indicator.shared.showProgressView(self.view)
            
            
            
            WebserviceConnection.requestGETURL("userdetail/\(user_id)/\(user_id)", success: { (responseJson) in
                
                if responseJson["status"].stringValue == "SUCCESS" {
                    
                    Indicator.shared.hideProgressView()
                    
                    print("SUCCESS")
                    
                    print(responseJson)
                    
                    let userDict = responseJson["data"].dictionaryObject ?? [:]
                    
                    self.lblFullName.text = userDict["fullname"] as? String ?? ""
                    
                    self.lblUserName.text = "@\(userDict["username"] as? String ?? "")"
                    
                    
                    
                    
                    
                    
                    let image = userDict["image"] as? String ?? ""
                    
                    self.imageViewUserProfile.sd_setImage(with: URL(string: image as? String ?? ""), placeholderImage: UIImage(named: "user_signup"))
                    
                    
                    
                }else{
                    
                    print(responseJson)
                    
                    Indicator.shared.hideProgressView()
                    
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
    
    
    
    
    
    //MARK:- METHODS
    //MARK:
    
    
    func initialSetUp(){
        
        
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(CommentMikeVC.stopRecordingAndPlaying(_:)), name: NSNotification.Name(rawValue: "stopRecordingAndPlaying"), object: nil)
        
          viewProfile()
        
        UserDefaults.standard.removeObject(forKey: "RECORDINGURL")
        check_record_permission()
    }
    
    
  
    
    
    func addHalo() {
        
        pulsator.position = .init(x: 50, y: 50
        )
        pulsator.numPulse = 5
        pulsator.radius = 80
        pulsator.animationDuration = 3
        pulsator.backgroundColor = UIColor(red: 76/255, green: 40/255, blue: 107/255, alpha: 1).cgColor
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
            print("recorded successfully.")
            
            
            let urlString: String = getFileUrl().absoluteString
            print(urlString)
            UserDefaults.standard.set(urlString, forKey: "RECORDINGURL")
            self.navigationController?.popViewController(animated: true)
            
            
        }
        else
        {
            display_alert(msg_title: "Error", msg_desc: "Recording failed.", action_title: "OK")
        }
    }
    
    
    
    func stopRecording(){
        
        
        if (isRecording)
        {
            
            print("TIMERCOUNT")
            print(count)
            
            print("Aman")
            
            timerLimit?.invalidate()
            timerLimit = nil
            
            let sec = 0
            let hr = 0
            let min = 0
            
            
            let totalTimeString = String(format: "%02d:%02d", min, sec)
            recordingTimeLabel.text = totalTimeString
            pulsator.stop()
            
            
            //finishAudioRecording(success: true)
            isRecording = false
            
            lblInstructions.text = "tap to record"
            audioRecorder.stop()
            audioRecorder = nil
            meterTimer.invalidate()
            
        }
        
    }
    
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool)
    {
        if !flag
        {
            finishAudioRecording(success: false)
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
    
    
    
    
    //MARK:- ACTIONS
    //MARK:
    
    
    
    
    @objc func stopRecordingAndPlaying(_ notification: Notification) {
        
        
       stopRecording()

        
    }
    
    
    
    
    @IBAction func btnMikeTapped(_ sender: Any) {
        

        if(isRecording)
        {

            
            print("TIMERCOUNT")
            print(count)
            timerLimit?.invalidate()
            timerLimit = nil
            
            let sec = 0
            let hr = 0
            let min = 0



            lblInstructions.text = "tap to record"

            let totalTimeString = String(format: "%02d:%02d", min, sec)
            recordingTimeLabel.text = totalTimeString
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
            
            countDownTimet()
            
            addHalo()

            setup_recorder()

            lblInstructions.text = "tap to stop"

            audioRecorder.record()

            isRecording = true


        }
        
        
    }
    
    
    
    //ONE MINUTE TIMER
    
    func countDownTimet(){
        
        timerLimit = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.update), userInfo: nil, repeats: true)
    }
    
    
    @objc func update() {
        if(count > 0) {
            
            
            count = count - 1
            print(count)
        }
        else{
            print("TIMERCOUNT")
            print(count)
            timerLimit?.invalidate()
            timerLimit = nil
            
            
            let sec = 0
            let hr = 0
            let min = 0
            
            
            
            lblInstructions.text = "tap to record"
            
            let totalTimeString = String(format: "%02d:%02d", min, sec)
            recordingTimeLabel.text = totalTimeString
            pulsator.stop()
            finishAudioRecording(success: true)
            isRecording = false
            
            _ = SweetAlert().showAlert("Escalate", subTitle: "Recording limit(40 sec) reached!", style: AlertStyle.warning)
            
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
            recordingTimeLabel.text = totalTimeString
            audioRecorder.updateMeters()
        }
    }
    
  
    @IBAction func btnCancelTapped(_ sender: Any) {
        
        
        if (isRecording)
        {
            
            print("TIMERCOUNT")
            print(count)
            timerLimit?.invalidate()
            timerLimit = nil
            
            lblInstructions.text = "tap to record"
            audioRecorder.stop()
            audioRecorder = nil
            meterTimer.invalidate()
            
        }
        
        self.navigationController?.popViewController(animated: true)

    }
    
}
