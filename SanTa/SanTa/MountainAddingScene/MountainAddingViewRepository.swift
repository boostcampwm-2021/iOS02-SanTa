//
//  MountainAddingViewRepository.swift
//  SanTa
//
//  Created by shin jae ung on 2021/11/17.
//

import Foundation

protocol MountainAddingRepository {
    func save(_ mountainEntity: MountainEntity, completion: @escaping(Result<Void, Error>) -> Void)
}

class DefaultMountainAddingRepository: MountainAddingRepository {
    private let coreDataMountainStorage: CoreDataMountainStorage

    init(coreDataMountainStorage: CoreDataMountainStorage) {
        self.coreDataMountainStorage = coreDataMountainStorage
    }

    func save(_ mountainEntity: MountainEntity, completion: @escaping(Result<Void, Error>) -> Void) {
        coreDataMountainStorage.save(mountainEntity: mountainEntity) { result in
            switch result {
            case .success:
                completion(.success(Void()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
