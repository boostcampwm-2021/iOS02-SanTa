//
//  UserDefaultSettingsStorage.swift
//  SanTa
//
//  Created by CHANGMIN OH on 2021/11/06.
//

import Foundation

protocol UserDefaultsStorage {
    func save<T: Codable>(value: T, key: Settings)
    func exist(key: Settings) -> Bool
    func bool(key: Settings, completion: @escaping (Bool) -> Void)
    func string(key: Settings, completion: @escaping (String?) -> Void)
}

final class DefaultUserDefaultsStorage: UserDefaultsStorage {
    
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
    
    func bool(key: Settings, completion: @escaping (Bool) -> Void) {
        completion(self.userDefaults.bool(forKey: key.title))
    }
    
    func string(key: Settings, completion: @escaping (String?) -> Void) {
        completion(self.userDefaults.string(forKey: key.title))
    }
    
    func makeFirstData() {
        if !self.exist(key: .recordPhoto) {
            self.save(value: Settings.recordPhoto.initValue as? Bool,
                      key: .recordPhoto)
        }
        if !self.exist(key: .photosOnMap) {
            self.save(value: Settings.photosOnMap.initValue as? Bool,
                      key: .photosOnMap)
        }
        if !self.exist(key: .autoPauseResume) {
            self.save(value: Settings.autoPauseResume.initValue as? Bool,
                      key: .autoPauseResume)
        }
        if !self.exist(key: .autoPauseResumeVoiceGuidance) {
            self.save(value: Settings.autoPauseResumeVoiceGuidance.initValue as? Bool,
                      key: .autoPauseResumeVoiceGuidance)
        }
        if !self.exist(key: .voiceGuidanceEveryOnekm) {
            self.save(value: Settings.voiceGuidanceEveryOnekm.initValue as? Bool,
                      key: .voiceGuidanceEveryOnekm)
        }
        if !self.exist(key: .mapFormat) {
            self.save(value: Settings.mapFormat.initValue as? String,
                      key: .mapFormat)
        }
        if !self.exist(key: .markHikingTrailsOnTheMap) {
            self.save(value: Settings.markHikingTrailsOnTheMap.initValue as? Bool,
                      key: .markHikingTrailsOnTheMap)
        }
    }
}
