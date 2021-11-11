//
//  MountainListRepository.swift
//  SanTa
//
//  Created by 김민창 on 2021/11/11.
//

import Foundation

protocol MountainListViewRepository {
    func fetchMountains(completion: @escaping (Result<[MountainEntity], Error>) -> Void)
}

class DefaultMountainListViewReposiory {
    enum JSONDecodeError: Error {
        case decodingFailed
    }
    
    enum userDefaultsError: Error {
        case notExists
    }
    
    private let mountainExtractor: MountainExtractor
    private let settingsStorage: UserDefaultsStorage
    
    init(mountainExtractor: MountainExtractor, userDefaultsStorage: UserDefaultsStorage) {
        self.mountainExtractor = mountainExtractor
        self.settingsStorage = userDefaultsStorage
    }
}

extension DefaultMountainListViewReposiory: MountainListViewRepository {
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
