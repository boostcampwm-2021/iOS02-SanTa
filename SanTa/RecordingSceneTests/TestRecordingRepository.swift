//
//  TestRecordingRepository.swift
//  RecordingSceneTests
//
//  Created by 김민창 on 2021/11/30.
//

import Foundation

enum testError: Error {
    case StoreError
}

class TestRecordingRepository: RecordRepository {
    func saveRecordPhotoOption(value: Bool) {
        return
    }

    func save(records: Records,
              completion: @escaping (Result<Records, Error>) -> Void) {

        completion(.success(records))
    }

    func fetchRecordOption(key: Settings, completion: @escaping (Result<Bool, Error>) -> Void) {
        switch key {
        case .voiceGuidanceEveryOnekm:
            completion(.success(true))
        case .recordPhoto:
            completion(.success(true))
        default:
            completion(.success(false))
        }
    }
}
