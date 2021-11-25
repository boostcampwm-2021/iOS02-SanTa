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
    
    let uiImages: [String: UIImage]
    
    func start() {
        let resultDetailImagesViewController = ResultDetailImagesViewController()
        resultDetailImagesViewController.uiImages = self.uiImages
        resultDetailImagesViewController.coordinator = self
        self.navigationController.pushViewController(resultDetailImagesViewController, animated: true)
    }
    
    func dismiss() {
        self.parentCoordinator?.childCoordinators.removeLast()
    }
    
    init(navigationController: UINavigationController, uiImages: [String: UIImage]) {
        self.navigationController = navigationController
        self.uiImages = uiImages
    }
}

extension ResultDetailImagesViewCoordinator {
    func presentResultDetailThumbnailViewController(uiImages: [String: UIImage], id: String) {
        let resultDetailThumbnailViewCoordinator = ResultDetailThumbnailViewCoordinator(navigationController: navigationController, uiImages: uiImages, id: id)
        self.childCoordinators.append(resultDetailThumbnailViewCoordinator)
        resultDetailThumbnailViewCoordinator.parentCoordinator = self
        
        resultDetailThumbnailViewCoordinator.start()
    }
}
