//
//  MountainDetailViewCoordinator.swift
//  SanTa
//
//  Created by Jiwon Yoon on 2021/11/08.
//

import UIKit

class MountainDetailViewCoordinator: Coordinator {
    weak var parentCoordinator: Coordinator?
    var navigationController: UINavigationController
    var childCoordinator: [Coordinator]
    var mountainDetailViewController: MountainDetailViewController
    
    func start() {
        <#code#>
    }
    
    
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        let viewModel = RecordingViewModel(recordingUseCase: DefaultRecordingUseCase(recordRepository: DefaultRecordRepository(recordStorage: CoreDataRecordStorage(coreDataStorage: CoreDataStorage())), recordingModel: RecordingModel()))
        self.recordingViewController = RecordingViewController(viewModel: viewModel)
        self.recordingViewController.coordinator = self
    }
    
}
