//
//  EditBioVC.swift
//  Escalate
//
//  Created by call soft on 20/07/18.
//  Copyright © 2018 call soft. All rights reserved.
//

import UIKit
import AVFoundation
import Pulsator



class EditBioVC: UIViewController, AVAudioRecorderDelegate, AVAudioPlayerDelegate {
    
    
    
    //MARK:- OUTLETS
    //MARK:
    
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
    
    //******Variables for 40 timer
    
    var count = 39
    var timerLimit:Timer?
    
    
    //MARK:- VIEW LIFE CYCLE METHODS
    //MARK:
   
    
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
//    
    
    //MARK:- METHODS
    //MARK:
    
   
    func initialSetUp(){
        
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(EditBioVC.stopRecordingAndPlaying(_:)), name: NSNotification.Name(rawValue: "stopRecordingAndPlaying"), object: nil)
        
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
            
            
//             _ = SweetAlert().showAlert("Escalate", subTitle: "Recording limit(40 sec) reached!", style: AlertStyle.warning)
            
             NotificationCenter.default.post(name: NSNotification.Name(rawValue: "resetLabel"), object: nil)
            self.navigationController?.popViewController(animated: true)
            
            
        }
        else
        {
            display_alert(msg_title: "Error", msg_desc: "Recording failed.", action_title: "OK")
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
    
    func stopRecordings(){
        
        if(isRecording)
        {
            
            
            print("TIMERCOUNT")
            print(count)
            timerLimit?.invalidate()
            timerLimit = nil
            count = 39
            let sec = 0
            let hr = 0
            let min = 0
            
            lblInstructions.text = "tap to record"
            
            let totalTimeString = String(format: "%02d:%02d",min, sec)
            recordingTimeLabel.text = totalTimeString
            pulsator.stop()
            
            audioRecorder.stop()
            audioRecorder = nil
            meterTimer.invalidate()
            
            //finishAudioRecording(success: true)
            isRecording = false
            
        }
        
    }
    
    
    
    
    
    
    
    
    
    
    
    
    @objc func stopRecordingAndPlaying(_ notification: Notification) {
        stopRecordings()
        UserDefaults.standard.removeObject(forKey: "RECORDINGURL")
        
        
    }
    
    
    
    
    @IBAction func start_recording(_ sender: UIButton)
    {
        if(isRecording)
        {
            pulsator.stop()
            lblInstructions.text = "tap to record"
            
            print("TIMERCOUNT")
            print(count)
            timerLimit?.invalidate()
            timerLimit = nil
            
            finishAudioRecording(success: true)
            isRecording = false
        }
        else
        {
            
            setup_recorder()
            countDownTimet()
            lblInstructions.text = "tap to stop"
            audioRecorder.record()
            meterTimer = Timer.scheduledTimer(timeInterval: 0.1, target:self, selector:#selector(self.updateAudioMeter(timer:)), userInfo:nil, repeats:true)
            addHalo()
            
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
            count = 39
            
            let sec = 0
            let hr = 0
            let min = 0
            
            
            
            lblInstructions.text = "tap to record"
            
            let totalTimeString = String(format: "%02d:%02d",min, sec)
            recordingTimeLabel.text = totalTimeString
            pulsator.stop()
            finishAudioRecording(success: true)
            _ = SweetAlert().showAlert("Escalate", subTitle: "Recording limit(40 sec) reached!", style: AlertStyle.warning)

            
           
            
            
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
            lblInstructions.text = "tap to record"
            audioRecorder.stop()
            audioRecorder = nil
            meterTimer.invalidate()
            timerLimit?.invalidate()
            timerLimit = nil
            count = 39
   
        }
        UserDefaults.standard.removeObject(forKey: "RECORDINGURL")
         NotificationCenter.default.post(name: NSNotification.Name(rawValue: "resetLabel"), object: nil)
        self.navigationController?.popViewController(animated: true)
    }
    
    
    
    func prepare_play()
    {
        do
        {
            audioPlayer = try AVAudioPlayer(contentsOf: getFileUrl())
            audioPlayer.delegate = self
            audioPlayer.prepareToPlay()
        }
        catch{
            print("Error")
        }
    }
    
    @IBAction func play_recording(_ sender: Any)
    {
        if(isPlaying)
        {
            audioPlayer.stop()
            lblInstructions.text = "tap to record"
            record_btn_ref.isEnabled = true
            //play_btn_ref.setTitle("Play", for: .normal)
            isPlaying = false
        }
        else
        {
            if FileManager.default.fileExists(atPath: getFileUrl().path)
            {
                record_btn_ref.isEnabled = false
                //play_btn_ref.setTitle("pause", for: .normal)
                lblInstructions.text = "tap to stop"
                prepare_play()
                audioPlayer.play()
                isPlaying = true
            }
            else
            {
                display_alert(msg_title: "Error", msg_desc: "Bio not recorded yet!", action_title: "OK")
            }
        }
    }
    
}
