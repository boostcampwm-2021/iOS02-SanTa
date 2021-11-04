//
//  MapViewModel.swift
//  SanTa
//
//  Created by shin jae ung on 2021/11/01.
//

import Foundation

class MapViewModel {
    private let useCase: MapViewUseCase
    private(set) var mountains: [MountainEntity]?
    var markersShouldUpdate: () -> Void
    
    init(useCase: MapViewUseCase) {
        self.useCase = useCase
        self.markersShouldUpdate = { }
    }
    
    func viewDidLoad() {
        self.useCase.prepareMountainMarkers { [weak self] mountains in
            self?.mountains = mountains
            self?.markersShouldUpdate()
        }
    }
}
