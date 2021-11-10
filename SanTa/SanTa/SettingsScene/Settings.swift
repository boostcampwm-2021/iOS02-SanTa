//
//  Settings.swift
//  SanTa
//
//  Created by CHANGMIN OH on 2021/11/08.
//

import Foundation

enum Settings: String, CaseIterable {
    case recordPhoto = "사진 기록하기"
    case photosOnMap = "지도에 사진표시"
    case autoPauseResume = "자동 일시정지, 재시작"
    case autoPauseResumeVoiceGuidance = "자동 일시정지, 재시작 음성 안내"
    case voiceGuidanceEveryOnekm = "1킬로미터 마다 음성 안내"
    case mapFormat = "지도 형식"
    case markHikingTrailsOnTheMap = "지도에 등산로 표시"
    
    var title: String {
        return self.rawValue
    }
    
    var initValue: Any {
        switch self {
        case .recordPhoto:
            return true
        case .photosOnMap:
            return true
        case .autoPauseResume:
            return false
        case .autoPauseResumeVoiceGuidance:
            return false
        case .voiceGuidanceEveryOnekm:
            return true
        case .mapFormat:
            return "정보지도"
        case .markHikingTrailsOnTheMap:
            return true
        }
    }
}
