//
//  MapViewCoordinator.swift
//  SanTa
//
//  Created by shin jae ung on 2021/11/01.
//

import UIKit
import CoreLocation

final class MapViewCoordinator: Coordinator {
    weak var parentCoordinator: Coordinator?
    var navigationController: UINavigationController = UINavigationController()
    var childCoordinators: [Coordinator] = []

    private let userDefaultsStorage: UserDefaultsStorage
    private let mountainExtractor: MountainExtractor
    private let coreDataStorage: CoreDataStorage

    init(userDefaultsStorage: UserDefaultsStorage,
         mountainExtractor: MountainExtractor,
         coreDataStorage: CoreDataStorage) {
        self.userDefaultsStorage = userDefaultsStorage
        self.mountainExtractor = mountainExtractor
        self.coreDataStorage = coreDataStorage
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
        if let recordingViewCoordinator = self.childCoordinators.first(where: { $0 is RecordingViewCoordinator }) {
            recordingViewCoordinator.start()
        } else {
            let recordingViewCoordinator = RecordingViewCoordinator(
                navigationController: self.navigationController,
                userDefaultsStorage: self.userDefaultsStorage,
                coreDataStorage: self.coreDataStorage
            )
            self.childCoordinators.append(recordingViewCoordinator)
            recordingViewCoordinator.parentCoordinator = self
            recordingViewCoordinator.start()
        }
    }

    func presentMountainDetailViewController(mountainAnnotation: MountainAnnotation) {
        let mountainDetailViewCoordinator = MountainDetailViewCoordinator(navigationController: self.navigationController, mountainAnnotation: mountainAnnotation)
        mountainDetailViewCoordinator.parentCoordinator = self
        self.childCoordinators.append(mountainDetailViewCoordinator)

        mountainDetailViewCoordinator.start()
    }

    func presentMountainAddingViewController() {
        let mountainAddingViewCoordinator = MountainAddingViewCoordinator(
            navigationController: self.navigationController,
            coreDataStorage: self.coreDataStorage
        )
        mountainAddingViewCoordinator.parentCoordinator = self
        self.childCoordinators.append(mountainAddingViewCoordinator)

        mountainAddingViewCoordinator.start()
    }

    func recordingViewDidHide() {
        guard let animatableViewController = navigationController.viewControllers.first as? Animatable else { return }
        animatableViewController.shouldAnimate()
    }

    func recordingViewDidDismiss() {
        guard let animatableViewController = navigationController.viewControllers.first as? Animatable else { return }
        animatableViewController.shouldStopAnimate()
    }

    private func injectDependencies() -> MapViewModel {
        return MapViewModel(
            useCase: MapViewUseCase(
                repository: DefaultMapViewRespository(
                    mountainExtractor: self.mountainExtractor,
                    userDefaultsStorage: self.userDefaultsStorage,
                    coreDataMountainStorage: CoreDataMountainStorage(
                        coreDataStorage: self.coreDataStorage
                    )
                )
            )
        )
    }
}
