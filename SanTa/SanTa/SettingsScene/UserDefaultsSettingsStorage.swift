//
//  UserDefaultSettingsStorage.swift
//  SanTa
//
//  Created by CHANGMIN OH on 2021/11/06.
//

import Foundation

protocol SettingsStorage {
    func save<T: Codable>(value: T, key: Settings)
    func exist(key: Settings, completion: @escaping (Bool) -> Void)
    func bool(key: Settings, completion: @escaping (Bool) -> Void)
    func string(key: Settings, completion: @escaping (String?) -> Void)
}

final class UserDefaultsSettingsStorage: SettingsStorage {
    
    let userDefaults: UserDefaults
    
    init(useuserDefaults: UserDefaults = UserDefaults.standard) {
        self.userDefaults = useuserDefaults
    }
    
    func save<T: Codable>(value: T, key: Settings) {
        self.userDefaults.set(value, forKey: key.title)
    }
    
    func exist(key: Settings, completion: @escaping (Bool) -> Void) {
        completion(self.userDefaults.object(forKey: key.title) != nil)
    }
    
    func bool(key: Settings, completion: @escaping (Bool) -> Void) {
        completion(self.userDefaults.bool(forKey: key.title))
    }
    
    func string(key: Settings, completion: @escaping (String?) -> Void) {
        completion(self.userDefaults.string(forKey: key.title))
    }
}
