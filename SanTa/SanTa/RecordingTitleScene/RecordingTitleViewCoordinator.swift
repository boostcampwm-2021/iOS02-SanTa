//
//  RecordingTitleViewCoordinator.swift
//  SanTa
//
//  Created by 김민창 on 2021/11/09.
//

import UIKit

class RecordingTitleViewCoordinator: Coordinator {
    weak var parentCoordinator: Coordinator?
    var childCoordinators: [Coordinator] = []
    var recordingTitleViewController: RecordingTitleViewController
    
    init(delegate: RecordingViewDelegate) {
        self.recordingTitleViewController = RecordingTitleViewController()
        self.recordingTitleViewController.delegate = delegate
        self.recordingTitleViewController.coordinator = self
    }

    func start() {
        guard let recordingCoordinator = parentCoordinator as? RecordingViewCoordinator else { return }
        
        recordingCoordinator.recordingViewController?.present(recordingTitleViewController, animated: true)
    }
    
    func dismiss() {
        guard let recordingCoordinator = parentCoordinator as? RecordingViewCoordinator else { return }
        
        recordingCoordinator.recordingViewController?.dismiss(animated: true)
        self.parentCoordinator?.childCoordinators.removeLast()
    }
    
    deinit {
        print("😇RecordingTitleViewCoordinator is deinit \(Date())!!😇")
    }
}
