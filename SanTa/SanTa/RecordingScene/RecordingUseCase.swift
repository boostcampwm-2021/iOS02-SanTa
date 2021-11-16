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
    func fetchPhotos(startDate: Date?, endDate: Date?, completionFetchImages: @escaping ([Photo]?) -> Void)
    func pause()
    func resume()
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
        records.configureTitle(title: title)
        self.fetchPhotos(startDate: records.records.last?.endTime, endDate: records.records.first?.startTime) { [weak self] images in
            self?.recordRepository.save(records: records, completion: completion)
        }
    }
    
    func fetchPhotos(startDate: Date?, endDate: Date?, completionFetchImages: @escaping ([Photo]?) -> Void) {
        guard let startDate = startDate,
              let endDate = endDate else {
                  completionFetchImages(nil)
                  return
              }
        
        self.recordingPhoto.fetchPhotos(startDate: startDate, endDate: endDate) { images in
            guard let images = images else {
                completionFetchImages(nil)
                return
            }
            completionFetchImages(images)
        }
    }
}
