//
//  RecordingTitleViewCoordinator.swift
//  SanTa
//
//  Created by 김민창 on 2021/11/09.
//

import UIKit

class RecordingTitleViewCoordinator: Coordinator {
    weak var parentCoordinator: Coordinator?
    var navigationController: UINavigationController
    var childCoordinator: [Coordinator] = []
    var recordingTitleViewController: RecordingTitleViewController
    
    init(navigationController: UINavigationController, delegate: RecordingViewDelegate) {
        self.navigationController = navigationController
        self.recordingTitleViewController = RecordingTitleViewController()
        self.recordingTitleViewController.delegate = delegate
        self.recordingTitleViewController.coordinator = self
    }

    func start() {
        guard let recordingCoordinator = parentCoordinator as? RecordingViewCoordinator else { return }
        
        recordingCoordinator.recordingViewController.present(recordingTitleViewController, animated: true)
    }
    
    func dismiss() {
        guard let recordingCoordinator = parentCoordinator as? RecordingViewCoordinator else { return }
        
        recordingCoordinator.recordingViewController.dismiss(animated: true)
        self.parentCoordinator?.childCoordinator.enumerated().forEach { (index, coordinator) in
            if coordinator is RecordingTitleViewCoordinator {
                parentCoordinator?.childCoordinator.remove(at: index)
                return
            }
        }
    }
}
