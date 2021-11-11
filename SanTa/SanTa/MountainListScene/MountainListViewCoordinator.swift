//
//  MountainListViewCoordinator.swift
//  SanTa
//
//  Created by shin jae ung on 2021/11/01.
//

import UIKit

class MountainListViewCoordinator: Coordinator {
    weak var parentCoordinator: Coordinator?
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController = UINavigationController()

    private let userDefaultsStorage: UserDefaultsStorage
    private let mountainExtractor: MountainExtractor
    
    init(userDefaultsStorage: UserDefaultsStorage,
         mountainExtractor: MountainExtractor) {
        self.userDefaultsStorage = userDefaultsStorage
        self.mountainExtractor = mountainExtractor
    }
    
    func start() {
    }

    func startPush() -> UINavigationController {
        let mountainListViewController = MountainListViewController(viewModel: self.injectDependencies())
        mountainListViewController.coordinator = self
        self.navigationController.setViewControllers([mountainListViewController], animated: true)
        self.navigationController.navigationBar.topItem?.title = "산 목록"

        return navigationController
    }
}

extension MountainListViewCoordinator {
    private func injectDependencies() -> MountainListViewModel {
        return MountainListViewModel(
            useCase: MountainListUseCase(
                repository: DefaultMountainListViewReposiory(
                    mountainExtractor: self.mountainExtractor,
                    userDefaultsStorage: self.userDefaultsStorage)))

    }
}

