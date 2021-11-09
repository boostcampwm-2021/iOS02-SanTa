//
//  MapViewRepository.swift
//  SanTa
//
//  Created by shin jae ung on 2021/11/01.
//

import Foundation

protocol MapViewRepository {
    func fetchMountains(completion: @escaping (Result<[MountainEntity], Error>) -> Void)
    func fetchMapOption(key: Settings, completion: @escaping (Result<Map, Error>) -> Void)
}

class DefaultMapViewRespository {
    enum JSONDecodeError: Error {
        case decodingFailed
    }
    
    enum userDefaultsError: Error {
        case notExists
    }
    
    enum optionError: Error {
        case notExists
    }
    
    private let mountainExtractor: MountainExtractor
    private let settingsStorage: UserDefaultsStorage
    
    init(mountainExtractor: MountainExtractor, userDefaultsStorage: UserDefaultsStorage) {
        self.mountainExtractor = mountainExtractor
        self.settingsStorage = userDefaultsStorage
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
    
    func fetchMapOption(key: Settings, completion: @escaping (Result<Map, Error>) -> Void) {
        self.settingsStorage.string(key: key) { value in
            guard let value = value else {
                completion(.failure(userDefaultsError.notExists))
                return
            }
            guard let map = Map(rawValue: value) else {
                completion(.failure(optionError.notExists))
                return
            }
            let option = MapOption(text: key.title, map: map)
            completion(.success(option.map))
        }
    }
}
