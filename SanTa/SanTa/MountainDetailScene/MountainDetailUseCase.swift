//
//  MountainDetailUseCase.swift
//  SanTa
//
//  Created by Jiwon Yoon on 2021/11/08.
//

import Foundation
import CoreLocation

class MountainDetailUseCase {
    private let mountainAnnotation: MountainAnnotation
    private let locationManager: CLLocationManager
    
    init(mountainAnnotation: MountainAnnotation, locationManager: CLLocationManager) {
        self.mountainAnnotation = mountainAnnotation
        self.locationManager = locationManager
    }
    
    private func calculateDistance(to mountainLocation: CLLocationCoordinate2D) -> Double?  {
        let canGetCurrentLocation = locationManager.authorizationStatus == .authorizedWhenInUse ||
                                    locationManager.authorizationStatus == .authorizedAlways
        guard canGetCurrentLocation, let currentLocation = locationManager.location else {
            return nil
        }
        let distance = currentLocation.distance(from: CLLocation(latitude: mountainLocation.latitude, longitude: mountainLocation.longitude))
        
        return distance
    }
}
