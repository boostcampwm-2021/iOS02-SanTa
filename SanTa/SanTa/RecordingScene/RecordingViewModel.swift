//
//  RecordingTimer.swift
//  SanTa
//
//  Created by 김민창 on 2021/11/02.
//

import Foundation
import Combine

final class RecordingViewModel: ObservableObject {
    @Published private(set) var currentTime = ""
    @Published private(set) var kilometer = ""
    @Published private(set) var altitude = ""
    @Published private(set) var walk = ""
    
    private let recordingUseCase: RecordingUseCase?
    private var subscriptions = Set<AnyCancellable>()
    
    init(recordingUseCase: RecordingUseCase) {
        self.recordingUseCase = recordingUseCase
        configureBindings()
    }
    
    private func configureBindings() {
        self.recordingUseCase?.recording.$time
            .receive(on: DispatchQueue.main)
            .sink (receiveValue: { [weak self] time in
                self?.currentTime = time
            })
            .store(in: &self.subscriptions)
        
        self.recordingUseCase?.recording.$kilometer
            .receive(on: DispatchQueue.main)
            .sink (receiveValue: { [weak self] kilometer in
                self?.kilometer = kilometer
            })
            .store(in: &self.subscriptions)
        
        self.recordingUseCase?.recording.$altitude
            .receive(on: DispatchQueue.main)
            .sink (receiveValue: { [weak self] altitude in
                self?.altitude = altitude
            })
            .store(in: &self.subscriptions)
        
        self.recordingUseCase?.recording.$walk
            .receive(on: DispatchQueue.main)
            .sink (receiveValue: { [weak self] walk in
                self?.walk = walk
            })
            .store(in: &self.subscriptions)
    }
    
    func pause() {
        self.recordingUseCase?.pause()
    }
    
    func resume() {
        self.recordingUseCase?.resume()
    }
    
    func save(title: String, completion: @escaping (Result<Records, CoreDataError>) -> Void) {
        self.recordingUseCase?.save(title: title, completion: completion)
    }
}
