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
    var recordingViewCoordinator: RecordingViewCoordinator?
    
    init() {
        self.recordingViewCoordinator = RecordingViewCoordinator(navigationController: self.navigationController)
        self.recordingViewCoordinator?.parentCoordinator = self
    }
    
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
        guard let recordingViewCoordinator = self.recordingViewCoordinator else { return }
        self.childCoordinator.append(recordingViewCoordinator)
        recordingViewCoordinator.start()
    }
    
    private func injectDependencies() -> MapViewModel {
        return MapViewModel(useCase: MapViewUseCase(repository: DefaultMapViewRespository(mountainExtractor: MountainExtractor())))
    }
}
