//
//  MountainAddingViewUseCase.swift
//  SanTa
//
//  Created by shin jae ung on 2021/11/17.
//

import Foundation
import CoreLocation
import OSLog

class MountainAddingViewUseCase {
    private let repository: MountainAddingRepository

    init(repository: MountainAddingRepository) {
        self.repository = repository
    }

    func saveMountain(name: String, altitude: Double, latitude: Double, longitude: Double, description: String, completion: @escaping (Void?) -> Void) {
        self.userRegion(latitude: latitude, longitude: longitude) { [weak self] region in
            let mountainDetail = MountainEntity.MountainDetail(
                mountainName: name,
                mountainRegion: region,
                mountainHeight: String(format: "%.f", altitude),
                mountainShortDescription: description
            )
            let mountainEntity = MountainEntity(mountain: mountainDetail, latitude: latitude, longitude: longitude)
            self?.repository.save(mountainEntity) { result in
                switch result {
                case .success:
                    completion(Void())
                case .failure(let error):
                    completion(nil)
                    os_log(.error, log: .default, "\(error.localizedDescription)")
                }
            }
        }
    }

    private func userRegion(latitude: Double, longitude: Double, completion: @escaping (String) -> Void) {
        let location = CLLocation(latitude: latitude, longitude: longitude)
        CLGeocoder().reverseGeocodeLocation(location) { placeMark, error in
            guard error == nil else {
                completion("")
                return
            }
            let region = [placeMark?.first?.administrativeArea, placeMark?.first?.locality, placeMark?.first?.subLocality].compactMap { $0 }.joined(separator: " ")
            completion(region)
        }
    }
}
