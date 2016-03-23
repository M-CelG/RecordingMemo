//
//  RecordSoundsViewController.swift
//  Recording Memo
//
//  Created by Manish Sharma on 6/18/15.
//  Copyright (c) 2015 CelG Mobile LLC. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {

    var audioRecorder: AVAudioRecorder!
    var recordedAudio: RecordedAudio!
    
    @IBOutlet weak var recordingInProgress: UILabel!
    
    @IBOutlet weak var recordingButton: UIButton!
    
    @IBOutlet weak var stopButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        stopButton.hidden = true
        recordingButton.enabled = true
        updateLabel()
    }
    
    func updateLabel() {
        if (recordingButton.enabled == true) {
            self.recordingInProgress.text = "Tap To Record"
        } else {
            self.recordingInProgress.text = "recording"
        }
    }

    @IBAction func recordingAudio(sender: UIButton) {
        stopButton.hidden = false
        recordingButton.enabled = false
        updateLabel()
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] 
        let recordingName = "my_audio.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = NSURL.fileURLWithPathComponents(pathArray)
        let recordSettings = [
            AVFormatIDKey : Int(kAudioFormatLinearPCM),
            AVSampleRateKey : 44100.0,
            AVNumberOfChannelsKey : 2,
            AVEncoderBitRateKey : 12800,
            AVLinearPCMBitDepthKey : 16,
            AVEncoderAudioQualityKey : AVAudioQuality.Max.rawValue
        ]
        
        let session = AVAudioSession.sharedInstance()
        do {
            try session.setCategory(AVAudioSessionCategoryPlayAndRecord)
        } catch _ {
        }
        do {
            audioRecorder = try AVAudioRecorder(URL: filePath!, settings: recordSettings as! [String : AnyObject])
        } catch _{
            print("error during audioRecorder initization")
            return
        }
        
        audioRecorder.delegate = self
        audioRecorder.meteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }

    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder, successfully flag: Bool) {
        if (flag){
            // Save the recorded audio
            recordedAudio = RecordedAudio(title: recorder.url.lastPathComponent!, filePathURL: recorder.url)
            // move to next screen
            self.performSegueWithIdentifier("StopRecording", sender: recordedAudio)
        } else {
            recordingButton.enabled = true
            stopButton.hidden = true
            updateLabel()
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "StopRecording") {
            let playSoundsVC: PlaySoundsViewController = segue.destinationViewController as! PlaySoundsViewController
            let data = sender as! RecordedAudio
            playSoundsVC.receivedAudio = data
        }
    }
    
    @IBAction func stopRecording(sender: UIButton) {
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setActive(false)
        } catch _ {
        }
    }
}

