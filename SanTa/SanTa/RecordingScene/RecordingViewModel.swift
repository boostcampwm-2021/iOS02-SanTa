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
    
    private var recording: RecordingModel?
    
    init() {
        recording = RecordingModel()
    }
    
}
