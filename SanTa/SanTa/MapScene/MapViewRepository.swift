//
//  MapViewRepository.swift
//  SanTa
//
//  Created by shin jae ung on 2021/11/01.
//

import Foundation

protocol MapViewRepository {
    func fetchMountains(completion: @escaping (Result<[MountainEntity], Error>) -> Void)
}

class DefaultMapViewRespository {
    enum JSONDecodeError: Error {
        case decodingFailed
    }
    
    private let mountainExtractor: MountainExtractor
    
    init(mountainExtractor: MountainExtractor) {
        self.mountainExtractor = mountainExtractor
    }
}

extension DefaultMapViewRespository: MapViewRepository {
    func fetchMountains(completion: @escaping (Result<[MountainEntity], Error>) -> Void) {
        self.mountainExtractor.extract { result in
            switch result {
            case .failure(let error):
                return completion(.failure(error))
            case .success(let dataAsset):
                guard let decodedObjects = try? JSONDecoder().decode([MountainEntity].self, from: dataAsset.data) else {
                    return completion(.failure(JSONDecodeError.decodingFailed))
                }
                completion(.success(decodedObjects))
            }
        }
    }
}
