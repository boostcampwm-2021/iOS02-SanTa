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
    func fetchPhotos(startDate: Date?, endDate: Date?) -> [String]
    func pause()
    func resume()
    func fetchOptions()
}

final class DefaultRecordingUseCase: RecordingUseCase, ObservableObject {
    var recording: RecordingModel
    var recordingPhoto: RecordingPhotoModel
    
    private let recordRepository: RecordRepository
    
    init(recordRepository: RecordRepository, recordingModel: RecordingModel, recordingPhoto: RecordingPhotoModel) {
        self.recordRepository = recordRepository
        self.recording = recordingModel
        self.recordingPhoto = recordingPhoto
    }
    
    func pause() {
        self.recording.pause()
    }
    
    func resume() {
        self.recording.resume()
    }
    
    func save(title: String, completion: @escaping (Result<Records, CoreDataError>) -> Void) {
        guard var records = recording.cancel() else {
            completion(.failure(CoreDataError.coreDataError))
            return
        }
        
        let asset = self.fetchPhotos(startDate: records.records.last?.endTime, endDate: records.records.first?.startTime)
        
        records.configureTitle(title: title)
        records.configurePhoto(assetIdentifiers: asset)
        
        self.recordRepository.save(records: records, completion: completion)
    }
    
    func fetchPhotos(startDate: Date?, endDate: Date?) -> [String] {
        guard let startDate = startDate,
              let endDate = endDate else {
                  return [String]()
              }
        
        guard let assets = self.recordingPhoto.fetchPhotos(startDate: startDate, endDate: endDate) else {
            return [String]()
        }
        
        return assets
    }
    
    func fetchOptions() {
        self.recordRepository.fetchVoiceOption(key: Settings.voiceGuidanceEveryOnekm) { result in
            switch result {
            case .failure(_):
                return
            case .success(let status):
                self.recording.changedWillSpeechStatus(status: status)
            }
        }
        
        self.recordRepository.fetchVoiceOption(key: Settings.recordPhoto) { result in
            switch result {
            case .failure(_):
                return
            case .success(let status):
                print(status)
            }
        }
    }
}
