//
//  MountainDetailViewCoordinator.swift
//  SanTa
//
//  Created by Jiwon Yoon on 2021/11/08.
//

import UIKit
import CoreLocation

class MountainDetailViewCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    
    weak var parentCoordinator: Coordinator?
    var navigationController: UINavigationController
    var mountainDetailViewController: MountainDetailViewController
    
    func start() {
        if self.parentCoordinator is MapViewCoordinator {
            self.navigationController.present(mountainDetailViewController, animated: true, completion: nil)
        }
    }
    
    func dismiss() {
        self.navigationController.dismiss(animated: true)
        self.parentCoordinator?.childCoordinators.removeLast()
    }
    
    
    init(navigationController: UINavigationController, mountainAnnotation: MountainAnnotation) {
        self.navigationController = navigationController
        let viewModel = MountainDetailViewModel(useCase: MountainDetailUseCase(mountainAnnotation: mountainAnnotation))
        self.mountainDetailViewController = MountainDetailViewController(viewModel: viewModel)
        self.mountainDetailViewController.coordinator = self
    }
    
}
