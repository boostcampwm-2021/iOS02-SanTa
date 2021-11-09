//
//  SettingsViewCoordinator.swift
//  SanTa
//
//  Created by shin jae ung on 2021/11/01.
//

import UIKit

class SettingsViewCoordinator: Coordinator {
    weak var parentCoordinator: Coordinator?
    var childCoordinator: [Coordinator] = []

    func start() {
        
    }

    func startPush() -> SettingsViewController {
        let settingsViewController = injectDependencies()
        settingsViewController.coordinator = self

        return settingsViewController
    }
}

extension SettingsViewCoordinator {
    private func injectDependencies() -> SettingsViewController {
        let repository = DefaultSettingsRepository(settingsStorage: DefaultUserDefaultsStorage.shared)
        let usecase = DefaultSettingsUsecase(settingsRepository: repository)
        let viewModel = SettingsViewModel(settingsUseCase: usecase)
        let viewController = SettingsViewController(viewModel: viewModel)
        return viewController
    }
}
