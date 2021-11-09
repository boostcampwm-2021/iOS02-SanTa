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
    private(set) var map: Map?
    var markersShouldUpdate: () -> Void
    var mapShouldUpdate: () -> Void
    
    init(useCase: MapViewUseCase) {
        self.useCase = useCase
        self.markersShouldUpdate = {}
        self.mapShouldUpdate = {}
    }
    
    func viewDidLoad() {
        self.useCase.prepareMountainMarkers { [weak self] mountains in
            self?.mountains = mountains
            self?.markersShouldUpdate()
        }
    }
    
    func viewWillAppear() {
        self.useCase.prepareMap{ [weak self] map in
            guard let map = map else { return }
            self?.map = map
            self?.mapShouldUpdate()
        }
    }
}
