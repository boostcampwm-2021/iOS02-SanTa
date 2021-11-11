//
//  ResultRepository.swift
//  SanTa
//
//  Created by CHANGMIN OH on 2021/11/11.
//

import Foundation

protocol ResultRepository {
    func fetch(completion: @escaping (Result<[RecordsEntityMO], Error>) -> Void)
}

final class DefaultResultRepository: ResultRepository {
    
    private let recordStorage: CoreDataRecordStorage
    
    init(recordStorage: CoreDataRecordStorage) {
        self.recordStorage = recordStorage
    }
    
    func fetch(completion: @escaping (Result<[RecordsEntityMO], Error>) -> Void) {
        self.recordStorage.fetch { result in
            switch result {
            case .success(let objects):
                completion(.success(objects))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
