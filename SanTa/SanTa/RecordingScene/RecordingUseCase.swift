//
//  DefaultSaveRecordUseCase.swift
//  SanTa
//
//  Created by CHANGMIN OH on 2021/11/03.
//

import Foundation
import Combine

protocol RecordingUseCase {
    var currentTime: String { get set }
    var kilometer: String  { get set }
    var altitude: String  { get set }
    var walk: String  { get set }
    var recording: RecordingModel { get set }
    
    func save(completion: @escaping (Result<Record, Error>) -> Void)
}

final class DefaultRecordingUseCase: RecordingUseCase, ObservableObject {
    @Published var currentTime = ""
    @Published var kilometer = ""
    @Published var altitude = ""
    @Published var walk = ""
    
    var recording: RecordingModel
    
    private let recgordRepository: RecordRepository
    private var subscriptions = Set<AnyCancellable>()
    
    init(recordRepository: RecordRepository, recordingModel: RecordingModel) {
        self.recordRepository = recordRepository
        self.recording = recordingModel
    }
    
    func save(completion: @escaping (Result<Record, Error>) -> Void) {
        self.recordRepository.save(record: recording.cancel(), completion: completion)
    }
}
