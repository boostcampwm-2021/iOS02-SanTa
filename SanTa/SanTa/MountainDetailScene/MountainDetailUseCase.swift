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
    private let location: CLLocation?
    
    init(mountainAnnotation: MountainAnnotation, location: CLLocation?) {
        self.mountainAnnotation = mountainAnnotation
        self.location = location
    }
    
    private func calculateDistance() -> Double?  {
        let mountainLocation = CLLocation(latitude: self.mountainAnnotation.latitude, longitude: self.mountainAnnotation.longitude)
        let distance = location?.distance(from: mountainLocation)
        print(distance)
        return distance
    }
    
    private func mountainRegions() -> [String] {
        return mountainAnnotation.region.components(separatedBy: ", ")
    }
    
    func transferMountainInformation(completion: @escaping (MountainDetailModel) -> Void) {
        guard let name = mountainAnnotation.title,
              let altitude = mountainAnnotation.subtitle else { return }
        
        completion(MountainDetailModel(moutainName: name, distance: calculateDistance(), regions: mountainRegions(), altitude: altitude, latitude: mountainAnnotation.latitude, longitude: mountainAnnotation.longitude, mountainDescription: mountainAnnotation.mountainDescription))
    }
}

