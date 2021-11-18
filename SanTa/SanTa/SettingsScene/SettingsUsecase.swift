//
//  SettingsUsecase.swift
//  SanTa
//
//  Created by CHANGMIN OH on 2021/11/07.
//

import Foundation

protocol SettingsUsecase {
    func save<T: Codable>(value: T, key: Settings)
    func makeSettings() -> [[Option]]
}

final class DefaultSettingsUsecase: SettingsUsecase {
    
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
        var autoSettins: [Option] = []
        var voiceSettings: [Option] = []
        var mapSetting: [Option] = []
        
        self.settingsRepository.makeToggleOption(key: Settings.recordPhoto) { value in
            photoSettings.append(value)
        }
        self.settingsRepository.makeToggleOption(key: Settings.photosOnMap) { value in
            photoSettings.append(value)
        }
        self.settingsRepository.makeToggleOption(key: Settings.autoPauseResume) { value in
            autoSettins.append(value)
        }
        self.settingsRepository.makeToggleOption(key: Settings.autoPauseResumeVoiceGuidance) { value in
            autoSettins.append(value)
        }
        self.settingsRepository.makeToggleOption(key: Settings.voiceGuidanceEveryOnekm) { value in
            voiceSettings.append(value)
        }
        self.settingsRepository.makeMapOption(key: Settings.mapFormat) { value in
            mapSetting.append(value)
        }
        
        options.append(photoSettings)
        options.append(autoSettins)
        options.append(voiceSettings)
        options.append(mapSetting)
        
        return options
    }
}

