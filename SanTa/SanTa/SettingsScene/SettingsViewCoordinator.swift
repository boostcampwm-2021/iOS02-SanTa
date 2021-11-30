//
//  SettingsViewCoordinator.swift
//  SanTa
//
//  Created by shin jae ung on 2021/11/01.
//

import UIKit

class SettingsViewCoordinator: Coordinator {
    weak var parentCoordinator: Coordinator?
    var childCoordinators: [Coordinator] = []

    private var userDefaultsStorage: UserDefaultsStorage

    init(userDefaultsStorage: UserDefaultsStorage) {
        self.userDefaultsStorage = userDefaultsStorage
    }

    func start() {

    }

    func startPush() -> SettingsViewController {
        let settingsViewController = SettingsViewController(viewModel: injectDependencies())
        settingsViewController.coordinator = self

        return settingsViewController
    }
}

extension SettingsViewCoordinator {
    private func injectDependencies() -> SettingsViewModel {
        return SettingsViewModel(
            settingsUseCase: SettingsUsecase(
                settingsRepository: DefaultSettingsRepository(
                    settingsStorage: self.userDefaultsStorage
                )
            )
        )
    }
}
