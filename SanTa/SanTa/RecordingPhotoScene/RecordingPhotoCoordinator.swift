//
//  RecordingPhotoCoordinator.swift
//  SanTa
//
//  Created by 김민창 on 2021/11/14.
//

import UIKit

class RecordingPhotoViewCoordinator: Coordinator {
    weak var parentCoordinator: Coordinator?
    var childCoordinators: [Coordinator] = []
    var recordingPhotoViewController: RecordingPhotoViewController

    init(delegate: RecordingViewDelegate) {
        self.recordingPhotoViewController = RecordingPhotoViewController()
        self.recordingPhotoViewController.delegate = delegate
        self.recordingPhotoViewController.coordinator = self
    }

    func start() {
        guard let recordingCoordinator = parentCoordinator as? RecordingViewCoordinator else { return }

        recordingCoordinator.recordingViewController.present(recordingPhotoViewController, animated: true)
    }

    func dismiss() {
        guard let recordingCoordinator = parentCoordinator as? RecordingViewCoordinator else { return }

        recordingCoordinator.recordingViewController.dismiss(animated: true)
        self.parentCoordinator?.childCoordinators.removeLast()
    }
}
