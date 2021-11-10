//
//  RecordingViewCoordinator.swift
//  SanTa
//
//  Created by shin jae ung on 2021/11/01.
//


import UIKit

class RecordingViewCoordinator: Coordinator {
    weak var parentCoordinator: Coordinator?
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []
    var recordingViewController: RecordingViewController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        let viewModel = RecordingViewModel(recordingUseCase: DefaultRecordingUseCase(recordRepository: DefaultRecordRepository(recordStorage: CoreDataRecordStorage(coreDataStorage: CoreDataStorage())), recordingModel: RecordingModel()))
        self.recordingViewController = RecordingViewController(viewModel: viewModel)
        self.recordingViewController.coordinator = self
    }

    func start() {
        self.recordingViewController.modalPresentationStyle = .fullScreen
        self.navigationController.present(recordingViewController, animated: true)
    }
    
    func hide() {
        self.navigationController.dismiss(animated: true)
        guard let mapViewCoordinator = parentCoordinator as? MapViewCoordinator else { return }
        mapViewCoordinator.recordingViewDidHide()
    }
    
    func dismiss() {
        self.navigationController.dismiss(animated: true)
        guard let mapViewCoordinator = parentCoordinator as? MapViewCoordinator else { return }
        mapViewCoordinator.recordingViewDidDismiss()
        self.parentCoordinator?.childCoordinators.removeLast()
    }
    
    deinit {
        print("😇RecordingViewCoordinator is deinit \(Date())!!😇")
    }
}

extension RecordingViewCoordinator {
    func presentRecordingTitleViewController() {
        let recordingTitleViewCoordinator = RecordingTitleViewCoordinator(delegate: self.recordingViewController)
        self.childCoordinators.append(recordingTitleViewCoordinator)
        recordingTitleViewCoordinator.parentCoordinator = self
        
        recordingTitleViewCoordinator.start()
    }
}
