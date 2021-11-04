//
//  MapViewCoordinator.swift
//  SanTa
//
//  Created by shin jae ung on 2021/11/01.
//

import UIKit

class MapViewCoordinator: Coordinator {
    weak var parentCoordinator: Coordinator?
    var navigationController: UINavigationController = UINavigationController()
    var childCoordinator: [Coordinator] = []
    
    func start() {
    }

    func startPush() -> UINavigationController {
        let mapViewController = MapViewController(viewModel: injectDependencies())
        mapViewController.coordinator = self
        self.navigationController.setViewControllers([mapViewController], animated: false)

        return navigationController
    }
}

extension MapViewCoordinator {
    func presentRecordingViewController() {
        if self.childCoordinator.isEmpty {
            let recordingViewCoordinator = RecordingViewCoordinator(navigationController: self.navigationController)
            self.childCoordinator.append(recordingViewCoordinator)
            recordingViewCoordinator.parentCoordinator = self
        }
        
        childCoordinator.first?.start()
    }
    
    private func injectDependencies() -> MapViewModel {
        return MapViewModel(useCase: MapViewUseCase(repository: DefaultMapViewRespository(mountainExtractor: MountainExtractor())))
    }
}
