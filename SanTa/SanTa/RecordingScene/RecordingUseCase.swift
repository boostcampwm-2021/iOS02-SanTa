//
//  DefaultSaveRecordUseCase.swift
//  SanTa
//
//  Created by CHANGMIN OH on 2021/11/03.
//

import Foundation

protocol RecordingUseCase {
    func save(record: Record,
              completion: @escaping (Result<Record, Error>) -> Void)
}

final class DefaultRecordingUseCase: RecordingUseCase {
    
    private let recordRepository: RecordRepository
    
    init(recordRepository: RecordRepository) {
        self.recordRepository = recordRepository
    }
    
    func save(record: Record, completion: @escaping (Result<Record, Error>) -> Void) {
        self.recordRepository.save(record: record, completion: completion)
    }
}
