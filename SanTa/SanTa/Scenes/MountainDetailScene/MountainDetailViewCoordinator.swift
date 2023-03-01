//
//  MountainDetailViewCoordinator.swift
//  SanTa
//
//  Created by Jiwon Yoon on 2021/11/08.
//

import UIKit
import CoreLocation

final class MountainDetailViewCoordinator: Coordinator {
    weak var parentCoordinator: Coordinator?
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    var mountainAnnotation: MountainAnnotation

    init(navigationController: UINavigationController, mountainAnnotation: MountainAnnotation) {
        self.navigationController = navigationController
        self.mountainAnnotation = mountainAnnotation
    }

    func start() {
        let mountainDetailViewController = MountainDetailViewController(viewModel: injectDependencies())
        mountainDetailViewController.coordinator = self
        if self.parentCoordinator is MapViewCoordinator {
            self.navigationController.present(mountainDetailViewController, animated: true, completion: nil)
        } else {
            self.navigationController.setNavigationBarHidden(true, animated: true)
            self.navigationController.pushViewController(mountainDetailViewController, animated: true)
        }
    }

    func dismiss() {
        if self.parentCoordinator is MapViewCoordinator {
            self.navigationController.dismiss(animated: true)
        } else {
            self.navigationController.setNavigationBarHidden(false, animated: true)
            self.navigationController.popViewController(animated: true)
        }
    }
    
    func viewControllerDidDeinit() {
        if let index = parentCoordinator?.childCoordinators.firstIndex(where: { $0 === self }) {
            self.parentCoordinator?.childCoordinators.remove(at: index)
        }
    }
}

extension MountainDetailViewCoordinator {
    private func injectDependencies() -> MountainDetailViewModel {
        return MountainDetailViewModel(
            useCase: MountainDetailUseCase(
                mountainAnnotation: self.mountainAnnotation
            )
        )
    }

}
