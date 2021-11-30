//
//  DefaultSaveRecordUseCase.swift
//  SanTa
//
//  Created by CHANGMIN OH on 2021/11/03.
//

import Foundation

protocol RecordRepository {
    func save(records: Records,
              completion: @escaping (Result<Records, Error>) -> Void)
    func saveRecordPhotoOption(value: Bool)
    func fetchRecordOption(key: Settings, completion: @escaping (Result<Bool, Error>) -> Void)
}

enum RecordingViewModelError: Error {
    case FetchError
}

final class DefaultRecordingUseCase: RecordingUseCase, ObservableObject {
    var recording: RecordingModel?
    var recordingPhoto: RecordingPhotoModel

    private let recordRepository: RecordRepository

    init(recordRepository: RecordRepository, recordingModel: RecordingModel?, recordingPhoto: RecordingPhotoModel) {
        self.recordRepository = recordRepository
        self.recording = recordingModel
        self.recordingPhoto = recordingPhoto
    }

    func pause() {
        self.recording?.pause()
    }

    func resume() {
        self.recording?.resume()
    }

    func save(title: String, completion: @escaping (Result<Records, Error>) -> Void) {
        guard var records = recording?.cancel() else {

            completion(.failure(RecordingViewModelError.FetchError))
            return
        }

        let asset = self.fetchPhotos(startDate: records.records.last?.endTime, endDate: records.records.first?.startTime)

        records.configureTitle(title: title)
        records.configurePhoto(assetIdentifiers: asset)

        self.recordRepository.save(records: records, completion: completion)
    }

    func saveRecordPhotoOption(value: Bool) {
        self.recording?.changedWillSpeechStatus(status: value)
        self.recordRepository.saveRecordPhotoOption(value: value)
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
        self.recordRepository.fetchRecordOption(key: Settings.voiceGuidanceEveryOnekm) { result in
            switch result {
            case .failure:
                return
            case .success(let status):
                self.recording?.changedWillSpeechStatus(status: status)
            }
        }

        self.recordRepository.fetchRecordOption(key: Settings.recordPhoto) { result in
            switch result {
            case .failure:
                return
            case .success(let status):
                self.recordingPhoto.changedWillRecordPhotoStatus(status: status)
            }
        }
    }
}
