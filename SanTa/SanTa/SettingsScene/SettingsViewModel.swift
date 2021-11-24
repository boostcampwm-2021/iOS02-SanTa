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
    let isPhotoRecordAvailable = PassthroughSubject<Bool, Never>()
    
    var sectionCount: Int {
        return settings.count
    }
    
    init(settingsUseCase: SettingsUsecase) {
        self.settingsUseCase = settingsUseCase
    }
    
    func viewDidLoad() {
        self.reloadSettings()
    }
    
    func viewWillAppear() {
        self.settingsUseCase.photoPermission { [weak self] bool in
            if !bool {
                self?.settingsUseCase.save(value: false, key: .recordPhoto)
                self?.reloadSettings()
            }
        }
    }
    
    func option(indexPath: IndexPath) -> Option {
        return settings[indexPath.section][indexPath.item]
    }
    
    func change<T: Codable>(value: T, key: Settings) {
        self.settingsUseCase.save(value: value, key: key)
        if value is String {
            self.reloadSettings()
            return
        }
        if key == Settings.recordPhoto {
            self.settingsUseCase.photoPermission { bool in
                self.isPhotoRecordAvailable.send(bool)
                if !bool {
                    self.settingsUseCase.save(value: false, key: .recordPhoto)
                }
            }
        }
    }
    
    private func reloadSettings() {
        self.settings = self.settingsUseCase.makeSettings()
    }
}
