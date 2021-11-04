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
    var childCoordinator: [Coordinator] = []
    var recordingViewController: RecordingViewController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.recordingViewController = RecordingViewController()
        self.recordingViewController.coordinator = self
    }

    func start() {
        recordingViewController.modalPresentationStyle = .fullScreen
        self.navigationController.present(recordingViewController, animated: true)
    }
    
    func dismiss() {
        self.navigationController.dismiss(animated: true)
    }
}

