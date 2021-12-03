//
//  MapViewUseCase.swift
//  SanTa
//
//  Created by shin jae ung on 2021/11/01.
//

import Foundation
import OSLog
import CoreLocation

final class MapViewUseCase: NSObject {
    private let repository: MapViewRepository
    private let manager = CLLocationManager()
    var initialLocation: (CLLocation) -> Void
    var locationPermissionDidChangeTo: (Bool) -> Void
    var locationPermission: Bool {
        switch self.manager.authorizationStatus {
        case .authorizedAlways, .authorizedWhenInUse:
            return true
        default:
            return false
        }
    }

    init(repository: MapViewRepository) {
        self.repository = repository
        self.initialLocation = { _ in }
        self.locationPermissionDidChangeTo = { _ in }
    }

    func prepareMountainMarkers(completion: @escaping ([MountainEntity]?) -> Void) {
        self.repository.fetchMountains { result in
            switch result {
            case .failure(let error):
                os_log(.error, log: .default, "\(error.localizedDescription)")
                completion(nil)
            case .success(let mountains):
                completion(mountains)
            }
        }
    }

    func prepareMap(completion: @escaping (Map?) -> Void) {
        self.repository.fetchMapOption(key: Settings.mapFormat) { result in
            switch result {
            case .failure(let error):
                os_log(.error, log: .default, "\(error.localizedDescription)")
                completion(nil)
            case .success(let map):
                completion(map)
            }
        }
    }

    func preparePermission() {
        self.locationPermissionDidChangeTo(self.locationPermission)
    }

    func prepareLocacationManager() {
        self.manager.requestWhenInUseAuthorization()
        self.manager.requestAlwaysAuthorization()
        self.manager.delegate = self
        self.manager.desiredAccuracy = kCLLocationAccuracyBest
        self.manager.startUpdatingLocation()
    }
}

extension MapViewUseCase: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            manager.stopUpdatingLocation()
            self.initialLocation(location)
        }
    }

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        self.locationPermissionDidChangeTo(self.locationPermission)
    }
}
