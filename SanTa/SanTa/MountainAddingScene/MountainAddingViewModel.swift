//
//  MountainAddingViewModel.swift
//  SanTa
//
//  Created by shin jae ung on 2021/11/17.
//

import Foundation

class MountainAddingViewModel {
    private var useCase: MountainAddingViewUseCase?
    var locationDidUpdate: () -> Void
    var userLocation: (latitude: Double, longitude: Double)? {
        didSet { self.locationDidUpdate() }
    }
    
    init(useCase: MountainAddingViewUseCase) {
        self.useCase = useCase
        self.locationDidUpdate = {}
    }
    
}
