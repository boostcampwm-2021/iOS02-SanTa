//
//  MountainDetailViewController.swift
//  SanTa
//
//  Created by Jiwon Yoon on 2021/11/08.
//

import UIKit

class MountainDetailViewController: UIViewController {
    weak var mountainDetailViewCoordinator: MountainDetailViewCoordinator?
    private var viewModel: MountainDetailViewModel?
    
    convenience init(viewModel: MountainDetailViewModel) {
        self.init()
        self.viewModel = viewModel
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    private func configureViewModel() {
        self.viewModel?.mountainInfoReceived = { mountainDetail in
            self.layoutMountainDetailView(mountainDetail: mountainDetail)
        }
        viewModel?.setUpViewModel()
    }
}

extension MountainDetailViewController {
    private func layoutMountainDetailView(mountainDetail: MountainDetailModel) {
        
    }
}
