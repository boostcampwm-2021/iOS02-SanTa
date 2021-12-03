//
//  SettingsUsecase.swift
//  SanTa
//
//  Created by CHANGMIN OH on 2021/11/07.
//

import Foundation
import Photos

final class SettingsUsecase {
    private let settingsRepository: SettingsRepository

    init(settingsRepository: SettingsRepository) {
        self.settingsRepository = settingsRepository
    }

    func save<T: Codable>(value: T, key: Settings) {
        self.settingsRepository.save(value: value, key: key)
    }

    func photoPermission(completion: @escaping (Bool) -> Void) {
        let photoPermission = PHPhotoLibrary.authorizationStatus(for: .readWrite)
        switch photoPermission {
        case .authorized:
            completion(true)
        default:
            completion(false)
        }
    }

    func makeSettings() -> [Option] {
        var options: [Option] = []

        self.settingsRepository.makeToggleOption(key: Settings.recordPhoto) { value in
            options.append(value)
        }
        self.settingsRepository.makeToggleOption(key: Settings.voiceGuidanceEveryOnekm) { value in
            options.append(value)
        }
        self.settingsRepository.makeMapOption(key: Settings.mapFormat) { value in
            options.append(value)
        }

        return options
    }
}
