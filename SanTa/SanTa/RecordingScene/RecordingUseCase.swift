//
//  DefaultSaveRecordUseCase.swift
//  SanTa
//
//  Created by CHANGMIN OH on 2021/11/03.
//

import Foundation

protocol RecordingUseCase {
    var recording: RecordingModel { get set }
    
    func save(title: String, completion: @escaping (Result<Record, Error>) -> Void)
    func pause()
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
    
    func save(title: String, completion: @escaping (Result<Record, Error>) -> Void) {
//        self.recordRepository.save(record: recording.cancel(), completion: completion)
    }
}
