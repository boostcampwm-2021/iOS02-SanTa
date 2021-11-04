//
//  DefaultRecordsRepository.swift
//  SanTa
//
//  Created by CHANGMIN OH on 2021/11/03.
//

import Foundation

protocol RecordRepository {
    func save(record: Record,
              completion: @escaping (Result<Record, Error>) -> Void)
}

final class DefaultRecordRepository: RecordRepository {
    
    private let recordStorage: CoreDataRecordStorage
    
    init(recordStorage: CoreDataRecordStorage) {
        self.recordStorage = recordStorage
    }
    
    func save(record: Record, completion: @escaping (Result<Record, Error>) -> Void) {
        self.recordStorage.save(record: record, completion: completion)
    }
}
