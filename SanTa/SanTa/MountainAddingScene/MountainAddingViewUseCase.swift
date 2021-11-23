//
//  MountainAddingViewUseCase.swift
//  SanTa
//
//  Created by shin jae ung on 2021/11/17.
//

import Foundation
import OSLog

class MountainAddingViewUseCase {
    private let repository: MountainAddingRepository
    
    init(repository: MountainAddingRepository) {
        self.repository = repository
    }

    
    func saveMountain(name: String, altitude: Double, latitude: Double, longitude: Double, description: String, completion: @escaping (Void?) -> Void) {
        let mountainDetail = MountainEntity.MountainDetail(
            mountainName: name,
            mountainRegion: "",
            mountainHeight: String(altitude),
            mountainShortDescription: description
        )
        let mountainEntity = MountainEntity(mountain: mountainDetail, latitude: latitude, longitude: longitude)
        self.repository.save(mountainEntity) { result in
            switch result {
            case .success():
                completion(Void())
            case .failure(let error):
                completion(nil)
                os_log(.error, log: .default, "\(error.localizedDescription)")
            }
        }
    }
}
