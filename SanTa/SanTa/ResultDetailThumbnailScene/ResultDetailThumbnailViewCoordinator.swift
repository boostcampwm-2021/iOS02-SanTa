//
//  ResultDetailThumbnailCoordinator.swift
//  SanTa
//
//  Created by 김민창 on 2021/11/24.
//

import UIKit

class ResultDetailThumbnailViewCoordinator: Coordinator {
    weak var parentCoordinator: Coordinator?
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    
    let uiImages: [String: UIImage]
    
    func start() {
        let resultDetailThumbnailViewController = ResultDetailThumbnailViewController()
        resultDetailThumbnailViewController.uiImages = self.uiImages
        resultDetailThumbnailViewController.coordinator = self
        self.navigationController.pushViewController(resultDetailThumbnailViewController, animated: true)
    }
    
    func dismiss() {
        self.parentCoordinator?.childCoordinators.removeLast()
    }
    
    init(navigationController: UINavigationController, uiImages: [String: UIImage]) {
        self.navigationController = navigationController
        self.uiImages = uiImages
    }
}
