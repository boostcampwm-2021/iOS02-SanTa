//
//  MountainDetailViewCoordinator.swift
//  SanTa
//
//  Created by Jiwon Yoon on 2021/11/08.
//

import UIKit
import CoreLocation

class MountainDetailViewCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    
    weak var parentCoordinator: Coordinator?
    var navigationController: UINavigationController
    var mountainDetailViewController: MountainDetailViewController
    
    func start() {
        self.navigationController.present(mountainDetailViewController, animated: true, completion: nil)
    }
    
    
    //지도화면에서 바로 올때
    init(navigationController: UINavigationController, mountainAnnotation: MountainAnnotation, locationManager: CLLocationManager) {
        self.navigationController = navigationController
        let viewModel = MountainDetailViewModel(useCase: MountainDetailUseCase(mountainAnnotation: mountainAnnotation, locationManager: locationManager))
        self.mountainDetailViewController = MountainDetailViewController(viewModel: viewModel)
        self.mountainDetailViewController.coordinator = self
    }
    
    //산 목록에서 올때
//    init(navigationController: UINavigationController, mountainDetailModel: MountainDetailModel) {
//
//    }
    
}
