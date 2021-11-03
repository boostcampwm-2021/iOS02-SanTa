//
//  RecordingTimer.swift
//  SanTa
//
//  Created by 김민창 on 2021/11/02.
//

import Foundation
import Combine

class RecordingViewModel: ObservableObject {
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
        recording.$time
            .receive(on: DispatchQueue.main)
            .sink (receiveCompletion: { print ("completion: \($0)") },
                   receiveValue: { [weak self] time in
                self?.currentTime = time
            })
            .store(in: &subscriptions)
        
        recording.$kilometer
            .receive(on: DispatchQueue.main)
            .sink (receiveCompletion: { print ("completion: \($0)") },
                   receiveValue: { [weak self] kilometer in
                self?.kilometer = kilometer
            })
            .store(in: &subscriptions)
        
        recording.$altitude
            .receive(on: DispatchQueue.main)
            .sink (receiveCompletion: { print ("completion: \($0)") },
                   receiveValue: { [weak self] altitude in
                self?.altitude = altitude
            })
            .store(in: &subscriptions)
        
        recording.$walk
            .receive(on: DispatchQueue.main)
            .sink (receiveCompletion: { print ("completion: \($0)") },
                   receiveValue: { [weak self] walk in
                self?.walk = walk
            })
            .store(in: &subscriptions)
    }
    
}
