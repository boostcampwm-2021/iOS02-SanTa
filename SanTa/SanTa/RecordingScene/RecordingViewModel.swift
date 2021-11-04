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
    
    private var recording = RecordingModel()
    private var subscriptions = Set<AnyCancellable>()
    
    init() {
        configureBindings()
    }
    
    private func configureBindings() {
        self.recording.$time
            .receive(on: DispatchQueue.main)
            .sink (receiveValue: { [weak self] time in
                self?.currentTime = time
            })
            .store(in: &self.subscriptions)
        
        self.recording.$kilometer
            .receive(on: DispatchQueue.main)
            .sink (receiveValue: { [weak self] kilometer in
                self?.kilometer = kilometer
            })
            .store(in: &self.subscriptions)
        
        self.recording.$altitude
            .receive(on: DispatchQueue.main)
            .sink (receiveValue: { [weak self] altitude in
                self?.altitude = altitude
            })
            .store(in: &self.subscriptions)
        
        self.recording.$walk
            .receive(on: DispatchQueue.main)
            .sink (receiveValue: { [weak self] walk in
                self?.walk = walk
            })
            .store(in: &self.subscriptions)
    }
    
    func stopRecording() -> Record {
        return self.recording.cancel()
    }
}
