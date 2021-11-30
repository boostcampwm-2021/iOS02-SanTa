//
//  RecordingTitleViewCoordinator.swift
//  SanTa
//
//  Created by 김민창 on 2021/11/09.
//

import UIKit

final class RecordingTitleViewCoordinator: Coordinator {
    weak var parentCoordinator: Coordinator?
    var childCoordinators: [Coordinator] = []
    var recordingTitleViewController: RecordingTitleViewController

    init(delegate: SetTitleDelegate) {
        self.recordingTitleViewController = RecordingTitleViewController()
        self.recordingTitleViewController.delegate = delegate
        self.recordingTitleViewController.coordinator = self
    }

    func start() {
        guard let viewController = self.recordingTitleViewController.delegate as? UIViewController else { return }
        viewController.present(recordingTitleViewController, animated: true)
    }

    func dismiss() {
        guard let viewController = self.recordingTitleViewController.delegate as? UIViewController else { return }
        viewController.dismiss(animated: true, completion: nil)
        self.parentCoordinator?.childCoordinators.removeLast()
    }
}
