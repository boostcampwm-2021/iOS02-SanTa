//
//  UserDefaultSettingsStorage.swift
//  SanTa
//
//  Created by CHANGMIN OH on 2021/11/06.
//

import Foundation

protocol SettingsStorage {
    func save<T: Codable>(value: T, key: Settings)
    func exist(key: Settings) -> Bool
    func bool(key: Settings) -> Bool
    func string(key: Settings) -> String?
}

final class UserDefaultsSettingsStorage: SettingsStorage {
    
    let userDefaults: UserDefaults
    
    init(useuserDefaults: UserDefaults = UserDefaults.standard) {
        self.userDefaults = useuserDefaults
    }
    
    func save<T: Codable>(value: T, key: Settings) {
        self.userDefaults.set(value, forKey: key.title)
    }
    
    func exist(key: Settings) -> Bool {
        return self.userDefaults.object(forKey: key.title) != nil
    }
    
    func bool(key: Settings) -> Bool {
        return self.userDefaults.bool(forKey: key.title)
    }
    
    func string(key: Settings) -> String? {
        return self.userDefaults.string(forKey: key.title)
    }
}


enum Settings: String {
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
}
