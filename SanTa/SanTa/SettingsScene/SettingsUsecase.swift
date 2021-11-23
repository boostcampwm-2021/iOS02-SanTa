//
//  SettingsUsecase.swift
//  SanTa
//
//  Created by CHANGMIN OH on 2021/11/07.
//

import Foundation

final class SettingsUsecase {
    
    let settingsRepository: SettingsRepository
    
    init(settingsRepository: SettingsRepository) {
        self.settingsRepository = settingsRepository
    }
    
    func save<T: Codable>(value: T, key: Settings) {
        self.settingsRepository.save(value: value, key: key)
    }
    
    func makeSettings() -> [[Option]] {
        var options: [[Option]] = []
        var photoSettings: [Option] = []
        var voiceSettings: [Option] = []
        var mapSetting: [Option] = []
        
        self.settingsRepository.makeToggleOption(key: Settings.recordPhoto) { value in
            photoSettings.append(value)
        }
        self.settingsRepository.makeToggleOption(key: Settings.photosOnMap) { value in
            photoSettings.append(value)
        }
        self.settingsRepository.makeToggleOption(key: Settings.voiceGuidanceEveryOnekm) { value in
            voiceSettings.append(value)
        }
        self.settingsRepository.makeMapOption(key: Settings.mapFormat) { value in
            mapSetting.append(value)
        }
        
        options.append(photoSettings)
        options.append(voiceSettings)
        options.append(mapSetting)
        
        return options
    }
}

