//
//  DefaultRecordsRepository.swift
//  SanTa
//
//  Created by CHANGMIN OH on 2021/11/03.
//

import Foundation

final class DefaultRecordRepository: RecordRepository {

    enum userDefaultsError: Error {
        case notExists
    }

    enum optionError: Error {
        case notExists
    }

    private let settingsStorage: UserDefaultsStorage
    private let recordStorage: CoreDataRecordStorage

    init(settingsStorage: UserDefaultsStorage, recordStorage: CoreDataRecordStorage) {
        self.settingsStorage = settingsStorage
        self.recordStorage = recordStorage
    }

    func save(records: Records, completion: @escaping (Result<Records, Error>) -> Void) {
        self.recordStorage.save(records: records, completion: completion)
    }

    func saveRecordPhotoOption(value: Bool) {
        self.settingsStorage.save(value: value, key: Settings.recordPhoto)
    }

    func fetchRecordOption(key: Settings, completion: @escaping (Result<Bool, Error>) -> Void) {
        self.settingsStorage.string(key: key) { value in
            guard let value = value else {
                completion(.failure(userDefaultsError.notExists))
                return
            }

            guard value == "1" else {
                completion(.success(false))
                return
            }

            completion(.success(true))
        }
    }
}
