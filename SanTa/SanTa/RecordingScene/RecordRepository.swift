//
//  DefaultRecordsRepository.swift
//  SanTa
//
//  Created by CHANGMIN OH on 2021/11/03.
//

import Foundation

protocol RecordRepository {
    func save(records: Records,
              completion: @escaping (Result<Records, CoreDataError>) -> Void)
}

final class DefaultRecordRepository: RecordRepository {
    
    private let settingsStorage: UserDefaultsStorage
    private let recordStorage: CoreDataRecordStorage
    
    init(settingsStorage: UserDefaultsStorage, recordStorage: CoreDataRecordStorage) {
        self.settingsStorage = settingsStorage
        self.recordStorage = recordStorage
    }
    
    func save(records: Records, completion: @escaping (Result<Records, CoreDataError>) -> Void) {
        self.recordStorage.save(records: records, completion: completion)
    }
}
