//
//  AudioPlayerHandler.swift
//  VoiceRecorder
//
//  Created by CHUBBY on 2022/06/30.
//

import Foundation
import AVFoundation

class AudioPlayerHandler {
    
    var audioPlayer = AVAudioPlayer()
    var localFileHandler: LocalFileProtocol
    var updateTimeInterval: UpdateTimer
    
    init(handler: LocalFileProtocol, updateTimeInterval: UpdateTimer) {
        self.localFileHandler = handler
        self.updateTimeInterval = updateTimeInterval
    }
    
    func prepareToPlay() {
        do {
            let recordFileName = localFileHandler.makeFileName()
            let recordFileURL = localFileHandler.localFileURL.appendingPathComponent(recordFileName)
            let audioPlayer = try AVAudioPlayer(contentsOf: recordFileURL)
            self.audioPlayer = audioPlayer
            self.audioPlayer.prepareToPlay()
        } catch let error {
            print("Error : setUpPlayer - \(error)")
        }
    }
    
    func startPlay() {
        self.audioPlayer.play()
    }
    
    func pausePlay() {
        self.audioPlayer.pause()
    }
    
    func updateTimer(_ time: TimeInterval) -> String {
        return updateTimeInterval.updateTimer(time)
    }
}
