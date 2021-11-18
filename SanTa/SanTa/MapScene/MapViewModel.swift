//
//  MapViewModel.swift
//  SanTa
//
//  Created by shin jae ung on 2021/11/01.
//

import Foundation
import CoreLocation

class MapViewModel {
    private let useCase: MapViewUseCase
    private(set) var mountains: [MountainEntity]?
    private(set) var map: Map?
    private(set) var initialLocation: CLLocation?
    var locationPermission: Bool { self.useCase.locationPermission }
    var markersShouldUpdate: () -> Void
    var mapShouldUpdate: () -> Void
    var initialLocationShouldUpdate: () -> Void
    var locationPermissionDidChange: () -> Void
    
    init(useCase: MapViewUseCase) {
        self.useCase = useCase
        self.markersShouldUpdate = {}
        self.mapShouldUpdate = {}
        self.initialLocationShouldUpdate = {}
        self.locationPermissionDidChange = {}
    }
    
    func viewDidLoad() {
        self.useCase.prepareMountainMarkers { [weak self] mountains in
            self?.mountains = mountains
            self?.markersShouldUpdate()
        }
        self.useCase.initialLocation = { [weak self] initialLocation in
            self?.initialLocation = initialLocation
            self?.initialLocationShouldUpdate()
        }
        self.useCase.locationPermissionDidChanged = { [weak self] in
            self?.locationPermissionDidChange()
        }
        self.useCase.prepareLocacationManager()
    }
    
    func viewWillAppear() {
        self.useCase.prepareMap{ [weak self] map in
            guard let map = map else { return }
            self?.map = map
            self?.mapShouldUpdate()
        }
    }
}
