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

    func start() {
    }

    func startPush() -> SettingsViewController {
        let settingsViewController = SettingsViewController()
        settingsViewController.coordinator = self

        return settingsViewController
    }
}
