//
//  EditProfileVC.swift
//  Escalate
//
//  Created by call soft on 20/07/18.
//  Copyright © 2018 call soft. All rights reserved.
//

import UIKit
import AVFoundation
import SDWebImage
import SwiftSiriWaveformView
import Firebase

class EditProfileVC: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate, AVAudioRecorderDelegate, AVAudioPlayerDelegate{
    
    
    
    //MARK:- OUTLETS
    //MARK:
    
    @IBOutlet weak var txtCountryCode: UITextField!
    @IBOutlet weak var btnUserNameRef: UIButton!
    @IBOutlet weak var btnEmailRef: UIButton!
    @IBOutlet weak var lblCategories: UILabel!
    
    @IBOutlet weak var btnPlayRef: UIButton!
    
    @IBOutlet weak var lblRecordingTime: UILabel!
    
    @IBOutlet weak var txtFeildFullName: UITextField!
    
    @IBOutlet weak var txtFeildUserName: UITextField!
    
    @IBOutlet weak var txtFieldEmail: UITextField!
    
    
    @IBOutlet weak var txtFeildPhone: UITextField!
    
    @IBOutlet weak var imgViewProfile: UIImageView!
    
    @IBOutlet weak var audioView: SwiftSiriWaveformView!
    
    //MARK:- VARIABLE
    //MARK:
    
    
    
    var arrayFromPlist:NSMutableArray = NSMutableArray()
    
    var userDict = NSDictionary()
    
    var editFullNameStatus = false
    
    var editEmailStatus = false
    
    var editPhoneStatus = false
    
    var imagePicker = UIImagePickerController()
    
    var imageData = NSData()
    
    var audioData = Data()
    
    let WebserviceConnection  = AlmofireWrapper()
    
    var isPlaying = false
    
    var audioPlayer : AVAudioPlayer!
    
    var audioUrl: URL!
    
    var bioURLString = String()
    
    let validation:Validation = Validation.validationManager() as! Validation
    
    var timerAA:Timer?
    
    var change:CGFloat = 0.01
    
    var timerCountAA:Timer?
    var count = 0
    var hr = 0
    var min = 0
    var sec = 0
    
    
    var player:AVPlayer?
    var playerItem:AVPlayerItem?
    
    var  selectedCategoriesName = [String]()
    
    var categoriesName = ""
    
    var durationForApi = ""
    
    
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initialSetup()
        
        
        
        // Do any additional setup after loading the view.
    }
    

    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
//    override var prefersStatusBarHidden: Bool {
//        return true
//    }
    
    override func viewWillAppear(_ animated: Bool) {
        viewCategoriesForEdit()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    
    
    //MARK:- ACTIONS
    //MARK:
    
    
    
    @objc func stopRecordingAndPlaying(_ notification: Notification) {
        
      
        if UserDefaults.standard.value(forKey: "RECORDINGURL") != nil{
            
            
            if(isPlaying){
                audioPlayer.stop()
            }
            
            
            
        }else{
            
            
            if(isPlaying){
                player!.pause()
            }
            
            
            
        }
        
        
        timerCountAA?.invalidate()
        timerCountAA = nil
        timerAA?.invalidate()
        timerAA = nil
        sec = 0
        hr = 0
        min = 0
        audioView.amplitude = 0.0
        
        btnPlayRef.setImage(UIImage(named: "home_play_a"),for: .normal)
        isPlaying = false
        
        
        
        let totalTimeString = String(format: "%02d:%02d", min, sec)
        lblRecordingTime.text = totalTimeString
        
        UserDefaults.standard.removeObject(forKey: "RECORDINGURL")
        

        
    }
    
    
    @objc internal func refreshAudioView(_:Timer) {
        if self.audioView.amplitude <= self.audioView.idleAmplitude || self.audioView.amplitude > 1.0 {
            self.change *= -1.0
        }
        
        
        // Simply set the amplitude to whatever you need and the view will update itself.
        self.audioView.amplitude += self.change
    }
    
    
    @IBAction func btnCountryCodeTapped(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "CityListTablVc") as! CityListTablVc
        vc.objeCountryListDelegate = self
        present(vc, animated: true, completion: nil)
    }
    
    
    
    
//    @IBAction func btnEditTapped(_ sender: Any) {
//
//
//        if (sender as AnyObject).tag == 1{
//
//        if editFullNameStatus ==  false {
//
//            txtFeildFullName.becomeFirstResponder()
//            txtFeildFullName.isUserInteractionEnabled = true
//            editFullNameStatus = true
//
//
//        }else{
//
//            txtFeildFullName.isUserInteractionEnabled = false
//            editFullNameStatus = false
//
//
//        }
//        }else if (sender as AnyObject).tag == 2{
//
//
//            if editEmailStatus ==  false {
//
//                txtFieldEmail.becomeFirstResponder()
//                txtFieldEmail.isUserInteractionEnabled = true
//                editEmailStatus = true
//
//
//            }else{
//
//                txtFieldEmail.isUserInteractionEnabled = false
//                editEmailStatus = false
//
//
//            }
//
//        }else{
//
//
//
//            if editPhoneStatus ==  false {
//                
//                txtFeildPhone.becomeFirstResponder()
//                
//                txtFeildPhone.isUserInteractionEnabled = true
//                editPhoneStatus = true
//
//
//            }else{
//
//                txtFeildPhone.isUserInteractionEnabled = false
//                editPhoneStatus = false
//
//
//            }
//
//
//        }
//    }

    
    
    @IBAction func btnBackTapped(_ sender: Any) {
        
        
        
        if UserDefaults.standard.value(forKey: "RECORDINGURL") != nil{
            
            
            if(isPlaying){
                audioPlayer.stop()
            }
            

            
        }else{
            
            
            if(isPlaying){
                player!.pause()
            }
        
            
            
        }
        
        
        timerCountAA?.invalidate()
        timerCountAA = nil
        timerAA?.invalidate()
        timerAA = nil
        sec = 0
        hr = 0
        min = 0
        audioView.amplitude = 0.0
        
        btnPlayRef.setImage(UIImage(named: "home_play_a"),for: .normal)
        isPlaying = false
        
        
        
        let totalTimeString = String(format: "%02d:%02d", min, sec)
        lblRecordingTime.text = totalTimeString
        
        UserDefaults.standard.removeObject(forKey: "RECORDINGURL")
        
        self.navigationController?.popViewController(animated: true)
        
        
        
        
    }
    
    @IBAction func btnEditBioTapped(_ sender: Any) {
        
        
         if UserDefaults.standard.value(forKey: "RECORDINGURL") != nil{
            
            if(isPlaying){
               audioPlayer.stop()
            }
            
         }else{
            if(isPlaying){
                player!.pause()
            }
            
        }
    
        
        
        timerCountAA?.invalidate()
        timerCountAA = nil
        timerAA?.invalidate()
        timerAA = nil
        sec = 0
        hr = 0
        min = 0
        audioView.amplitude = 0.0
        
        btnPlayRef.setImage(UIImage(named: "home_play_a"),for: .normal)
        isPlaying = false
        
        
        
        let totalTimeString = String(format: "%02d:%02d", min, sec)
        lblRecordingTime.text = totalTimeString
        
        UserDefaults.standard.removeObject(forKey: "RECORDINGURL")
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "EditBioVC") as! EditBioVC
        self.navigationController?.pushViewController(vc, animated: true)
        //self.navigationController?.present(vc, animated: true, completion: nil)
        
    }
    
    @IBAction func btnSaveTapped(_ sender: Any) {
        
        if UserDefaults.standard.value(forKey: "RECORDINGURL") != nil{
            
            
            if(isPlaying){
                audioPlayer.stop()
            }
            
            
            
        }else{
            
            
            if(isPlaying){
                player!.pause()
            }
            
            
            
        }
        
        
        timerCountAA?.invalidate()
        timerCountAA = nil
        timerAA?.invalidate()
        timerAA = nil
        sec = 0
        hr = 0
        min = 0
        audioView.amplitude = 0.0
        
        btnPlayRef.setImage(UIImage(named: "home_play_a"),for: .normal)
        isPlaying = false
        
        
        
        let totalTimeString = String(format: "%02d:%02d", min, sec)
        lblRecordingTime.text = totalTimeString
        
        
        
        
        validationSetup()
        //self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func btnChangePasswordTapped(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "CategoriesVC") as! CategoriesVC
        vc.isComing = "EDTPROFILE"
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    
    
    @IBAction func btnCameraTapped(_ sender: Any) {
        openActionSheet()
    }
    
    
    
    @IBAction func play_recording(_ sender: Any)
    {
        
        if UserDefaults.standard.value(forKey: "RECORDINGURL") != nil{
            
            updatedBioAudio()
            
        }else{
            
            playBioFromAPI()
            
        }
        
        
        
    }
    
    
    func updatedBioAudio(){
        
        audioUrl = NSURL(string: UserDefaults.standard.value(forKey: "RECORDINGURL") as? String ?? "") as! URL
        
        if(isPlaying)
        {
            audioPlayer.stop()
            
            timerCountAA?.invalidate()
            timerCountAA = nil
            timerAA?.invalidate()
            timerAA = nil
            sec = 0
            hr = 0
            min = 0
            btnPlayRef.setImage(UIImage(named: "home_play_a"),for: .normal)
            isPlaying = false
            audioView.amplitude = 0.0
            if UserDefaults.standard.value(forKey: "RECORDINGURL") != nil{
                
                
                audioUrl = NSURL(string: UserDefaults.standard.value(forKey: "RECORDINGURL") as? String ?? "") as! URL
                
                
                
                
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
                
                print(durationForApi)
                
                let totalTimeString = durationForApi
                lblRecordingTime.text = totalTimeString
                
            }
        }
        else
        {
            if FileManager.default.fileExists(atPath: (audioUrl?.path)!)
            {
                
                btnPlayRef.setImage(UIImage(named: "home_pause_a"),for: .normal)
                
                let asset = AVAsset(url: audioUrl)
                
                let duration = asset.duration
                let durationTime = CMTimeGetSeconds(duration)
                count = Int(ceil(durationTime))
                
                
                timerAA = Timer.scheduledTimer(timeInterval: 0.009, target: self, selector: #selector(self.refreshAudioView(_:)), userInfo: nil, repeats: true)
                
                prepare_play()
                audioPlayer.play()
                
                countDownTimet()
                isPlaying = true
            }
            else
            {
                
                _ = SweetAlert().showAlert("Escalate", subTitle: "Bio not recorded yet!", style: AlertStyle.error)
                //display_alert(msg_title: "Error", msg_desc: "Audio file is missing.", action_title: "OK")
            }
        }
    }
    
    
    func playBioFromAPI(){
        
        print(audioUrl)
        
         if bioURLString != ""{
        
        
        if(isPlaying)
        {
            
            player!.pause()
            
            timerCountAA?.invalidate()
            timerCountAA = nil
            timerAA?.invalidate()
            timerAA = nil
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
                
                 player!.play()
                
                let asset = AVAsset(url: audioUrl)
                
                let duration = asset.duration
                let durationTime = CMTimeGetSeconds(duration)
                count = Int(ceil(durationTime))
                
                countDownTimet()
                timerAA = Timer.scheduledTimer(timeInterval: 0.009, target: self, selector: #selector(self.refreshAudioView(_:)), userInfo: nil, repeats: true)
                
                btnPlayRef.setImage(UIImage(named: "home_pause_a"),for: .normal)
                //player!.play()
               
                
                isPlaying = true
            }
            else
            {
                
                
                _ = SweetAlert().showAlert("Escalate", subTitle: "Bio not recorded yet!", style: AlertStyle.error)
                //display_alert(msg_title: "Error", msg_desc: "Audio file is missing.", action_title: "OK")
            }
        }
        
        
         }else{
            _ = SweetAlert().showAlert("Escalate", subTitle: "Bio not recorded yet!", style: AlertStyle.error)
        }
        
        
    }
    
    
    //COUNTER FOR WAVE AND AUDIO TIME
    
    func countDownTimet(){
        
        timerCountAA = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.update), userInfo: nil, repeats: true)
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
            
            timerCountAA?.invalidate()
            timerCountAA = nil
            timerAA?.invalidate()
            timerAA = nil
            
            
            if UserDefaults.standard.value(forKey: "RECORDINGURL") != nil{
                
                
                audioUrl = NSURL(string: UserDefaults.standard.value(forKey: "RECORDINGURL") as? String ?? "") as! URL
                
                
                
                
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
                
                print(durationForApi)
                
                let totalTimeString = durationForApi
                lblRecordingTime.text = totalTimeString
                
            }else{
                
                let totalTimeString = self.userDict.value(forKey: "bio_duration") as? String ?? ""
                lblRecordingTime.text = totalTimeString
            }
            
            
            
            
            
            btnPlayRef.setImage(UIImage(named: "home_play_a"),for: .normal)
            
            audioView.amplitude = 0.0
             isPlaying = false
            //STOP PLAYING AND ANIMATION
            
            
        }
    }
    
    
    func validationForFullName()->Bool{
        
        do {
            let regex = try NSRegularExpression(pattern: ".*[^A-Za-z ].*", options: .caseInsensitive)
            if let _ = regex.firstMatch(in: txtFeildFullName.text!, options: NSRegularExpression.MatchingOptions.reportCompletion, range: NSMakeRange(0, txtFeildFullName.text!.count)) {
                return true
            }
            
        } catch {
            debugPrint(error.localizedDescription)
            return false
        }
        
        return false
        
    }
    
    
    
    
    func validationSetup()->Void{
        
        
        
        var message = ""
        
        //var tempString = txtFeildMail.text ?? ""
        
        if !validation.validateBlankField(txtFeildFullName.text!){
            
            message = "Please enter your full name"
        }
            
        else if validationForFullName() == true{
            message = "Please enter your valid full name (Full Name contains A-Z or a-z, no special character or digits are allowed.)"
        }
            
            
        else if !validation.validateBlankField(txtFieldEmail.text!){
            message = "Please enter Email ID"
            
        }else if !validation.validateEmail(txtFieldEmail.text!){
            
            message = "Please enter valid Email ID"
        }
          
//        else if !validation.validateBlankField(txtCountryCode.text!){
//            message = "Please select country code"
//        }
//
//        else if !validation.validateBlankField(txtFeildPhone.text!){
//            message = "Please enter phone number"
//        }
        
        
        
        if message != "" {
            
            
            _ = SweetAlert().showAlert("Escalate", subTitle: message, style: AlertStyle.error)
            
        }else{
            
            
            editProfileAPI()
            
            
            
        }
        
        
    }
    
    
    
    
    
    
    // MARK:- IMAGEPICKER DELEGATE
    //MARK:-
    
    func openActionSheet() {
        
        let alert:UIAlertController=UIAlertController(title: "Choose Image", message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
        let cameraAction = UIAlertAction(title: "Camera", style: UIAlertActionStyle.default)
        {
            UIAlertAction in
            self.openCamera()
        }
        let gallaryAction = UIAlertAction(title: "Gallery", style: UIAlertActionStyle.default)
        {
            UIAlertAction in
            self.openGallery()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel)
        {
            UIAlertAction in
        }
        
        imagePicker.delegate = self
        alert.addAction(cameraAction)
        alert.addAction(gallaryAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
        
    }
    
    
    func openCamera() {
        
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerControllerSourceType.camera)) {
            imagePicker.sourceType = UIImagePickerControllerSourceType.camera
            self .present(imagePicker, animated: true, completion: nil)
        }else {
            
            let alert = UIAlertController(title: "Escalate", message: "You don't have camera", preferredStyle: UIAlertControllerStyle.alert)
            
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func openGallery() {
        imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        self.present(imagePicker, animated: true, completion: nil)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        imagePicker.dismiss(animated: true, completion: nil)
        
        let chosenImage = info[UIImagePickerControllerEditedImage] as? UIImage
        
        
        if let chosenImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imageData = UIImageJPEGRepresentation(chosenImage, 0.5) as NSData!
             print(imageData)
        } else{
            print("Something went wrong")
        }
        
        self.dismiss(animated: true, completion: nil)
        
        //imageData = UIImageJPEGRepresentation(chosenImage!, 0.5) as NSData!
        
        
        print("Javed")
       
        
        imgViewProfile.image = chosenImage
        imgViewProfile.layer.cornerRadius = 5.0
        imgViewProfile.clipsToBounds = true
        
        UserDefaults.standard.set(imageData, forKey: "imageData")
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        //self.imagePicker = UIImagePickerController()
        dismiss(animated: true, completion: nil)
    }
    
    
    
    
    
    //MARK:- METHODS
    //MARK:
    
    
    func initialSetup(){
        
        
        
         NotificationCenter.default.addObserver(self, selector: #selector(EditProfileVC.resetLabel(_:)), name: NSNotification.Name(rawValue: "resetLabel"), object: nil)
        
        
          NotificationCenter.default.addObserver(self, selector: #selector(EditProfileVC.stopRecordingAndPlaying(_:)), name: NSNotification.Name(rawValue: "stopRecordingAndPlaying"), object: nil)
        
        
        
        let enteringFrom = UserDefaults.standard.value(forKey: "ENTERINGFROM") as? String ?? ""
        
        if enteringFrom == "SIMPLE"{
            
            txtFieldEmail.isUserInteractionEnabled = true
            btnEmailRef.isHidden = false
            
            
        }else{
            
            txtFieldEmail.isUserInteractionEnabled = false
            btnEmailRef.isHidden = true
        }
        
        
        
       
        
        imagePicker.allowsEditing =  true
        
        UserDefaults.standard.removeObject(forKey: "RECORDINGURL")
        
        viewProfile()
    }
    
    
    @objc func resetLabel(_ notification: Notification) {
        
        if UserDefaults.standard.value(forKey: "RECORDINGURL") != nil{
            
            
            audioUrl = NSURL(string: UserDefaults.standard.value(forKey: "RECORDINGURL") as? String ?? "") as! URL
            
            
            
            
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
            
            print(durationForApi)
            
            let totalTimeString = durationForApi
            lblRecordingTime.text = totalTimeString
            
        }else{
            
            
            let totalTimeString = self.userDict.value(forKey: "bio_duration") as? String ?? ""
            lblRecordingTime.text = totalTimeString
            
            
        }
        
        
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
    
    
    //TODO:- WEB SERVICES
    
    
    func viewCategoriesForEdit(){
        
        
        if InternetConnection.internetshared.isConnectedToNetwork() {
            
            Indicator.shared.showProgressView(self.view)
            
            let infoArray = UserDefaults.standard.value(forKey: "USERINFO") as? NSArray ?? []
            //print(infoArray)
            let infoDict = infoArray.object(at: 0) as? NSDictionary ?? [:]
            
            //print(infoDict)
            
            let token = infoDict.value(forKey: "token") as? String ?? ""
            
            print(token)
            
            let user_id = infoDict.value(forKey: "user_id") as? String ?? ""
            
            print(user_id)
            
            WebserviceConnection.requestGETURL("genre_listbyid/\(user_id)", success: { (responseJson) in
                
                if responseJson["status"].stringValue == "SUCCESS" {
                    
                    Indicator.shared.hideProgressView()
                    
                    print("SUCCESS")
                    
                    if self.selectedCategoriesName.count>0{
                        self.selectedCategoriesName.removeAll()
                    }
                    
                    
                    print(responseJson)
                    let dataArray = responseJson["data"].arrayObject as? NSArray ?? []
                    
                    for item in dataArray{
                        let dict = item as? NSDictionary ?? [:]
                        
                        let status = dict.value(forKey: "status") as? String ?? ""
                        
                        if status == "1"{
   
                        self.selectedCategoriesName.append(dict.value(forKey: "name") as? String ?? "")
                            
                        }
                        
                        
                    }
                    
                    
                    self.categoriesName = self.selectedCategoriesName.flatMap{ $0 }.joined(separator: ",")
                    print(self.categoriesName)
                    
                  self.lblCategories.text = self.categoriesName
                    
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
                    
                    self.userDict = responseJson["data"].dictionaryObject as? NSDictionary ?? [:]
                    
                    self.txtFeildFullName.text = self.userDict["fullname"] as? String ?? ""
                    
                    self.txtFeildUserName.text = self.userDict["username"] as? String ?? ""
                    
                    self.txtFeildPhone.text = self.userDict["phone"] as? String ?? ""
                    
                    self.txtFieldEmail.text = self.userDict["email"] as? String ?? ""
                    
                    self.txtCountryCode.text = self.userDict["country_code"] as? String ?? ""
                    
                    //self.lblCategories.text = userDict["topic_id"] as? String ?? ""
                    
                    self.lblRecordingTime.text = self.userDict["bio_duration"] as? String ?? ""
                    
                    
                    let username = self.userDict["username"] as? String ?? ""
                    
                    if username == ""{
                        
                        self.txtFeildUserName.isUserInteractionEnabled = true
                        
                        self.btnUserNameRef.isHidden = false
                        
                    }else{
                        self.txtFeildUserName.isUserInteractionEnabled = false
                        
                        self.btnUserNameRef.isHidden = true
                    }
                    
                    self.bioURLString = self.userDict["bio"] as? String ?? ""
                    
                    self.audioUrl = NSURL(string: self.userDict["bio"] as? String ?? "") as! URL
                    
                    
                    
                    let image = self.userDict["image"] as? String ?? ""
                    
                    self.imgViewProfile.sd_setImage(with: URL(string: image as? String ?? ""), placeholderImage: UIImage(named: "user_signup"))
                    
                    
                    
                }else{
                    
                    print(responseJson)
                    
                    Indicator.shared.hideProgressView()
                    
                   
                    
                    let message  = responseJson["message"].stringValue as? String ?? ""
                    
                    _ = SweetAlert().showAlert("Escalate", subTitle: message, style: AlertStyle.error)
                    
                    
                    
                    
                    //logout.LogoutWhenTokenExpires(tokenExpireMessage: message)
                    
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
    
    func editProfileAPI(){
        
         //let chosenImage = imgViewProfile.image ?? #imageLiteral(resourceName: "default_image")
        //    fullname:required
        //    phone:required
        //    email:required
        //    token:required
        //    image:
        //    bio:
        
        if UserDefaults.standard.value(forKey: "RECORDINGURL") != nil{
            
            
            
            let chosenImage = imgViewProfile.image ?? #imageLiteral(resourceName: "default_image")
            
            
            
            imageData = UIImageJPEGRepresentation(chosenImage, 0.5) as NSData!
            
            print("aman")
            
            print(imageData)
            
           
            
            
            audioUrl = NSURL(string: UserDefaults.standard.value(forKey: "RECORDINGURL") as? String ?? "") as! URL
            
            
            
            
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
            
            print(durationForApi)
            
            
            
            
            
            
            
            do {
                
                self.audioData = try Data(contentsOf: audioUrl)
                print("AUDIO DATA")
                print(self.audioData)
                print("AUDIO DATA")
                
            } catch {
                
                print("Unable to load data: \(error)")
                
            }
            
            
            
            let infoArray = UserDefaults.standard.value(forKey: "USERINFO") as? NSArray ?? []
            //print(infoArray)
            let infoDict = infoArray.object(at: 0) as? NSDictionary ?? [:]
            
            //print(infoDict)
            
            let token = infoDict.value(forKey: "token") as? String ?? ""
            
            print(token)
            
            let user_id = infoDict.value(forKey: "user_id") as? String ?? ""
            
            print(user_id)
            
            
            let passdict = ["fullname": txtFeildFullName.text!,
                            "phone":txtFeildPhone.text!,
                            "email":txtFieldEmail.text!,
                            "token":token,
                            "username":txtFeildUserName.text!,
                            "country_code":txtCountryCode.text!,
                            "bio_duration":durationForApi] as [String : Any]
            
            print(passdict)
            
            if InternetConnection.internetshared.isConnectedToNetwork() {
                
                Indicator.shared.showProgressView(self.view)
                
                
                WebserviceConnection.requWithFilewith2Data(imageData: imageData, audioData: audioData as NSData, fileName1: "image.jpg", fileName2: "recording.mp3", imageparam1: "image", imageparam2: "bio", urlString: "users/\(user_id)", parameters: passdict as [String : AnyObject], headers: nil, success: { (responseJson) in
                    
                    if responseJson["status"].stringValue == "SUCCESS" {
                        
                        Indicator.shared.hideProgressView()
                        print(responseJson)
                        
                        print("SUCCESFILL POST AUDIO")
                        
//
//                        Auth.auth().currentUser?.updateEmail(to: self.txtFieldEmail.text!) { error in
//                            if let error = error {
//                                print(error)
//                            }
//                            else {
//                               print("email updated")
//                            }
//                        }
                        
                        
                        
                        UserDefaults.standard.removeObject(forKey: "RECORDINGURL")
                        UserDefaults.standard.removeObject(forKey: "imageData")
                        
                        
                        _ = SweetAlert().showAlert("Escalate", subTitle: "Profile updated successfully.", style: AlertStyle.success)
                        
                        self.navigationController?.popViewController(animated: true)
                        
                        
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
                    
                }, failure: { (Error) in
                    Indicator.shared.hideProgressView()
                    
                    _ = SweetAlert().showAlert("Escalate", subTitle: "Something went wrong.Please try again!", style: AlertStyle.error)
                })
                
                
            }else{
                
                Indicator.shared.hideProgressView()
                _ = SweetAlert().showAlert("Escalate", subTitle: "No interter connection!", style: AlertStyle.error)
                
                
            }
            
            
            
        }else{
            
            
            //WHEN WE HAVE IMAGE
            
            if UserDefaults.standard.value(forKey: "imageData") != nil {
                
                let chosenImage = imgViewProfile.image ?? #imageLiteral(resourceName: "default_image")
                
                
                
                imageData = UIImageJPEGRepresentation(chosenImage, 0.5) as NSData!
                
                print("aman")
                
                print(imageData)
    
                
                let infoArray = UserDefaults.standard.value(forKey: "USERINFO") as? NSArray ?? []
                //print(infoArray)

                let infoDict = infoArray.object(at: 0) as? NSDictionary ?? [:]
                
                //print(infoDict)
                
                let token = infoDict.value(forKey: "token") as? String ?? ""
                
                print(token)
                
                let user_id = infoDict.value(forKey: "user_id") as? String ?? ""
                
                print(user_id)
                
                
                let passdict = ["fullname": txtFeildFullName.text!,
                                "phone":txtFeildPhone.text!,
                                "email":txtFieldEmail.text!,
                                "token":token,
                                "country_code":txtCountryCode.text!,
                                "username":txtFeildUserName.text!] as [String : Any]
                
                print(passdict)
                
                
                if InternetConnection.internetshared.isConnectedToNetwork() {
                    
                    Indicator.shared.showProgressView(self.view)
                    
                    WebserviceConnection.requWithFile(imageData: imageData, fileName: "image.jpg", imageparam: "image", urlString:"users/\(user_id)", parameters: passdict as [String : AnyObject], headers: nil, success: { (responseJson) in
                        
                        if responseJson["status"].stringValue == "SUCCESS" {
                            print(responseJson["status"])
                            
                            Indicator.shared.hideProgressView()
                            
                            print(responseJson)
                            
//                            Auth.auth().currentUser?.updateEmail(to: self.txtFieldEmail.text!) { error in
//                                if let error = error {
//                                    print(error)
//                                }
//                                else {
//                                    print("email updated")
//                                }
//                            }
                            
                            UserDefaults.standard.removeObject(forKey: "RECORDINGURL")
                            UserDefaults.standard.removeObject(forKey: "imageData")
                            
                            _ = SweetAlert().showAlert("Escalate", subTitle: "Profile updated successfully.", style: AlertStyle.success)
                            
                            self.navigationController?.popViewController(animated: true)
                            
                            
                            
                        }
                        else{
                            
                            print("FAIL")
                            
                            let message  = responseJson["message"].stringValue
                            
                            
                            print(responseJson)
                            Indicator.shared.hideProgressView()
                        
                            _ = SweetAlert().showAlert("Escalate", subTitle: message, style: AlertStyle.error)
                            
                            if message == "Login Token Expire"{
                                
                                let vc = self.storyboard?.instantiateViewController(withIdentifier: "LogInVC") as! LogInVC
                                
                                self.navigationController!.pushViewController(vc, animated: true)
                            }else{
                                
                                print("do Nothing")
                            }
                            
                            
                            if message == "Internal server error."{
                                
                                SweetAlert().showAlert("Escalate", subTitle: message, style: AlertStyle.none, buttonTitle:"OK") { (isOtherButton) -> Void in
                                    
                                    
                                }
                                
                            }else{
                                Indicator.shared.hideProgressView()
                                _ = SweetAlert().showAlert("Escalate", subTitle: message, style: AlertStyle.error)
                                
                            }
                            
                            
                            
                        }
                        
                        
                    }, failure: { (Error) in
                        
                        print("failure")
                        Indicator.shared.hideProgressView()                    //UserDefaults.standard.removeObject(forKey: "imageData")
                        
                        _ = SweetAlert().showAlert("Escalate", subTitle: "Something went wrong.Please try again!", style: AlertStyle.error)
                        
                        
                        
                    })
                    
                    
                }else{
                    Indicator.shared.hideProgressView()
                    
                    _ = SweetAlert().showAlert("Escalate", subTitle: "No interter connection!", style: AlertStyle.error)
                    
                    
                }
                
                
                
            }else{
                
                
                //WHEN WE HAVE DONT HAVE IMAGE
                
                let infoArray = UserDefaults.standard.value(forKey: "USERINFO") as? NSArray ?? []
                //print(infoArray)
                let infoDict = infoArray.object(at: 0) as? NSDictionary ?? [:]
                
                //print(infoDict)
                
                let token = infoDict.value(forKey: "token") as? String ?? ""
                
                print(token)
                
                let user_id = infoDict.value(forKey: "user_id") as? String ?? ""
                
                print(user_id)
                
                
                let passdict = ["fullname": txtFeildFullName.text!,
                                "phone":txtFeildPhone.text!,
                                "email":txtFieldEmail.text!,
                                "token":token,
                                "country_code":txtCountryCode.text!,
                                "username":txtFeildUserName.text!] as [String : Any]
                
                print(passdict)
                
                if InternetConnection.internetshared.isConnectedToNetwork() {
                    
                    Indicator.shared.showProgressView(self.view)
                    
                    WebserviceConnection.requestPOSTURL("users/\(user_id)", params: passdict as [String : AnyObject], headers:nil, success: { (responseJson) in
                        
                        if responseJson["status"].stringValue == "SUCCESS" {
                            print("SUCCCCCCCC")
                            Indicator.shared.hideProgressView()
                            
                            
//                            Auth.auth().currentUser?.updateEmail(to: self.txtFieldEmail.text!) { error in
//                                if let error = error {
//                                    print(error)
//                                }
//                                else {
//                                    print("email updated")
//                                }
//                            }
                            
                            UserDefaults.standard.removeObject(forKey: "RECORDINGURL")
                            UserDefaults.standard.removeObject(forKey: "imageData")
                            
                             _ = SweetAlert().showAlert("Escalate", subTitle: "Profile updated successfully.", style: AlertStyle.success)
                            
                            self.navigationController?.popViewController(animated: true)
                            
                        }else{
                            
                            print("FAIL")
                            
                            print(responseJson)
                            let message  = responseJson["message"].stringValue
                            UserDefaults.standard.removeObject(forKey: "imageData")
                            
                            Indicator.shared.hideProgressView()
                           

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
            
            
        }
        
    }
    
    
    
}


extension EditProfileVC:selectedCountry{
    
    func loadPlistDataatLoadTime() {
        
        // getting path to GameData.plist
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true) as NSArray
        let documentsDirectory = paths[0] as! NSString
        let path = documentsDirectory.appendingPathComponent("countryList.plist")
        let fileManager = FileManager.default
        //check if file exists
        if(!fileManager.fileExists(atPath: path)) {
            // If it doesn't, copy it from the default file in the Bundle
            if let bundlePath = Bundle.main.path(forResource: "countryList", ofType: "plist") {
                let rootArray = NSMutableArray(contentsOfFile: bundlePath)
                print("Bundle RecentSearch.plist file is --> \(rootArray?.description)")
                do{
                    try fileManager.copyItem(atPath: bundlePath, toPath: path)
                }
                catch _ {
                    print("Fail to copy")
                }
                print("copy")
            } else {
                print("RecentSearch.plist not found. Please, make sure it is part of the bundle.")
            }
        } else {
            print("RecentSearch.plist already exits at path.")
            // use this to delete file from documents directory
            //fileManager.removeItemAtPath(path, error: nil)
        }
        
        let rootarray = NSMutableArray(contentsOfFile: path)
        print("Loaded RecentSearch.plist file is --> \(rootarray?.description)")
        let array = NSMutableArray(contentsOfFile: path)
        print(array as Any) // Array of country code ,name
        if let dict = array {
            
            
            let tempArray = array!
            self.arrayFromPlist = tempArray
            var i = 0
            for index in tempArray{
                
                let dic = tempArray.object(at: i) as? NSDictionary
                i = i+1
                let code = dic?.object(forKey: "country_dialing_code") as? String
                
                let trimSring:String = code!.replacingOccurrences(of: " ", with: "")
                print(trimSring) // country code
                let countryName = dic?.object(forKey: "country_name") as? String
                let codeString = trimSring+" "+countryName!
                
                //   self.countryCodeArray.add(codeString)
                
            }
            
            //  print(self.countryCodeArray)
            
        } else {
            print("WARNING: Couldn't create dictionary from RecentSearch.plist! Default values will be used!")
        }
    }
    
    
    
    
    func countryInformation(info: NSDictionary) {
        
        print(info)
        let code = info.object(forKey: "country_dailing_code") as? String ?? ""
        txtCountryCode.text = code
        txtCountryCode.textColor = UIColor.black
        txtCountryCode.textAlignment = .center
        print(code)
        
    }
}

