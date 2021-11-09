//
//  MapViewUseCase.swift
//  SanTa
//
//  Created by shin jae ung on 2021/11/01.
//

import Foundation
import OSLog

class MapViewUseCase {
    private let repository: MapViewRepository
    
    init(repository: MapViewRepository) {
        self.repository = repository
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
}
