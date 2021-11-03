//
//  RecordingModel.swift
//  SanTa
//
//  Created by 김민창 on 2021/11/03.
//

import Foundation
import CoreLocation
import CoreMotion
import Combine

class RecordingModel: NSObject, ObservableObject {
    @Published private(set) var time = ""
    @Published private(set) var kilometer = ""
    @Published private(set) var altitude = ""
    @Published private(set) var walk = ""
    
    private let pedoMeter = CMPedometer()
    private var locationManager = CLLocationManager()
    private var timer: DispatchSourceTimer?
    private var date: Date?
    private var location = [Location]()
    
    private var currentTime = 0 {
        didSet {
            self.timeConverter()
            self.checkPedoMeter()
        }
    }
    
    override init() {
        super.init()
        self.date = Date()
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
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
        self.locationManager.delegate = self
    }
    
    private func timeConverter() {
        let seconds = currentTime % 60
        let minutes = (currentTime / 60) % 60
        let hours = (currentTime / 3600)
        
        time = String(format: "%0.2d:%0.2d %0.2d\"", hours, minutes, seconds)
    }
    
    private func checkPedoMeter() {
        guard let date = self.date else { return }
        
        pedoMeter.queryPedometerData(from: date, to: Date()) { [weak self] data, error in
            guard let activityData = data,
                  error == nil else { return }
            
            self?.walk = "\(activityData.numberOfSteps)"
            
            guard let distance = activityData.distance else { return }
            self?.kilometer = "\(distance)"
        }
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

extension RecordingModel: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let lastLocation = locations.last {
            location.append(Location(latitude: Double(lastLocation.coordinate.latitude),
                                     longitude: Double(lastLocation.coordinate.longitude),
                                     altitude: Double(lastLocation.altitude)))
            altitude = "\(lastLocation.altitude)"
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        // GPS를 켜지 않았을 경우
        print(error)
    }
}
