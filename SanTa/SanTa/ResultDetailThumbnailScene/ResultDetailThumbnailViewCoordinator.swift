//
//  ResultDetailThumbnailCoordinator.swift
//  SanTa
//
//  Created by 김민창 on 2021/11/24.
//

import UIKit

final class ResultDetailThumbnailViewCoordinator: Coordinator {
    weak var parentCoordinator: Coordinator?
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController

    let uiImages: [String: UIImage]
    let id: String

    func start() {
        let resultDetailThumbnailViewController = ResultDetailThumbnailViewController()
        resultDetailThumbnailViewController.uiImages = self.uiImages
        resultDetailThumbnailViewController.currentIdentifier = self.id
        resultDetailThumbnailViewController.coordinator = self

        self.navigationController.present(resultDetailThumbnailViewController, animated: true)
    }

    func dismiss() {
        self.parentCoordinator?.childCoordinators.removeLast()
    }

    init(navigationController: UINavigationController, uiImages: [String: UIImage], id: String) {
        self.navigationController = navigationController
        self.uiImages = uiImages
        self.id = id
    }
}
