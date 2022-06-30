//
//  Recorder.swift
//  VoiceRecorder
//
//  Created by 백유정 on 2022/06/30.
//

import Foundation
import AVFoundation

protocol Recording {
    func resumeRecording() throws
    func pauseRecording()
    func stopRecording()
}

class Recorder {
    enum RecordingState {
        case record
        case pause
        case stop
    }
    
    private var engine: AVAudioEngine!
    private var mixerNode: AVAudioMixerNode!
    //private var EQNode: AVAudioUnitEQ!
    private var state: RecordingState = .stop
    
    init() {
        setupSession()
        setupEngine()
    }
}

extension Recorder {
    
    /// 오디오세션 셋업
    fileprivate func setupSession() {
        let session = AVAudioSession.sharedInstance()
        
        do {
            try session.setCategory(.playAndRecord)
            try session.setActive(true, options: .notifyOthersOnDeactivation)
        } catch {
            print("[ERROR]")
        }
    }
    
    /// 오디오 엔진 셋업
    fileprivate func setupEngine() {
        engine = AVAudioEngine()
        mixerNode = AVAudioMixerNode()
        
        mixerNode.volume = 0 // 레코딩 준비를 위해 볼륨을 0으로 변경
        engine.attach(mixerNode)
        
        makeConnection()
        
        engine.prepare()
    }
    
    /// 노드를 엔진에 연결
    fileprivate func makeConnection() {
        let inputNode = engine.inputNode
        let inputFormat = inputNode.outputFormat(forBus: 0)
        
        engine.connect(inputNode, to: mixerNode, format: inputFormat)
        
        let mixerFormat = AVAudioFormat(commonFormat: .pcmFormatInt32, sampleRate: inputFormat.sampleRate, channels: 1, interleaved: false)
        
        engine.connect(mixerNode, to: engine.mainMixerNode, format: mixerFormat)
    }
    
    
    func setupFrequency() {
        //EQNode = AVAudioUnitEQ.init()
        
        //let filerParams: AVAudioUnitEQFilterParameters!
        //filerParams = AVAudioUnitEQFilterParameters()
        
        //filerParams.frequency
    }
    
    /// 녹음을 실행
    fileprivate func startRecording() throws {
        let tapNode: AVAudioNode = mixerNode
        let format = tapNode.outputFormat(forBus: 0)
        
        let documentURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let file = try AVAudioFile(forWriting: documentURL.appendingPathComponent("recording.caf"), settings: format.settings)
        
        tapNode.installTap(onBus: 0, bufferSize: 4096, format: format) { buffer, time in
            try? file.write(from: buffer)
        }
        
        // 엔진을 실행
        try engine.start()
        
        state = .record
    }
}

extension Recorder: Recording {
    
    func resumeRecording() throws {
        try engine.start()
        state = .record
    }
    
    func pauseRecording() {
        engine.pause()
        state = .pause
    }
    
    func stopRecording() {
        mixerNode.removeTap(onBus: 0)
        engine.stop()
        state = .stop
    }
}
