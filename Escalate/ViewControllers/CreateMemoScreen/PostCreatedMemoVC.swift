//
//  PostCreatedMemoVC.swift
//  Escalate
//
//  Created by abc on 04/08/18.
//  Copyright © 2018 call soft. All rights reserved.
//

import UIKit
import AVFoundation
import SwiftSiriWaveformView
import DropDown
import RSSelectionMenu

class PostCreatedMemoVC: UIViewController,AVAudioRecorderDelegate, AVAudioPlayerDelegate,UITextViewDelegate {
    
    
    //MARK:- OUTLETS
    //MARK:
    
    @IBOutlet weak var lblRecordingTime: UILabel!
    
    @IBOutlet weak var txtFeildDescription: UITextView!
    @IBOutlet weak var txtFeildCategory: UITextField!
    @IBOutlet var btnPlayRef: UIButton!
    @IBOutlet weak var audioView: SwiftSiriWaveformView!
    @IBOutlet weak var viewCategoriesDropDown: UIView!

    
    
    //MARK:- VARIABLES
    //MARK:
    
    
    let categoryDropdown = DropDown()
    
    var categoriesArray = [String]()
    
    var categoriesIDArray = [String]()
    
    var categoriesDataArray = [String]()
    
    var choosenIndex = String()
    
    let validation:Validation = Validation.validationManager() as! Validation
    
    
    var audioData = Data()
    
    let WebserviceConnection  = AlmofireWrapper()
    
    var isPlaying = false
    
    var audioPlayer : AVAudioPlayer!
    
    var audioUrl: URL!
    
    
    var timer1:Timer?
    
    var change:CGFloat = 0.01
    
    var timerCount1:Timer?
    
    var secCount = 0
    
    var count = 0
    
    var hr = 0
    
    var min = 0
    
    var sec = 0
    
    var durationForApi = ""
    
    
    var choosenCategories = ""
    
    var descriptionText = ""
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetUp()
        self.tabBarController?.tabBar.isHidden = false

        // Do any additional setup after loading the view.
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
//    override var prefersStatusBarHidden: Bool {
//        return true
//    }
    
    
    //MARK:- METHODS
    //MARK:
    
    
    
    
    //MARK: To search from Speciality
    
    func showAsMultiSelectPopover() {
        
        let selectionMenu = RSSelectionMenu(selectionType: .Single, dataSource: self.categoriesArray, cellType: .SubTitle) { (cell, name, indexPath) in
            
            cell.textLabel?.text = name
            
        }
        
        
        // selected items
        
        selectionMenu.setSelectedItems(items: categoriesDataArray) { (text, selected, selectedList) in
            
            // update list
            self.categoriesDataArray = selectedList
            
            self.txtFeildCategory.text = selectedList.joined(separator: ", ")
            
            let selected_name = self.txtFeildCategory.text
            
            let indexofSelectedName  =  self.categoriesArray.index(of: selected_name!)
            
            self.choosenIndex  =  self.categoriesIDArray[indexofSelectedName!]
            
        }
        
        // search bar
        selectionMenu.showSearchBar { (searchText) -> ([String]) in
            return self.categoriesArray.filter({ $0.lowercased().starts(with: searchText.lowercased()) })
        }
        
        selectionMenu.show(style: .Present, from: self)
        
    }
    
    
    
    
    
    
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        let string:NSMutableAttributedString = NSMutableAttributedString(string: txtFeildDescription.text)
        let words:[String] = txtFeildDescription.text.components(separatedBy:" ")
        
        for word in words {
            if (word.hasPrefix("#")) {
                let range:NSRange = (string.string as NSString).range(of: word)
                string.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor.init(red: 76/255, green: 40/255, blue: 107/255, alpha: 1), range: range)
                
                  string.addAttribute(NSAttributedStringKey.font, value: UIFont(name: "SegoeUI-SemiBold", size: 15)!, range: range)
                txtFeildDescription.attributedText = string
            }}
        return true
    }
    
    
    
    
    
    //MARK: UITextViewDelegate delegate
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        if(self.txtFeildDescription == textView){
            
            self.txtFeildDescription.text = nil
            
            self.txtFeildDescription.textColor = UIColor.black
            
        }
        
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        
        if(self.txtFeildDescription == textView){
            
            if self.txtFeildDescription.text.isEmpty {
                
                self.txtFeildDescription.text = "Write Your Description and Tags..."
                
                self.txtFeildDescription.textColor = UIColor.lightGray
            }
            
            
        }
        
    }
    
    
    
    func updatedBioAudio(){
        

        if(isPlaying)
        {
            audioPlayer.stop()
            
            timerCount1?.invalidate()
            timerCount1 = nil
            timer1?.invalidate()
            timer1 = nil
            sec = 0
            hr = 0
            min = 0
            btnPlayRef.setImage(UIImage(named: "create_memo_play"),for: .normal)
            btnPlayRef.setTitle(" tap to play", for: .normal)
            isPlaying = false
            audioView.amplitude = 0.0
            setTimerLabel()
        }
        else
        {
            if FileManager.default.fileExists(atPath: (audioUrl?.path)!)
            {
                
                btnPlayRef.setImage(UIImage(named: "create_memo_pause"),for: .normal)
                btnPlayRef.setTitle(" tap to stop", for: .normal)
                
                let asset = AVAsset(url: audioUrl)
                
                let duration = asset.duration
                let durationTime = CMTimeGetSeconds(duration)
                durationForApi = String(round(durationTime))
                count = Int(round(durationTime))
                
                countDownTimet()
                timer1 = Timer.scheduledTimer(timeInterval: 0.009, target: self, selector: #selector(self.refreshAudioView(_:)), userInfo: nil, repeats: true)
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
    
    
    
    
    
    func validationSetup()->Void{
        
        
        
        var message = ""
        
        //var tempString = txtFeildMail.text ?? ""
        
        
        if !validation.validateBlankField(txtFeildCategory.text!){
            message = "Please select category"
            
        }else if !validation.validateBlankField(txtFeildDescription.text!){
            
            message = "Please enter description"
        }
        
        
        
        if message != "" {
            
            
            _ = SweetAlert().showAlert("Escalate", subTitle: message, style: AlertStyle.error)
            
        }else{
            
            self.sendVoicePost()
            
        }
        
        
    }
    
    
    
    //COUNTER FOR WAVE AND AUDIO TIME
    
    func countDownTimet(){
        
        timerCount1 = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.update), userInfo: nil, repeats: true)
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
            count = sec
            timer1?.invalidate()
            timer1 = nil
            timerCount1?.invalidate()
            timerCount1 = nil
            
            sec = 0
            
    
            setTimerLabel()
            
            btnPlayRef.setImage(UIImage(named: "create_memo_play"),for: .normal)
            btnPlayRef.setTitle(" tap to play",for: .normal)
            
            audioView.amplitude = 0.0
            isPlaying = false
            //STOP PLAYING AND ANIMATION
            
            
        }
    }
    
    
    func categoriesList(){
        
        
        
        
        
        if InternetConnection.internetshared.isConnectedToNetwork() {
            
            Indicator.shared.showProgressView(self.view)
            
            WebserviceConnection.requestGETURL("genre_list", success: { (responseJson) in
                
                if responseJson["status"].stringValue == "SUCCESS" {
                    
                    Indicator.shared.hideProgressView()
                    
                    print(responseJson)
                    
                    
                    
                    let array =  responseJson["data"].arrayObject as? NSArray ?? []
                    
                    if array.count > 0 {
                        
                        self.categoriesArray.removeAll()
                        self.categoriesIDArray.removeAll()
                        
                    }
                    
                    let categoryArray:NSMutableArray = array.mutableCopy() as! NSMutableArray
                    
                    
                    print("SUCCESS")
                    
                    for  i in (0..<categoryArray.count)
                    {
                        let temdict  =  categoryArray.object(at: i) as! NSDictionary
                        
                        let category_name  = temdict.value(forKey: "name") as! String
                        let categoryID = temdict.value(forKey: "topic_id") as! String
                        
                        
                        
                        self.categoriesArray.append(category_name)
                        self.categoriesIDArray.append(categoryID)
                        
                        
                        
                    }
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    print("categoryArray")
                    
                    print(self.categoriesIDArray)
                    print(self.categoriesIDArray)
                    
                    print("categoryArray")
                    
                    if self.categoriesIDArray.count == 0 {
                        
                        _ = SweetAlert().showAlert("Escalate", subTitle: "No Categories Found!", style: AlertStyle.none)
                        
                    }else{
                        
                        self.showAsMultiSelectPopover()
                    }
                    
                    
                    
                
                    
                    
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
                
                _ = SweetAlert().showAlert("ESCALATE", subTitle: "Something went wrong.Please try again!", style: AlertStyle.error)
                Indicator.shared.hideProgressView()
                
                
            })
            
            
        }else{
            
            _ = SweetAlert().showAlert("ESCALATE", subTitle: "No interter connection!", style: AlertStyle.error)
            Indicator.shared.hideProgressView()
            
        }
        
        
        
    }
    
    func sendVoicePost(){
        
        
        if(isPlaying){
            audioPlayer.stop()
            
        }
        
        timerCount1?.invalidate()
        timerCount1 = nil
        timer1?.invalidate()
        timer1 = nil
        sec = 0
        hr = 0
        min = 0
        audioView.amplitude = 0.0
        
        btnPlayRef.setImage(UIImage(named: "create_memo_play"),for: .normal)
        
        btnPlayRef.setTitle(" tap to play", for: .normal)
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
        
        
        let description = txtFeildDescription.text!.replacingOccurrences(of: ",", with: " ", options: .literal, range: nil)
        print(description)

        
        
        let passDict = ["topic_name":txtFeildCategory.text!,
                        "user_id":user_id,
                        "description":description,
                        "token":token,
                        "duration":durationForApi] as [String : AnyObject]
        
        print(passDict)
        
        if InternetConnection.internetshared.isConnectedToNetwork() {
            
            Indicator.shared.showProgressView(self.view)
            
            
            WebserviceConnection.requWithAudioFile(audioData: audioData as NSData, fileName: "recording.mp3", audioparam: "audio", urlString: "audio", parameters: passDict, headers: nil, success:{ (responseJson) in
            
                
                if responseJson["status"].stringValue == "SUCCESS" {
                    
                    Indicator.shared.hideProgressView()
                    
                    print(responseJson["status"])
                    print(responseJson)
                    
                     _ = SweetAlert().showAlert("Escalate", subTitle: "Post uploaded successfully.", style: AlertStyle.success)
                    
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "TabBarVC") as! TabBarVC
                    self.navigationController?.pushViewController(vc, animated: true)
                    
                  
                    
                    
                    
                    
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
        
        timerCount1?.invalidate()
        timerCount1 = nil
        timer1?.invalidate()
        timer1 = nil
        sec = 0
        hr = 0
        min = 0
        audioView.amplitude = 0.0
        
        btnPlayRef.setImage(UIImage(named: "create_memo_play"),for: .normal)
        isPlaying = false
        
        
        
        let totalTimeString = String(format: "%02d:%02d", min, sec)
        lblRecordingTime.text = totalTimeString
        
        
        
    }
    
    
    @objc internal func refreshAudioView(_:Timer) {
        if self.audioView.amplitude <= self.audioView.idleAmplitude || self.audioView.amplitude > 1.0 {
            self.change *= -1.0
        }
        
        
        // Simply set the amplitude to whatever you need and the view will update itself.
        self.audioView.amplitude += self.change
    }
    
    
    
    
    
    @IBAction func play_recording(_ sender: Any)
    {
        
            updatedBioAudio()
   
    }
    
    
    
    
    
    
    @IBAction func btnBackTapped(_ sender: Any) {

            if(isPlaying){
                audioPlayer.stop()
     
            }
   
        timerCount1?.invalidate()
        timerCount1 = nil
        timer1?.invalidate()
        timer1 = nil
        sec = 0
        hr = 0
        min = 0
        audioView.amplitude = 0.0
        
        btnPlayRef.setImage(UIImage(named: "create_memo_play"),for: .normal)
        isPlaying = false
        
        
        
        let totalTimeString = String(format: "%02d:%02d", min, sec)
        lblRecordingTime.text = totalTimeString
        

         NotificationCenter.default.post(name: NSNotification.Name(rawValue: "resetUI"), object: nil)
        
        self.navigationController?.popViewController(animated: false)
        
        
    }
    
    
    @IBAction func btnCategoriesTapped(_ sender: Any) {
        
        
         categoriesList()
//
//        self.categoryDropdown.anchorView = viewCategoriesDropDown
//
//        categoryDropdown.dataSource = categoriesArray as! [String]
//
//        categoryDropdown.selectionAction = { [unowned self] (index: Int, item: String) in
//
//
//            self.txtFeildCategory.text = item
//            self.choosenIndex = self.categoriesIDArray.object(at: index) as! String
//
//            print(self.choosenIndex )
//
//
//
//        }
//
//        categoryDropdown.show()
        
        
    }
    
    @IBAction func btnPostTapped(_ sender: Any) {
        
        validationSetup()
    }
    
    
    
    func initialSetUp(){
        
        
        
        
      setTimerLabel()
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(PostCreatedMemoVC.stopRecordingAndPlaying(_:)), name: NSNotification.Name(rawValue: "stopRecordingAndPlaying"), object: nil)
        
        
        
//        self.txtFeildDescription.text = "Write Your Descrioption and Tags..."
//
//        self.txtFeildDescription.textColor = UIColor.lightGray
        
        
        
        
        txtFeildDescription.text = descriptionText
        txtFeildCategory.text = choosenCategories
        
        if txtFeildDescription.text == "Write Your Description and Tags..."{
            
            self.txtFeildDescription.textColor = UIColor.lightGray
        }
        
        let string:NSMutableAttributedString = NSMutableAttributedString(string: txtFeildDescription.text)
        let words:[String] = txtFeildDescription.text.components(separatedBy:" ")
        
        for word in words {
            if (word.hasPrefix("#")) {
                let range:NSRange = (string.string as NSString).range(of: word)
                string.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor.init(red: 76/255, green: 40/255, blue: 107/255, alpha: 1), range: range)
                
                  string.addAttribute(NSAttributedStringKey.font, value: UIFont(name: "SegoeUI-SemiBold", size: 15)!, range: range)
                txtFeildDescription.attributedText = string
            }}
        
        
        txtFeildDescription.delegate = self
        
        //categoriesList()
    }
    

   

}
