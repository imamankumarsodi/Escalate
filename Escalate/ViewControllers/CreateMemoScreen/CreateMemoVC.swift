//
//  CreateMemoVC.swift
//  Escalate
//
//  Created by call soft on 20/07/18.
//  Copyright © 2018 call soft. All rights reserved.
//

import UIKit
import AVFoundation
import Pulsator
import DropDown
import RSSelectionMenu


class CreateMemoVC: UIViewController,AVAudioRecorderDelegate, AVAudioPlayerDelegate,UITextViewDelegate {
    
    
    
    //MARK:- OUTLETS
    //MARK:
    
    @IBOutlet weak var lblInstructions: UILabel!
    
    @IBOutlet weak var txtFeildDescription: UITextView!
    
    @IBOutlet weak var txtFeildCategory: UITextField!
    
    @IBOutlet weak var sourceView: UIView!
    @IBOutlet var recordingTimeLabel: UILabel!
    @IBOutlet var record_btn_ref: UIButton!
    @IBOutlet weak var viewCategoriesDropDown: UIView!
    
    @IBOutlet weak var txtfldCategoies: UITextField!
    
    
    //MARK:- VARIABLES
    //MARK:
    
    
    
    
    var audioRecorder: AVAudioRecorder!
    var audioPlayer : AVAudioPlayer!
    var meterTimer:Timer!
    var isAudioRecordingGranted: Bool!
    var isRecording = false
    var isPlaying = false
    let pulsator = Pulsator()
    let categoryDropdown = DropDown()

    
    
    var categoriesArray = [String]()
    
    var categoriesIDArray = [String]()
    
    var categoriesDataArray = [String]()
    
    var choosenIndex = String()
    let validation:Validation = Validation.validationManager() as! Validation
    
    let WebserviceConnection  = AlmofireWrapper()
    
    var user_id = ""
    
  
    
    
    
    //****variables for locations
    

    
    var lat = ""
    var log = ""
    
    
    
    //******Variables for 40 timer
    
      var count = 39
        var timerLimit:Timer?
 
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //txtfldCategoies.text = ""
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
    
    override func viewWillDisappear(_ animated: Bool) {
        
        
        stopRecordings()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        count = 39
        isRecording = false
        if timerLimit != nil {

            timerLimit?.invalidate()
            timerLimit = nil

        }
        
        recordingTimeLabel.text = "00:00"
        
        
        
       // self.txtFeildDescription.text = "Write Your Descrioption and Tags..."
        
        self.txtFeildDescription.textColor = UIColor.lightGray
        
        
        txtFeildDescription.delegate = self
        

        stopRecordings()
        
        }
    
    
    
//    override func viewWillAppear(_ animated: Bool) {
//        count = 60
//        IsStartrecording = false
//        if timer != nil {
//
//            timer?.invalidate()
//            timer = nil
//
//        }
//
//        tabBarController?.tabBar.isHidden =  false
//        secondsCount = 0
//
//        lblTimer.text = "00:0\(secondsCount)"
//
//        if DidTappedGallary ==  true {
//
//            let vc  = storyboard?.instantiateViewController(withIdentifier: "PlayVideoVC") as! PlayVideoVC
//            vc.videoURL = video_url
//            self.navigationController?.pushViewController(vc, animated: true)
//            DidTappedGallary = false
//
//        }
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
                    
                    
                    
                    
                    self.currentLocationAPI()
                    
                    
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
    
    
    

    
    
    //NSAttributedStringKey.font: UIFont(name: "HelveticaNeue-Bold", size: 17)!
    
    
    
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
    
    
    
    
    
    //MARK: ACTIONS
    //MARK:-
    
    
    
    
    @objc func stopRecordingAndPlaying(_ notification: Notification) {
        
        
     stopRecordings()
        
        
    }
    
    
    @objc func resetUI(_ notification: Notification) {
        
   
        
        
    }
    
    
    
    @IBAction func btnCategoriesTapped(_ sender: Any) {
        
        
        categoriesList()
        
        
//        self.categoryDropdown.anchorView = viewCategoriesDropDown
//
//        categoryDropdown.dataSource = categoriesArray as! [String]
//
//        categoryDropdown.selectionAction = { [unowned self] (index: Int, item: String) in
//
//
//            self.txtfldCategoies.text = item
//            self.choosenIndex = self.categoriesIDArray.object(at: index) as! String
//
//            print(self.choosenIndex )
//
//
//
//
//
//
//        }
//
//        categoryDropdown.show()
        
        
    }
    
    
    
    
    func initialSetUp(){
        
        
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(CreateMemoVC.resetUI(_:)), name: NSNotification.Name(rawValue: "resetUI"), object: nil)
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(CreateMemoVC.stopRecordingAndPlaying(_:)), name: NSNotification.Name(rawValue: "stopRecordingAndPlaying"), object: nil)
        
         //AccessCurrentLocationuser()
        self.txtFeildDescription.text = "Write Your Description and Tags..."
        
        self.txtFeildDescription.textColor = UIColor.lightGray
        
        
        txtFeildDescription.delegate = self
        check_record_permission()
       
    }
    
    
    func addHalo() {
        
        pulsator.position = .init(x: 75, y: 75)
        pulsator.numPulse = 5
        pulsator.radius = 100
        
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

        }
        
    }
    
    
    
  
    
    
    //MARK:- WEB SERVICES
    //MARK:
    
    func currentLocationAPI() {
        
        
        let infoArray = UserDefaults.standard.value(forKey: "USERINFO") as? NSArray ?? []
        //print(infoArray)
        let infoDict = infoArray.object(at: 0) as? NSDictionary ?? [:]
        
        //print(infoDict)
        
        user_id = infoDict.value(forKey: "user_id") as? String ?? ""
        
        //print(user_id)
        
        
        
        let passDict = ["lat":"00.00",
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
    
    

    //MARK:- ACTIONS
    //MARK:
    
    @IBAction func btnFilterTapped(_ sender: Any) {
        
        stopRecordings()
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "OtherProfileFilterVC") as! OtherProfileFilterVC
        self.navigationController?.present(vc, animated: false, completion: nil)
        
    }
    
    
    @IBAction func btnChatTapped(_ sender: Any) {
        stopRecordings()
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ChatRepliesVC") as! ChatRepliesVC
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    
    //MARK:- ACTIONS
    //MARK:
    
    
    
    @IBAction func start_recording(_ sender: UIButton)
    {
        
        
        if(isRecording)
        {

            let sec = 0
            let hr = 0
            let min = 0

            
            
            print("TIMERCOUNT")
            print(count)
            timerLimit?.invalidate()
            timerLimit = nil


            lblInstructions.text = "tap to record"

            let totalTimeString = String(format: "%02d:%02d", min, sec)
            recordingTimeLabel.text = totalTimeString
            pulsator.stop()
            finishAudioRecording(success: true)
            isRecording = false
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "PostCreatedMemoVC") as! PostCreatedMemoVC
            //            vc.txtFeildCategory.text = self.txtFeildCategory.text ?? ""
            //            vc.txtFeildDescription.text = self.txtFeildDescription.text ?? ""
            vc.audioUrl = getFileUrl()

            vc.choosenCategories = txtFeildCategory.text!

            vc.descriptionText = txtFeildDescription.text!

            self.navigationController?.pushViewController(vc, animated: false)
        }
        else
        {
            
            countDownTimet()
            
            isRecording = true
            
            meterTimer = Timer.scheduledTimer(timeInterval: 0.1, target:self, selector:#selector(self.updateAudioMeter(timer:)), userInfo:nil, repeats:true)
            addHalo()

            setup_recorder()

            lblInstructions.text = "tap to stop"

            audioRecorder.record()

            


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
            
            let min = 0


            
            lblInstructions.text = "tap to record"

            let totalTimeString = String(format: "%02d:%02d", min, sec)
            recordingTimeLabel.text = totalTimeString
            pulsator.stop()
            finishAudioRecording(success: true)
            isRecording = false
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "PostCreatedMemoVC") as! PostCreatedMemoVC
            //            vc.txtFeildCategory.text = self.txtFeildCategory.text ?? ""
            //            vc.txtFeildDescription.text = self.txtFeildDescription.text ?? ""
            vc.audioUrl = getFileUrl()

            vc.choosenCategories = txtFeildCategory.text!

            vc.descriptionText = txtFeildDescription.text!

            self.navigationController?.pushViewController(vc, animated: false)


            
        }
    }
    
    
    
    
    
    
    
    
    
    @objc func updateAudioMeter(timer: Timer)
    {
//        if count > 0{
        
        if audioRecorder.isRecording
        {
            let hr = Int((audioRecorder.currentTime / 60) / 60)
            let min = Int(audioRecorder.currentTime / 60)
            let sec = Int(audioRecorder.currentTime.truncatingRemainder(dividingBy: 60))
            let totalTimeString = String(format: "%02d:%02d", min, sec)
            recordingTimeLabel.text = totalTimeString
            audioRecorder.updateMeters()
            //count -= 1
        }
            
//        }else{
//            print("40 seconds ho  gaye")
//        }

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
