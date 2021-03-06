//
//  MountainAddingViewCoordinator.swift
//  SanTa
//
//  Created by shin jae ung on 2021/11/17.
//

import UIKit

final class MountainAddingViewCoordinator: Coordinator {
    weak var parentCoordinator: Coordinator?
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []
    var coreDataStorage: CoreDataStorage

    init(navigationController: UINavigationController, coreDataStorage: CoreDataStorage) {
        self.navigationController = navigationController
        self.coreDataStorage = coreDataStorage
    }

    func start() {
        let mountainAddingViewController = MountainAddingViewController(viewModel: injectDependencies())
        mountainAddingViewController.coordinator = self
        mountainAddingViewController.modalPresentationStyle = .fullScreen
        self.navigationController.present(mountainAddingViewController, animated: true)
    }
}

extension MountainAddingViewCoordinator {
    private func injectDependencies() -> MountainAddingViewModel {
        return MountainAddingViewModel(
            useCase: MountainAddingViewUseCase(
                repository: DefaultMountainAddingRepository(
                    coreDataMountainStorage: CoreDataMountainStorage(
                        coreDataStorage: self.coreDataStorage
                    )
                )
            )
        )
    }

    func dismiss() {
        self.navigationController.dismiss(animated: true)
        self.parentCoordinator?.childCoordinators.removeLast()
    }
}
