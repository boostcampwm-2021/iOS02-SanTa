//
//  RecordingViewCoordinator.swift
//  SanTa
//
//  Created by shin jae ung on 2021/11/01.
//


import UIKit

class RecordingViewCoordinator: Coordinator {
    weak var parentCoordinator: Coordinator?
    var childCoordinator: [Coordinator] = []

    func start() {
    }

    func startPush() -> RecordingViewController {
        let recordingViewController = RecordingViewController()
        recordingViewController.coordinator = self

        return recordingViewController
    }
}

