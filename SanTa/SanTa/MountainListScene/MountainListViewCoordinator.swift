//
//  MountainListViewCoordinator.swift
//  SanTa
//
//  Created by shin jae ung on 2021/11/01.
//

import UIKit

class MountainListViewCoordinator: Coordinator {
    weak var parentCoordinator: Coordinator?
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController

    init() {
        self.navigationController = UINavigationController()
    }
    
    func start() {
    }

    func startPush() -> UINavigationController {
        let mountainListViewController = MountainListViewController()
        mountainListViewController.coordinator = self
        self.navigationController.setViewControllers([mountainListViewController], animated: true)
        self.navigationController.navigationBar.topItem?.title = "산 목록"

        return navigationController
    }
}
