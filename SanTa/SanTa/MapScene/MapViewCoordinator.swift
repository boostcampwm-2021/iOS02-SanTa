//
//  MapViewCoordinator.swift
//  SanTa
//
//  Created by shin jae ung on 2021/11/01.
//

import UIKit
import CoreLocation

class MapViewCoordinator: Coordinator {
    weak var parentCoordinator: Coordinator?
    var navigationController: UINavigationController = UINavigationController()
    var childCoordinators: [Coordinator] = []
    
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
        let recordingViewCoordinator = RecordingViewCoordinator(navigationController: self.navigationController)
        self.childCoordinators.append(recordingViewCoordinator)
        recordingViewCoordinator.parentCoordinator = self
        
        recordingViewCoordinator.start()
    }
    
    func presentMountainDetailViewController(mountainAnnotation: MountainAnnotation, locationManager: CLLocationManager) {
        let mountainDetailViewCoordinator = MountainDetailViewCoordinator(navigationController: self.navigationController, mountainAnnotation: mountainAnnotation, locationManager: locationManager)
        mountainDetailViewCoordinator.parentCoordinator = self
        self.childCoordinators.append(mountainDetailViewCoordinator)
        
        mountainDetailViewCoordinator.start()
    }
    
    private func injectDependencies() -> MapViewModel {
        return MapViewModel(useCase: MapViewUseCase(repository: DefaultMapViewRespository(mountainExtractor: MountainExtractor())))
    }
}
