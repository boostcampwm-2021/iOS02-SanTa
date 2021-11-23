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
    
    init(delegate: SetTitleDelegate) {
        self.recordingTitleViewController = RecordingTitleViewController()
        self.recordingTitleViewController.delegate = delegate
        self.recordingTitleViewController.coordinator = self
    }

    func start() {
        if let recordingCoordinator = parentCoordinator as? RecordingViewCoordinator {
            recordingCoordinator.recordingViewController.present(recordingTitleViewController, animated: true)
        } else if let resultDetailCoordinator = parentCoordinator as? ResultDetailViewCoordinator {
            resultDetailCoordinator.navigationController.viewControllers.last?.present(recordingTitleViewController, animated: true)
        }
//        guard let recordingCoordinator = parentCoordinator as? RecordingViewCoordinator else {return}
        
//        recordingCoordinator.recordingViewController.present(recordingTitleViewController, animated: true)
    }
    
    func dismiss() {
        if let recordingCoordinator = parentCoordinator as? RecordingViewCoordinator {
            recordingCoordinator.recordingViewController.dismiss(animated: true, completion: nil)
            
        } else if let resultDetailViewCoordinator = parentCoordinator as? ResultDetailViewCoordinator {
            resultDetailViewCoordinator.navigationController.viewControllers.last?.dismiss(animated: true, completion: nil)
        }
        
//        guard let recordingCoordinator = parentCoordinator as? RecordingViewCoordinator else { return }
//        recordingCoordinator.recordingViewController.dismiss(animated: true)
        
        self.parentCoordinator?.childCoordinators.removeLast()
    }
    
    deinit {
        print("😇RecordingTitleViewCoordinator is deinit \(Date())!!😇")
    }
}
