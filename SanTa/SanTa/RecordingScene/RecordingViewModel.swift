//
//  RecordingTimer.swift
//  SanTa
//
//  Created by 김민창 on 2021/11/02.
//

import Foundation
import CoreLocation
import Combine

class RecordingViewModel: NSObject {
    private var locationManager = CLLocationManager()
    private var timer: DispatchSourceTimer?
    
    private var currentTime = 0 {
        didSet {
            self.timeConverter()
        }
    }
    
    override init() {
        super.init()
        self.configureTimer()
        self.configureLocationManager()
    }
    
    private func configureTimer() {
        self.timer = DispatchSource.makeTimerSource(flags: [], queue: DispatchQueue.main)
        self.timer?.schedule(deadline: .now(), repeating: 1)
        self.timer?.setEventHandler(handler: { [weak self] in
            self?.currentTime += 1
        })
        
        self.resume()
    }
    
    private func configureLocationManager() {
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        locationManager.delegate = self
    }
    
    private func timeConverter() {
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

extension RecordingViewModel: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let lastLocation = locations.last {
            print("위도: \(lastLocation.coordinate.latitude)")
            print("경도: \(lastLocation.coordinate.longitude)")
            print("고도: \(lastLocation.altitude)")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        // GPS를 켜지 않았을 경우
        print(error)
    }
}
