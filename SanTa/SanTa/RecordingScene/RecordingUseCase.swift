//
//  DefaultSaveRecordUseCase.swift
//  SanTa
//
//  Created by CHANGMIN OH on 2021/11/03.
//

import Foundation

protocol RecordingUseCase {
    var recording: RecordingModel { get set }
    
    func save(title: String, completion: @escaping (Result<Records, CoreDataError>) -> Void)
    func pause()
    func resume()
}

final class DefaultRecordingUseCase: RecordingUseCase, ObservableObject {
    var recording: RecordingModel
    
    private let recordRepository: RecordRepository
    
    init(recordRepository: RecordRepository, recordingModel: RecordingModel) {
        self.recordRepository = recordRepository
        self.recording = recordingModel
    }
    
    func pause() {
        self.recording.pause()
    }
    
    func resume() {
        self.recording.resume()
    }
    
    func save(title: String, completion: @escaping (Result<Records, CoreDataError>) -> Void) {
        guard var records = recording.cancel() else {
//            completion(.failure(error))
            return
        }
        
        records.configureTitle(title: title)
        self.recordRepository.save(records: records, completion: completion)
    }
}
