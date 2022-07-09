//
//  ViewController.swift
//  EggTimer
//
//  Created by Angela Yu on 08/07/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    let eggTimes = ["Soft": 300 , "Medium": 420, "Hard": 720]
    var timer = Timer()
    var totalTime = 0
    var secondsPassed = 0
    var player: AVAudioPlayer?
    var timerBar = Timer()
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var labelLike: UILabel!
    @IBAction func hardnessSelected(_ sender: UIButton) {

        timer.invalidate()
        let hardness = sender.currentTitle!
        totalTime = eggTimes[hardness]!
        progressBar.progress = 0
        secondsPassed = 0
        labelLike.text = hardness
        timeLabel.text = "\(String(format: "%02d", (totalTime / 60))) : \(String(format: "%02d", (totalTime % 60)))"
        
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateCounter), userInfo: nil, repeats: true)

    }
    
    @objc func updateCounter() {
        
        if secondsPassed < totalTime {

            progressBar.progress = Float(secondsPassed) / Float(totalTime)
            secondsPassed += 1
            
            timeLabel.text = "\(String(format: "%02d", (totalTime - secondsPassed) / 60)) : \(String(format: "%02d", (totalTime - secondsPassed) % 60))"
        } else {
            timer.invalidate()
            labelLike.text = "DONE!"
            progressBar.progress = 1
            playSound()
        }
    }
    
    func playSound() {
        guard let url = Bundle.main.url(forResource: "alarm_sound", withExtension: "mp3") else
        { return }
        
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
            
            player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)
            
            guard let player = player else {
                return
            }
            
            player.play()
            
        } catch let error {
            print(error.localizedDescription)
        }
    }

}
