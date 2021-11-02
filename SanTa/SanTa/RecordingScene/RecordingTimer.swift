//
//  RecordingTimer.swift
//  SanTa
//
//  Created by 김민창 on 2021/11/02.
//

import Foundation


final class RecordingTimer {
    var timer: DispatchSourceTimer?
    
    var currentTime = 0 {
        didSet {
            self.timerConverter()
        }
    }
    
    init() {
        self.timer = DispatchSource.makeTimerSource(flags: [], queue: DispatchQueue.main)
        self.timer?.schedule(deadline: .now(), repeating: 1)
        self.timer?.setEventHandler(handler: { [weak self] in
            self?.currentTime += 1
        })
        
        self.resume()
    }
    
    private func timerConverter() {
        let seconds = currentTime % 60
        let minutes = (currentTime / 60) % 60
        let hours = (currentTime / 3600)
        
        print(NSString(format: "%0.2d:%0.2d %0.2d\"", hours, minutes, seconds))
    }
    
    func suspend() {
        timer?.suspend()
    }
    
    func resume() {
        timer?.resume()
    }
    
    func cancel() {
        timer?.cancel()
        timer = nil
    }
}
