//
//  SettingRepository.swift
//  SanTa
//
//  Created by CHANGMIN OH on 2021/11/07.
//

import Foundation

protocol SettingsRepository {
    func save<T: Codable>(value: T, key: Settings)
    func makeToggleOption(key: Settings, completion: @escaping (Option) -> Void)
    func makeMapOption(key: Settings, completion: @escaping (Option) -> Void)
}

final class DefaultSettingsRepository: SettingsRepository {
    
    let settingsStorage: UserDefaultsStorage
    
    init(settingsStorage: UserDefaultsStorage) {
        self.settingsStorage = settingsStorage
    }
    
    func save<T: Codable>(value: T, key: Settings) {
        self.settingsStorage.save(value: value, key: key)
    }
    
    func makeToggleOption(key: Settings, completion: @escaping (Option) -> Void) {
        self.settingsStorage.exist(key: key) { exist in
            if !exist {
                guard let value = key.initValue as? Bool else { return }
                self.settingsStorage.save(value: value, key: key)
            }
            self.settingsStorage.bool(key: key) { value in
                let option = ToggleOption(text: key.title, toggle: value)
                completion(option)
            }
        }
    }
    
    func makeMapOption(key: Settings, completion: @escaping (Option) -> Void) {
        self.settingsStorage.exist(key: key) { exist in
            if !exist {
                guard let value = key.initValue as? String else { return }
                self.settingsStorage.save(value: value, key: key)
            }
            self.settingsStorage.string(key: key) { value in
                guard let value = value else { return }
                guard let map = Map.init(rawValue: value) else { return }
                let option = MapOption(text: key.title, map: map)
                completion(option)
            }
        }
    }
}

