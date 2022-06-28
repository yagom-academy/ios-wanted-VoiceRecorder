//
//  VoiceMemoRecordViewController.swift
//  VoiceRecorder
//
//  Created by 이다훈 on 2022/06/28.
//

import UIKit

class VoiceMemoRecordViewController: UIViewController {
    
    // - MARK: UI init
    
    let waveView: UIView = {
        let view = UIView.init(frame: CGRect.init(origin: CGPoint.init(), size: CGSize.init(width: 100, height: 100)))
        view.backgroundColor = .systemGray2
        return view
    }()
    
    let cutoffLabel: UILabel = {
        let label = UILabel()
        label.text = "cutoff freq"
        return label
    }()
    
    // 뭔지 모르겠네,, 컷오프를 정하는건지 재생시간을 표기한건지
    let idonknowSilder: UISlider = {
        return UISlider()
    }()
    
    let playTimeLabel: UILabel = {
        let label = UILabel()
        label.text = "Play Time"
        return label
    }()
    
    let playOrPauseButton: UIButton = {
        let size = CGRect.init(origin: CGPoint(), size: CGSize.init(width: 30, height: 30))
        let button = UIButton.init(frame: size)
        
        button.setImage(UIImage.init(systemName: "play"), for: .normal)
        button.setImage(UIImage.init(systemName: "pause.fill"), for: .selected)
        return button
    }()
    
    let recordButton: UIButton = {
        let size = CGRect.init(origin: CGPoint(), size: CGSize.init(width: 30, height: 30))
        let button = UIButton.init(frame: size)
        
        button.backgroundColor = .systemRed
        button.setImage(UIImage.init(systemName: "circle.fill"), for: .normal)
        button.setImage(UIImage.init(systemName: "stop.fill"), for: .selected)
        return button
    }()
    
    // - MARK: LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        designateUIs()
    }
    
    private func configure() {
        self.view.backgroundColor = .white
    }
    
    // - MARK: UI Design
    
    private func designateUIs() {
        designateWaveView()
        designateCutOffLabel()
        designateSlider()
        designatePlayTimeLabel()
        designateButtons()
    }
    
    private func designateWaveView() {
        self.view.addSubview(waveView)
        waveView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            waveView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: view.frame.height * 0.1),
            waveView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            waveView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            waveView.heightAnchor.constraint(equalToConstant: 100)
        ])
    }
    
    private func designateCutOffLabel() {
        self.view.addSubview(cutoffLabel)
        cutoffLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            cutoffLabel.topAnchor.constraint(equalTo: waveView.safeAreaLayoutGuide.bottomAnchor, constant: 30),
            cutoffLabel.leadingAnchor.constraint(equalTo: waveView.safeAreaLayoutGuide.leadingAnchor),
            cutoffLabel.trailingAnchor.constraint(equalTo: waveView.safeAreaLayoutGuide.trailingAnchor),
            
            cutoffLabel.heightAnchor.constraint(equalToConstant: 20)
        ])
    }
    
    private func designateSlider() {
        self.view.addSubview(idonknowSilder)
        idonknowSilder.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            idonknowSilder.topAnchor.constraint(equalTo: cutoffLabel.safeAreaLayoutGuide.bottomAnchor, constant: 16),
            idonknowSilder.leadingAnchor.constraint(equalTo: cutoffLabel.safeAreaLayoutGuide.leadingAnchor),
            idonknowSilder.trailingAnchor.constraint(equalTo: cutoffLabel.safeAreaLayoutGuide.trailingAnchor)
        ])
    }
    
    private func designatePlayTimeLabel() {
        self.view.addSubview(playTimeLabel)
        playTimeLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            playTimeLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            playTimeLabel.topAnchor.constraint(equalTo: idonknowSilder.safeAreaLayoutGuide.bottomAnchor, constant: 8),
            
            playTimeLabel.heightAnchor.constraint(equalToConstant: 20)
        ])
    }
    
    private func designateButtons() {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        self.view.addSubview(stackView)
        stackView.addArrangedSubview(recordButton)
        stackView.addArrangedSubview(playOrPauseButton)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo:playTimeLabel.safeAreaLayoutGuide.bottomAnchor, constant: 20),
            stackView.leadingAnchor.constraint(equalTo: idonknowSilder.safeAreaLayoutGuide.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: idonknowSilder.safeAreaLayoutGuide.trailingAnchor)
        ])
    }
}

