//
//  ResultViewCoordinator.swift
//  SanTa
//
//  Created by shin jae ung on 2021/11/01.
//

import UIKit

class ResultViewCoordinator: Coordinator {
    weak var parentCoordinator: Coordinator?
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController

    init() {
        self.navigationController = UINavigationController()
    }
    
    func start() {
    }

    func startPush() -> UINavigationController {
        let resultViewController = ResultViewController()
        resultViewController.coordinator = self
        navigationController.setViewControllers([resultViewController], animated: true)

        return navigationController
    }
}
