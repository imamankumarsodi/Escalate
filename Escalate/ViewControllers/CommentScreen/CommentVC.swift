//
//  CommentVC.swift
//  Escalate
//
//  Created by call soft on 19/07/18.
//  Copyright © 2018 call soft. All rights reserved.
//

import UIKit
import AVFoundation
import SDWebImage
import SwiftSiriWaveformView


class CommentVC: UIViewController,AVAudioRecorderDelegate, AVAudioPlayerDelegate {
    
    
    //MARK:- OUTLETS
    //MARK
    
    @IBOutlet weak var imageViewUserProfile: UIImageView!
    
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var lblFullName: UILabel!
    
    @IBOutlet var txt_view: UITextView!
    @IBOutlet weak var lblRecordingTime: UILabel!
    @IBOutlet var btnPlayRef: UIButton!
    @IBOutlet weak var audioView: SwiftSiriWaveformView!
    
    
    
    
    //MARK:- VARIABLES
    //MARK
    
    
    
    let validation:Validation = Validation.validationManager() as! Validation
    
    var controllerInstance =  UIViewController()
    
    var audioUrl: URL!
    
    var audioData = Data()
    
    var isPlaying = false
    
    var audioPlayer : AVAudioPlayer!
    
    var timer5:Timer?
    
    var change:CGFloat = 0.01
    
    var timerCount5:Timer?
    
    var secCount = 0
    
    var count = 0
    
    var hr = 0
    
    var min = 0
    
    var sec = 0
    
    var durationForApi = ""
    
    let WebserviceConnection  = AlmofireWrapper()
    
    var audioID = ""
    
   
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetUp()

        // Do any additional setup after loading the view.
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
                    
    
                    
                    self.setTimerLabel()
                    
                    
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
    
    
    
    func setTimerLabel(){
        
        let asset = AVAsset(url: audioUrl)
        
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
        
        
        lblRecordingTime.text = durationForApi
        
    }
    
    
    func initialSetUp(){
        
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(CommentVC.stopRecordingAndPlaying(_:)), name: NSNotification.Name(rawValue: "stopRecordingAndPlaying"), object: nil)
    
        viewProfile()
        
        txt_view.delegate = self
        txt_view.text = "Comment..."
        txt_view.textColor = UIColor.lightGray
    }
    
    
    //MARK:- METHODS
    //MARK:
    
    
    func validationSetup()->Void{
        
        
        
        var message = ""
        
        //var tempString = txtFeildMail.text ?? ""
        
        
        if !validation.validateBlankField(txt_view.text!){
            
            message = "Please enter Comment..."
        }
        else if txt_view.text == "Comment..."{
            
            message = "Please enter Comment..."
        }
        
        
        
        if message != "" {
            
            
            _ = SweetAlert().showAlert("Escalate", subTitle: message, style: AlertStyle.error)
            
        }else{
            
            self.sendVoicePost()
            
        }
        
        
    }
    
    
    
    
    func updatedBioAudio(){
        
        
        if(isPlaying)
        {
            audioPlayer.stop()
            
            timerCount5?.invalidate()
            timerCount5 = nil
            timer5?.invalidate()
            timer5 = nil
            sec = 0
            hr = 0
            min = 0
            btnPlayRef.setImage(UIImage(named: "home_play_a"),for: .normal)
            //btnPlayRef.setTitle(" tap to play", for: .normal)
            isPlaying = false
            audioView.amplitude = 0.0
            setTimerLabel()
        }
        else
        {
            if FileManager.default.fileExists(atPath: (audioUrl?.path)!)
            {
                
                btnPlayRef.setImage(UIImage(named: "home_pause_a"),for: .normal)
                //btnPlayRef.setTitle(" tap to stop", for: .normal)
                
                let asset = AVAsset(url: audioUrl)
                
                let duration = asset.duration
                let durationTime = CMTimeGetSeconds(duration)
                durationForApi = String(round(durationTime))
                count = Int(ceil(durationTime))
                
                countDownTimet()
                timer5 = Timer.scheduledTimer(timeInterval: 0.009, target: self, selector: #selector(self.refreshAudioView(_:)), userInfo: nil, repeats: true)
                print(audioUrl)
                
                prepare_play()
                audioPlayer.play()
                
                
                isPlaying = true
            }
            else
            {
                
                _ = SweetAlert().showAlert("Escalate", subTitle: "Audio file is missing.", style: AlertStyle.error)
                //display_alert(msg_title: "Error", msg_desc: "Audio file is missing.", action_title: "OK")
            }
        }
        
    }
    
    
    
    @objc internal func refreshAudioView(_:Timer) {
        if self.audioView.amplitude <= self.audioView.idleAmplitude || self.audioView.amplitude > 1.0 {
            self.change *= -1.0
        }
        
        
        // Simply set the amplitude to whatever you need and the view will update itself.
        self.audioView.amplitude += self.change
    }
    
    
    func prepare_play()
    {
        do
        {
            
            print(audioUrl)
            audioPlayer = try AVAudioPlayer(contentsOf: audioUrl!)
            audioPlayer.delegate = self
            audioPlayer.prepareToPlay()
        }
        catch{
            print("Error")
        }
    }
    
    
    
    //COUNTER FOR WAVE AND AUDIO TIME
    
    func countDownTimet(){
        
        timerCount5 = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.update), userInfo: nil, repeats: true)
    }
    
    
    @objc func update() {
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
            print("TIMERCOUNT")
            print(count)
            sec = 0
            hr = 0
            min = 0
            
            timer5?.invalidate()
            timer5 = nil
            timerCount5?.invalidate()
            timerCount5 = nil
            
           setTimerLabel()
            
            btnPlayRef.setImage(UIImage(named: "home_play_a"),for: .normal)
            
            audioView.amplitude = 0.0
            isPlaying = false
            
            _ = SweetAlert().showAlert("Escalate", subTitle: "Recording limit(40 sec) reached!", style: AlertStyle.warning)
            //STOP PLAYING AND ANIMATION
            
            
        }
    }
    
    func sendVoicePost(){
        


        if(isPlaying){
            audioPlayer.stop()

        }

        timerCount5?.invalidate()
        timerCount5 = nil
        timer5?.invalidate()
        timer5 = nil
        sec = 0
        hr = 0
        min = 0
        audioView.amplitude = 0.0

        btnPlayRef.setImage(UIImage(named: "create_memo_play"),for: .normal)
        isPlaying = false



        setTimerLabel()



        let infoArray = UserDefaults.standard.value(forKey: "USERINFO") as? NSArray ?? []
        //print(infoArray)
        let infoDict = infoArray.object(at: 0) as? NSDictionary ?? [:]

        //print(infoDict)

        let token = infoDict.value(forKey: "token") as? String ?? ""

        print(token)

        let user_id = infoDict.value(forKey: "user_id") as? String ?? ""

        print(user_id)



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
        
        print(durationForApi)
        
        
        
        
        


        do {

            self.audioData = try Data(contentsOf: audioUrl)
            print("AUDIO DATA")
            print(self.audioData)
            print("AUDIO DATA")

        } catch {

            print("Unable to load data: \(error)")

        }


//        token:required
//        user_id:required
//        audio_id:required
//        audio:(this is comment audio file)
//        msg_duration

        
        let passDict = ["user_id":user_id,
                        "audio_id":audioID,
                        "token":token,
                        "description":txt_view.text!,
                        "msg_duration":durationForApi] as [String : AnyObject]

        print(passDict)

        if InternetConnection.internetshared.isConnectedToNetwork() {

            Indicator.shared.showProgressView(self.view)


            WebserviceConnection.requWithAudioFile(audioData: audioData as NSData, fileName: "recording.mp3", audioparam: "audio", urlString: "commentOnAudio", parameters: passDict, headers: nil, success:{ (responseJson) in


                if responseJson["status"].stringValue == "SUCCESS" {

                    Indicator.shared.hideProgressView()

                    print(responseJson["status"])
                    print(responseJson)
            
                    let isComing = UserDefaults.standard.value(forKey: "ISCOMINGFORNOTIFICATION") as? String ?? ""
                    
                    print(isComing)
                        
                    if isComing == "FROMHOME"
                    {
                        
                        
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "refresh"), object: nil)
                         NotificationCenter.default.post(name: NSNotification.Name(rawValue: "resetUIBTN"), object: nil)
                        
                        
                    }
                    
                    else if isComing == "FROMUSERPROFILE"
                    {
                         NotificationCenter.default.post(name: NSNotification.Name(rawValue: "refreshListProfile"), object: nil)
                         NotificationCenter.default.post(name: NSNotification.Name(rawValue: "resetUIBTN"), object: nil)
                        
                    }
                    else if isComing == "FROMOTHERPROFILE"
                    {
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "refreshListOtherProfile"), object: nil)
                         NotificationCenter.default.post(name: NSNotification.Name(rawValue: "resetUIBTN"), object: nil)
                        
                    }
                    else if isComing == "FROMSEARCH"{
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "refreshListSearch"), object: nil)
                         NotificationCenter.default.post(name: NSNotification.Name(rawValue: "resetUIBTN"), object: nil)
                        
                    }else if isComing == "FROMAFTERSEARCH"{
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "refreshListSearch"), object: nil)
                         NotificationCenter.default.post(name: NSNotification.Name(rawValue: "resetUIBTN"), object: nil)
                        
                    }
                    
                    
                    
                    
                
                    


                    _ = SweetAlert().showAlert("Escalate", subTitle: "Successfully commented.", style: AlertStyle.success)

                    self.dismiss(animated: true, completion: nil)






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
    
    
    
    
    //MARK:- ACTIONS
    //MARK:
    
    
    
    
    @objc func stopRecordingAndPlaying(_ notification: Notification) {
        
        
        if(isPlaying){
            audioPlayer.stop()
            
        }
        
        timerCount5?.invalidate()
        timerCount5 = nil
        timer5?.invalidate()
        timer5 = nil
        sec = 0
        hr = 0
        min = 0
        audioView.amplitude = 0.0
        
        btnPlayRef.setImage(UIImage(named: "create_memo_play"),for: .normal)
        isPlaying = false
        
        
        
        setTimerLabel()
        
        
    }
    
    
    
    @IBAction func btnPostTapped(_ sender: Any) {
        
         validationSetup()
        
        
        
    }
    
    
    @IBAction func btnCancelTapped(_ sender: Any) {
        
        
        
        if(isPlaying){
            audioPlayer.stop()
            
        }
        
        timerCount5?.invalidate()
        timerCount5 = nil
        timer5?.invalidate()
        timer5 = nil
        sec = 0
        hr = 0
        min = 0
        audioView.amplitude = 0.0
        
        btnPlayRef.setImage(UIImage(named: "create_memo_play"),for: .normal)
        isPlaying = false
        
        
        
        setTimerLabel()
        
         NotificationCenter.default.post(name: NSNotification.Name(rawValue: "resetUIBTN"), object: nil)
        
        self.dismiss(animated: true, completion: nil)
        
        
    }
    
    
    
        @IBAction func play_recording(_ sender: Any)
        {
    
            updatedBioAudio()
    
        }
    
    
   
    
    
    }
    




//MARK:- EXTENSION TEXTVIEW
//MARK


extension CommentVC: UITextViewDelegate{
    //MARK: UITextViewDelegate delegate
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        if(isPlaying){
            audioPlayer.stop()
            
        }
        
        timerCount5?.invalidate()
        timerCount5 = nil
        timer5?.invalidate()
        timer5 = nil
        sec = 0
        hr = 0
        min = 0
        audioView.amplitude = 0.0
        
        btnPlayRef.setImage(UIImage(named: "create_memo_play"),for: .normal)
        isPlaying = false
        
        
        
        setTimerLabel()
        
        if(textView == txt_view){
            
            textView.text = nil
            txt_view.textColor = UIColor.black
            
        }
        
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        
        if(textView == txt_view){
            
            if txt_view.text.isEmpty {
                
                txt_view.text = "Comment..."
                
                txt_view.textColor = UIColor.lightGray
            }
            
            
        }
        
    }
    
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        let numberOfChars = newText.characters.count
        return numberOfChars < 301
    }
    
}
