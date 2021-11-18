//
//  ResultViewCoordinator.swift
//  SanTa
//
//  Created by shin jae ung on 2021/11/01.
//

import UIKit

class ResultViewCoordinator: Coordinator {
    weak var parentCoordinator: Coordinator?
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    private let coreDataStorage: CoreDataStorage

    init(coreDataStorage: CoreDataStorage) {
        self.navigationController = UINavigationController()
        self.coreDataStorage = coreDataStorage
    }
    
    func start() {
    }

    func startPush() -> UINavigationController {
        let resultViewController = ResultViewController(viewModel: injectDependencies())
        resultViewController.coordinator = self
        navigationController.setViewControllers([resultViewController], animated: true)

        return navigationController
    }
    
//    func pushDetailViewController(records: Records) {
//        let storage = CoreDataRecordStorage(coreDataStorage: self.coreDataStorage)
//        storage.
//        let resultDetailCoordinator = ResultDetailCoordinator(navigationController: self.navigationController, records: <#T##Records#>)
//    }
}

extension ResultViewCoordinator {
    private func injectDependencies() -> ResultViewModel {
        return ResultViewModel(
            useCase: ResultUseCase(
                resultRepository: DefaultResultRepository(
                    recordStorage: CoreDataRecordStorage(
                        coreDataStorage: self.coreDataStorage
                    )
                )
            )
        )
    }
}
