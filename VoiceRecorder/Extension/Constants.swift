//
//  Constants.swift
//  VoiceRecorder
//
//  Created by 이경민 on 2022/07/07.
//

import Foundation

struct Constants {
    struct TableViewCellIdentifier {
        static let home = String(describing: HomeTableViewCell.self)
    }
    
    struct AlertActionTitle {
        static let cancel = "취소"
        static let ok = "확인"
        static let empty = ""
    }
    
    struct AlertControllerTitle {
        static let microphoneRequest = "설정에서 마이크 권한을 허용해주세요."
        static let recordFileRemove = "녹음파일 삭제"
    }
    
    struct Firebase {
        static let foloderName = "voiceRecords"
        static let fileType = ".mp4"
    }
    
    struct ButtonSize {
        static let regular = 32.0
    }
    
    struct VolumeSliderSize {
        static let half: Float = 0.5
    }
}
