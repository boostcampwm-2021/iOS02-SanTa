//
//  MountainDetailUseCase.swift
//  SanTa
//
//  Created by Jiwon Yoon on 2021/11/08.
//

import Foundation
import CoreLocation

final class MountainDetailUseCase {
    private let mountainAnnotation: MountainAnnotation
    private let manager = CLLocationManager()

    init(mountainAnnotation: MountainAnnotation) {
        self.mountainAnnotation = mountainAnnotation
    }

    private func calculateDistance() -> Double? {
        let mountainLocation = CLLocation(latitude: self.mountainAnnotation.latitude, longitude: self.mountainAnnotation.longitude)
        guard let distance = manager.location?.distance(from: mountainLocation) else {
            return nil
        }
        return distance / 1000
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
