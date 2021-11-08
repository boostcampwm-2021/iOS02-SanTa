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
    
    private func calculateDistance() -> Double?  {
        let canGetCurrentLocation = locationManager.authorizationStatus == .authorizedWhenInUse ||
        locationManager.authorizationStatus == .authorizedAlways
        guard canGetCurrentLocation, let currentLocation = locationManager.location else {
            return nil
        }
        let mountainLocation = CLLocation(latitude: self.mountainAnnotation.latitude, longitude: self.mountainAnnotation.longitude)
        let distance = currentLocation.distance(from: CLLocation(latitude: mountainLocation.coordinate.latitude, longitude: mountainLocation.coordinate.longitude))
        
        return distance
    }
    
    private func mountainRegions() -> [String] {
        return mountainAnnotation.region.components(separatedBy: ", ")
    }
}

extension MountainDetailUseCase {
    func transferMountainInformation(completion: @escaping (MountainDetailModel) -> Void) {
        guard let name = mountainAnnotation.title,
              let altitude = mountainAnnotation.subtitle else { return }
        
        completion(MountainDetailModel(moutainName: name, distance: calculateDistance(), regions: mountainRegions(), altitude: altitude, latitude: mountainAnnotation.latitude, longitude: mountainAnnotation.longitude, mountainDescription: mountainAnnotation.mountainDescription))
    }
}
