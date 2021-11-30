//
//  RecordingTimer.swift
//  SanTa
//
//  Created by 김민창 on 2021/11/02.
//

import Foundation
import Combine

protocol RecordingUseCase {
    var recording: RecordingModel? { get set }

    func save(title: String, completion: @escaping (Result<Records, Error>) -> Void)
    func fetchPhotos(startDate: Date?, endDate: Date?) -> [String]
    func pause()
    func resume()
    func saveRecordPhotoOption(value: Bool)
    func fetchOptions()
}

final class RecordingViewModel: ObservableObject {
    @Published var currentTime = ""
    @Published var accessibilityCurrentTime = ""
    @Published var kilometer = ""
    @Published var altitude = ""
    @Published var walk = ""
    @Published var gpsStatus = true
    @Published var motionAuth = true

    private let recordingUseCase: RecordingUseCase?
    private var subscriptions = Set<AnyCancellable>()

    init(recordingUseCase: RecordingUseCase?) {
        self.recordingUseCase = recordingUseCase
        configureBindings()
    }

    private func configureBindings() {
        self.recordingUseCase?.recording?.$time
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] time in
                self?.currentTime = time
            })
            .store(in: &self.subscriptions)

        self.recordingUseCase?.recording?.$accessibilityTime
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] time in
                self?.accessibilityCurrentTime = time
            })
            .store(in: &self.subscriptions)

        self.recordingUseCase?.recording?.$kilometer
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] kilometer in
                self?.kilometer = kilometer
            })
            .store(in: &self.subscriptions)

        self.recordingUseCase?.recording?.$altitude
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] altitude in
                self?.altitude = altitude
            })
            .store(in: &self.subscriptions)

        self.recordingUseCase?.recording?.$walk
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] walk in
                self?.walk = walk
            })
            .store(in: &self.subscriptions)

        self.recordingUseCase?.recording?.$gpsStatus
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] gpsStatus in
                self?.gpsStatus = gpsStatus
            })
            .store(in: &self.subscriptions)

        self.recordingUseCase?.recording?.$motionAuth
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] motionAuth in
                self?.motionAuth = motionAuth
            })
            .store(in: &self.subscriptions)
    }

    func pause() {
        self.recordingUseCase?.pause()
    }

    func resume() {
        self.recordingUseCase?.resume()
    }

    func save(title: String, completion: @escaping (Result<Records, Error>) -> Void) {
        self.recordingUseCase?.save(title: title, completion: completion)
    }

    func saveRecordPhotoOption(value: Bool) {
        self.recordingUseCase?.saveRecordPhotoOption(value: value)
    }

    func fetchOptions() {
        self.recordingUseCase?.fetchOptions()
    }
}
