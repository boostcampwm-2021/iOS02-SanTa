//
//  ResultDetailCoordinator.swift
//  SanTa
//
//  Created by Jiwon Yoon on 2021/11/17.
//
import UIKit
import CoreLocation

class ResultDetailCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    
    weak var parentCoordinator: Coordinator?
    var navigationController: UINavigationController
    var viewController: ResultDetailViewController
    
    func start() {
        self.navigationController.present(viewController, animated: true, completion: nil)
    }
    
    func dismiss() {
        self.navigationController.dismiss(animated: true)
        self.parentCoordinator?.childCoordinators.removeLast()
    }
    
    
    init(navigationController: UINavigationController, records: Records) {
        self.navigationController = navigationController
        let viewModel = ResultDetailViewModel(useCase: ResultDetailUseCase(model: ResultDetailData(records: records)))
        self.viewController = ResultDetailViewController(viewModel: viewModel)
        self.viewController.coordinator = self
    }
    
}
