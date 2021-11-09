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

final class RecordingModel: NSObject, ObservableObject {
    @Published private(set) var time = ""
    @Published private(set) var kilometer = ""
    @Published private(set) var altitude = ""
    @Published private(set) var walk = ""
    
    private let pedoMeter = CMPedometer()
    private var locationManager = CLLocationManager()
    private var timer: DispatchSourceTimer?
    private var records: Records?
    private var startDate: Date?
    private var currentWalk = 0
    private var currentKilo: Double = 0
    private var location = [Location]()
    
    private var currentTime = Date() {
        didSet {
            self.timeConverter()
            self.checkPedoMeter()
        }
    }
    
    override init() {
        super.init()
        self.startDate = Date()
        self.configureTimer()
        self.configureLocationManager()
    }
    
    private func configureTimer() {
        self.timer = DispatchSource.makeTimerSource(flags: [], queue: DispatchQueue.main)
        self.timer?.schedule(deadline: .now(), repeating: 1)
        self.timer?.setEventHandler(handler: { [weak self] in
            self?.currentTime = Date()
        })
        
        self.resume()
    }
    
    private func configureLocationManager() {
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.startUpdatingLocation()
        self.locationManager.allowsBackgroundLocationUpdates = true
        self.locationManager.pausesLocationUpdatesAutomatically = false
        self.locationManager.showsBackgroundLocationIndicator = true
        self.locationManager.delegate = self
    }
    
    private func timeConverter() {
        guard let startDate = self.startDate else { return }
        
        let elapsedTimeSeconds = Int(self.currentTime.timeIntervalSince(startDate))

        let seconds = elapsedTimeSeconds % 60
        let minutes = (elapsedTimeSeconds / 60) % 60
        let hours = (elapsedTimeSeconds / 3600)
        
        time = String(format: "%0.2d:%0.2d %0.2d\"", hours, minutes, seconds)
    }
    
    private func checkPedoMeter() {
        guard let date = self.startDate else { return }
        
        pedoMeter.queryPedometerData(from: date, to: self.currentTime) { [weak self] data, error in
            guard let activityData = data,
                  error == nil else { return }
            
            self?.walk = "\(activityData.numberOfSteps)"
            
            guard let walk = self?.walk,
                  let walkNumber = Int(walk) else { return }
            
            self?.currentWalk = walkNumber
            
            guard let distance = activityData.distance else { return }
            let transformatKilometer = Double(truncating: distance) / 1000
            self?.currentKilo = transformatKilometer
            let distanceString = String(format: "%.2f", transformatKilometer)
            
            self?.kilometer = "\(distanceString)"
        }
    }
    
    private func appendRecord() {
        guard let startdate = self.startDate else { return }
        let record = Record(startTime: startdate,
                            endTime: self.currentTime,
                            step: self.currentWalk,
                            distance: self.currentKilo,
                            locations: self.location)
        
        guard self.records != nil else {
            
            self.records = Records(title: nil, record: [record])
            return
        }
        
        self.records?.record.append(record)
    }
    
    func pause() {
        self.appendRecord()
        self.timer?.suspend()
        self.locationManager.stopUpdatingLocation()
        self.startDate = nil
    }
    
    func resume() {
        self.timer?.resume()
        self.locationManager.startUpdatingLocation()
        self.startDate = Date()
    }
    
    func cancel() -> Records? {
        guard let records = self.records else { return nil }
    
        timer?.cancel()
        timer = nil
        
        return records
    }
}

extension RecordingModel: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let lastLocation = locations.last {
            location.append(Location(latitude: Double(lastLocation.coordinate.latitude),
                                     longitude: Double(lastLocation.coordinate.longitude),
                                     altitude: Double(lastLocation.altitude)))
            altitude = "\(Int(lastLocation.altitude))"
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        // GPS를 켜지 않았을 경우
        print(error)
    }
}
