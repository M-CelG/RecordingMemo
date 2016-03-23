//
//  PlaySoundsViewController.swift
//  
//
//  Created by Manish Sharma on 6/18/15.
//
//

import UIKit
import AVFoundation

class PlaySoundsViewController: UIViewController {
   

    @IBOutlet weak var stopButton: UIButton!
    
    var receivedAudio: RecordedAudio!
    var audioPlayer: AVAudioPlayer!
    var audioEngine: AVAudioEngine!
    var audioFile: AVAudioFile!


    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        audioPlayer = try? AVAudioPlayer(contentsOfURL: receivedAudio.filePathURL)
        audioEngine = AVAudioEngine()
        audioFile = try? AVAudioFile(forReading: receivedAudio.filePathURL)    
    }
    
    override func viewWillAppear(animated: Bool) {
        stopButton.enabled = false
        audioPlayer.enableRate = true
        audioPlayer.prepareToPlay()
    }
    
    //Function to use Audio Engine with rate change
    func player(){
        playerStop()
        audioPlayer.play()
        audioPlayer.currentTime = 0.0
        stopButton.enabled = true
    }
    
    //Function to reset Audio Engine
    func playerStop(){
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
    }
    
    @IBAction func playChipmuckAudio(sender: UIButton) {
        playAudioWithVariablePitch(1000)
    }
    
    @IBAction func playDarthVaderAudio(sender: UIButton) {
        playAudioWithVariablePitch(-1000)
    }
    
    func playAudioWithVariablePitch (pitch: Float) {
        playerStop()
        
        let audioPlayerNode = AVAudioPlayerNode()
        let changePitchEffect = AVAudioUnitTimePitch()
        changePitchEffect.pitch = pitch
        audioEngine.attachNode(audioPlayerNode)
        audioEngine.attachNode(changePitchEffect)
        
        audioEngine.connect(audioPlayerNode, to: changePitchEffect, format: nil)
        audioEngine.connect(changePitchEffect, to: audioEngine.outputNode, format: nil)
    
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        do {
            try audioEngine.start()
        } catch _ {
        }
        

        audioPlayerNode.play()
        stopButton.enabled = true
    }
    
    @IBAction func playSlowAudio(sender: UIButton) {
        audioPlayer.rate = 0.5
        player()
    }

    @IBAction func playFastAudio(sender: UIButton) {
        audioPlayer.rate = 1.5
        player()
    }
        
    @IBAction func stopAudio(sender: UIButton) {
        playerStop()
        stopButton.enabled = false
    }
}
