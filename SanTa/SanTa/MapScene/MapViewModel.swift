//
//  MapViewModel.swift
//  SanTa
//
//  Created by shin jae ung on 2021/11/01.
//

import Combine
import CoreLocation

final class MapViewModel {
    private let useCase: MapViewUseCase
    @Published private(set) var mountains: [MountainEntity]?
    @Published private(set) var map: Map?
    @Published private(set) var initialLocation: CLLocation?
    @Published private(set) var locationPermission: Bool?
    
    init(useCase: MapViewUseCase) {
        self.useCase = useCase
        self.mountains = []
    }
    
    func configureBindings() {
        self.useCase.prepareMountainMarkers { [weak self] mountains in
            guard let mountains = mountains else { return }
            self?.mountains?.append(contentsOf: mountains)
        }
        self.useCase.initialLocation = { [weak self] initialLocation in
            self?.initialLocation = initialLocation
        }
        self.useCase.locationPermissionDidChangeTo = { [weak self] bool in
            self?.locationPermission = bool
        }
        
        self.useCase.preparePermission()
        self.useCase.prepareLocacationManager()
    }
    
    func viewWillAppear() {
        self.useCase.prepareMap{ [weak self] map in
            guard let map = map else { return }
            self?.map = map
        }
    }
}
