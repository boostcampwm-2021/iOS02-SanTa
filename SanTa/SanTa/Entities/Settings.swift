//
//  Settings.swift
//  SanTa
//
//  Created by CHANGMIN OH on 2021/11/08.
//

import Foundation

enum Settings: String, CaseIterable {
    case recordPhoto = "사진 기록하기"
    case voiceGuidanceEveryOnekm = "1킬로미터 마다 음성 안내"
    case mapFormat = "지도 형식"

    var title: String {
        return self.rawValue
    }

    var initValue: Any {
        switch self {
        case .recordPhoto:
            return true
        case .voiceGuidanceEveryOnekm:
            return true
        case .mapFormat:
            return "정보지도"
        }
    }
}
