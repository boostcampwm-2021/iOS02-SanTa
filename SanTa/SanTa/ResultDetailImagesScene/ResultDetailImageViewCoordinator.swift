//
//  ResultDetailImageCoordinator.swift
//  SanTa
//
//  Created by 김민창 on 2021/11/23.
//

import UIKit

class ResultDetailImagesViewCoordinator: Coordinator {
    weak var parentCoordinator: Coordinator?
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    
    func start() {
        let resultDetailImagesViewController = ResultDetailImagesViewController()
        resultDetailImagesViewController.coordinator = self
        self.navigationController.setNavigationBarHidden(true, animated: false)
        self.navigationController.pushViewController(resultDetailImagesViewController, animated: true)
    }
    
    func dismiss() {
        self.navigationController.popViewController(animated: true)
        self.parentCoordinator?.childCoordinators.removeLast()
    }
    
    init(navigationController: UINavigationController, coreDataStorage: CoreDataStorage, records: Records) {
        self.navigationController = navigationController
    }
}
