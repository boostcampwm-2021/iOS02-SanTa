//
//  MapViewCoordinator.swift
//  SanTa
//
//  Created by shin jae ung on 2021/11/01.
//

import UIKit

class MapViewCoordinator: Coordinator {
    weak var parentCoordinator: Coordinator?
    var childCoordinator: [Coordinator] = []

    func start() {
    }

    func startPush() -> MapViewController {
        let mapViewController = MapViewController()
        mapViewController.coordinator = self

        return mapViewController
    }
}
