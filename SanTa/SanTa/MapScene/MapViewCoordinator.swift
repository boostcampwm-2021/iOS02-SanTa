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
    weak var mapViewController: MapViewController?
    var navigationController: UINavigationController = UINavigationController()
    var childCoordinators: [Coordinator] = []
    
    func start() {
    }
    
    func startPush() -> UINavigationController {
        let mapViewController = MapViewController(viewModel: injectDependencies())
        mapViewController.coordinator = self
        self.mapViewController = mapViewController
        self.navigationController.setViewControllers([mapViewController], animated: false)
        
        return navigationController
    }
}

extension MapViewCoordinator {
    func presentRecordingViewController() {
        if self.childCoordinators.isEmpty {
            let recordingViewCoordinator = RecordingViewCoordinator(navigationController: self.navigationController)
            self.childCoordinators.append(recordingViewCoordinator)
            recordingViewCoordinator.parentCoordinator = self
        }
        childCoordinators.first?.start()
    }
    
    func presentMountainDetailViewController(mountainAnnotation: MountainAnnotation, location: CLLocation?) {
        let mountainDetailViewCoordinator = MountainDetailViewCoordinator(navigationController: self.navigationController, mountainAnnotation: mountainAnnotation, location: location)
        mountainDetailViewCoordinator.parentCoordinator = self
        self.childCoordinators.append(mountainDetailViewCoordinator)
        
        mountainDetailViewCoordinator.start()
    }
    
    func recordingViewDidHide(){
        self.mapViewController?.presentAnimation()
    }
    
    func recordingViewDidDismiss(){
        self.mapViewController?.unpresentAnimation()
    }
    
    private func injectDependencies() -> MapViewModel {
        return MapViewModel(useCase: MapViewUseCase(repository: DefaultMapViewRespository(mountainExtractor: MountainExtractor())))
    }
}
