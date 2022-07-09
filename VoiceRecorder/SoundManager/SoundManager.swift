//
//  SoundManager.swift
//  VoiceRecorder
//
//  Created by 신의연 on 2022/06/29.
//


import AVKit
import Accelerate

//TODO: - pitch enum 선언 필요

enum PitchVariable: Int {
    case middle = 0
    case row = -150
    case high = 150
}

enum PlayerType {
    case playBack
    case record
}
enum EdgeType {
    case start
    case end
}

protocol RecordingVisualizerable {
    func processAudioBuffer(buffer: AVAudioPCMBuffer)
    
}

protocol PlaybackVisualizerable {
    func operatingwaveProgression(progress: Float)
}

protocol SoundManagerStatusReceivable {
    func audioPlayerCurrentStatus(isPlaying: Bool)
    func audioFileInitializeErrorHandler(error: Error)
    func audioEngineInitializeErrorHandler(error: Error)
}

class SoundManager {
    
    // TODO: - play와 record의 프로퍼티 struct로 만들어서 관리
    
    var delegate: SoundManagerStatusReceivable?
    var recordVisualizerDelegate: RecordingVisualizerable!
    var playBackVisualizerDelegate: PlaybackVisualizerable!
    
    var isEnginePrepared = false
    private var isPlaying = false
    private var needFileSchedule = true
    
    private var fileUrl: URL!
    private var audioFile: AVAudioFile!
    
    private let engine = AVAudioEngine()
    private lazy var inputNode = engine.inputNode
    private let mixerNode = AVAudioMixerNode()
    
    var frequency: Float = 40000
    private let eqNode = AVAudioUnitEQ(numberOfBands: 1)
    private lazy var eqFilterParameters: AVAudioUnitEQFilterParameters = eqNode.bands[0] as AVAudioUnitEQFilterParameters
    
    private let playerNode = AVAudioPlayerNode()
    private let pitchControl = AVAudioUnitTimePitch()
    
    private var audioSampleRate: Double = 0
    private var audioPlayDuration: Double = 0
    private var seekFrame: AVAudioFramePosition = 0
    private var currentPosition: AVAudioFramePosition = 0
    private var audioLengthSamples: AVAudioFramePosition = 0
    
    private var currentFrame: AVAudioFramePosition {
        guard
            let lastRenderTime = playerNode.lastRenderTime,
            let playerTime = playerNode.playerTime(forNodeTime: lastRenderTime)
        else {
            return 0
        }
        return playerTime.sampleTime
    }
    
    // MARK: - initialize SoundManager
    func initializeSoundManager(url: URL, type: PlayerType) {
        do {
            engine.reset()
            playerNode.reset()
            fileUrl = url
            // 모델 밖에서 생성 후 주입
            if type == .playBack {
                
                let file = try AVAudioFile(forReading: url)
                let fileFormat = file.processingFormat
                
                audioLengthSamples = file.length
                audioSampleRate = fileFormat.sampleRate
                audioPlayDuration = Double(audioLengthSamples) / audioSampleRate
                
                audioFile = file
                configurePlayEngine(format: fileFormat)
                
            } else {
                configureRecordEngine()
            }
        } catch let error as NSError {
            print("파일 초기화 에러")
            delegate?.audioFileInitializeErrorHandler(error: error)
        }
    }
    
    // MARK: - Set Engine
    private func configurePlayEngine(format: AVAudioFormat) {
        
        engine.reset()
        engine.attach(playerNode)
        engine.attach(pitchControl)
        
        engine.connect(playerNode, to: pitchControl, format: engine.mainMixerNode.outputFormat(forBus: 0))
        engine.connect(pitchControl, to: engine.mainMixerNode, format: engine.mainMixerNode.outputFormat(forBus: 0))
        
        engine.prepare()
        isEnginePrepared = true
        
        do {
            try engine.start()
        } catch let e as NSError {
            delegate?.audioEngineInitializeErrorHandler(error: e)
        }
    }
    
    
    // MARK: - configure PlayerNode
    private func schedulePlayerNode() {
        guard let file = audioFile, needFileSchedule else {
            return
        }
        needFileSchedule = false
        seekFrame = 0
        
        playerNode.scheduleFile(file, at: nil) { [self] in
            self.needFileSchedule = true
        }
        
        playerNode.installTap(onBus: 0, bufferSize: 1024, format: playerNode.outputFormat(forBus: 0)) { [unowned self] buffer, time in
            guard var currentPosition = getCurrentFrame(lastRenderTime: time) else { return }
            
            currentPosition = specifyFrameStandard(frame: currentFrame + seekFrame, length: audioLengthSamples)
            
            playBackVisualizerDelegate.operatingwaveProgression(progress: Float(currentPosition)/Float(audioLengthSamples))
            
            if currentPosition >= audioLengthSamples {
                resetPlayer(edge: .end)
                delegate?.audioPlayerCurrentStatus(isPlaying: isPlaying)
            }
        }
    }
    
    private func getCurrentFrame(lastRenderTime: AVAudioTime) -> AVAudioFramePosition? {
        guard let playerTime = playerNode.playerTime(forNodeTime: lastRenderTime) else { return nil }
        return playerTime.sampleTime
    }
    
    private func specifyFrameStandard(frame: AVAudioFramePosition, length: AVAudioFramePosition) -> AVAudioFramePosition {
        var convertedFrame = frame
        
        convertedFrame = max(frame, 0)
        convertedFrame = min(frame, length)
        
        return convertedFrame
    }
    
    func playNpause() {
        print(isPlaying)
        if isPlaying {
            playerNode.pause()
        } else {
            if needFileSchedule {
                schedulePlayerNode()
            }
            playerNode.play()
        }
        
        isPlaying.toggle()
    }
    
    func skip(isForwards: Bool) {
        let timeToSeek: Double
        
        if isForwards {
            timeToSeek = 5
        } else {
            timeToSeek = -5
        }
        
        seek(to: timeToSeek)
    }
    
    private func seek(to time: Double) {
        guard let audioFile = audioFile else { return }
        
        let offset = AVAudioFramePosition(time * audioSampleRate)
        seekFrame = currentPosition + offset
        currentPosition = specifyFrameStandard(frame: seekFrame, length: audioLengthSamples)
        
        let wasPlaying = playerNode.isPlaying
        
        playerNode.stop()
        
        if currentPosition < 0 {
            resetPlayer(edge: .start)
            playerNode.scheduleFile(audioFile, at: nil)
            if wasPlaying {
                playerNode.play()
            } else {
                isPlaying = false
            }
            
        } else if currentPosition < audioLengthSamples {
            
            needFileSchedule = false
            
            let frameCount = AVAudioFrameCount(audioLengthSamples - seekFrame)
            
            playerNode.scheduleSegment(
                audioFile,
                startingFrame: seekFrame,
                frameCount: frameCount,
                at: nil
            ) {
                self.needFileSchedule = true
            }
            if wasPlaying {
                playerNode.play()
            }
            
        } else {
            playBackVisualizerDelegate.operatingwaveProgression(progress: 0)
            resetPlayer(edge: .end)
            delegate?.audioPlayerCurrentStatus(isPlaying: isPlaying)
        }
    }
    
    private func resetPlayer(edge: EdgeType) {
        seekFrame = 0
        currentPosition = 0
        
        switch edge {
        case .start:
            needFileSchedule = false
            isPlaying = true
        case .end:
            needFileSchedule = true
            isPlaying = false
        }
    }
    
    func stop() {
        playerNode.stop()
        resetPlayer(edge: .end)
    }
    
    func removeTap() {
        playerNode.removeTap(onBus: 0)
    }
    
    func changePitchValue(value: PitchVariable) {
        self.pitchControl.pitch = Float(value.rawValue * 2)
    }
    
    func changeVolume(value: Float) {
        self.playerNode.volume = value * 2
    }
    
    func changeProgressValue(value: Float) {
        self.seek(to: Double(value))
    }
    
}

extension SoundManager {
    
    // MARK: - Set Engine
    func configureRecordEngine() {
        let format = inputNode.outputFormat(forBus: 0)
        mixerNode.volume = 0
        
        engine.attach(mixerNode)
        engine.attach(eqNode)
        
        engine.connect(inputNode, to: eqNode, format: format)
        engine.connect(eqNode, to: mixerNode, format: format)
    }
    
    
    private func createAudioFile(filePath: URL) throws -> AVAudioFile {
        let format = inputNode.outputFormat(forBus: 0)
        return try AVAudioFile(forWriting: filePath, settings: format.settings)
    }
    
    func getAudioFile(filePath: URL) throws -> AVAudioFile {
        return try AVAudioFile(forReading: filePath)
    }
    
    private func setFrequency() {
        eqFilterParameters.filterType = .bandPass
        eqFilterParameters.bypass = false
        eqFilterParameters.frequency = frequency
    }
    
    func startRecord() {
        isEnginePrepared = true
        
        let format = inputNode.outputFormat(forBus: 0)
        
        do {
            audioFile = try createAudioFile(filePath: fileUrl)
        } catch {
            fatalError()
        }
        
        mixerNode.installTap(onBus: 0, bufferSize: 4096, format: format) { buffer, time in
            do {
                self.setFrequency()
                try self.audioFile.write(from: buffer)
                self.recordVisualizerDelegate.processAudioBuffer(buffer: buffer)
            } catch {
                print("[error] : startRecord")
            }
        }
        
        do {
            try engine.start()
        } catch {
            fatalError()
        }
    }
    
    func stopRecord() {
        mixerNode.removeTap(onBus: 0)
        engine.stop()
        isEnginePrepared = false
    }
}

extension SoundManager {
    
    func totalPlayTime(audioFile: AVAudioFile) -> Double {
       
        let length = audioFile.length
        let sampleRate = audioFile.processingFormat.sampleRate
        let audioPlayTime = Double(length) / sampleRate
        
        return audioPlayTime
    }
    
}
