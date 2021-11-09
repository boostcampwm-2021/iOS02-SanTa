//
//  File.swift
//  SanTa
//
//  Created by CHANGMIN OH on 2021/11/07.
//

import Foundation
import Combine

final class SettingsViewModel {
    
    @Published var settings: [[Option]] = []
    
    let settingsUseCase: SettingsUsecase
    
    var sectionCount: Int {
        return settings.count
    }
    
    init(settingsUseCase: SettingsUsecase) {
        self.settingsUseCase = settingsUseCase
    }
    
    func viewDidLoad() {
        self.reloadSettings()
    }
    
    func change<T: Codable>(value: T, key: Settings) {
        self.settingsUseCase.save(value: value, key: key)
        if value is String {
            self.reloadSettings()
        }
    }
    
    private func reloadSettings() {
        self.settings = self.settingsUseCase.makeSettings()
    }
}
