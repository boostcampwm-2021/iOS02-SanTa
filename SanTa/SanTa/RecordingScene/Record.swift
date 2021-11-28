//
//  Recording.swift
//  SanTa
//
//  Created by CHANGMIN OH on 2021/11/03.
//

import Foundation
import CoreLocation

class TotalRecords {
    private(set) var totalRecords: [DateSeperateRecords] = []
    
    private var mappingDateSeperateRecords: [String : DateSeperateRecords] = [:]
    
    var totalDistances: Double {
        return totalRecords.reduce(0) { $0 + $1.distances }
    }
    
    var sectionCount: Int {
        return totalRecords.count
    }
    
    var totalCount: Int {
        return totalRecords.reduce(0) { $0 + $1.count }
    }
    
    var totalTimes: TimeInterval {
        return totalRecords.reduce(0) { $0 + $1.times }
    }
    
    var totalSteps: Int {
        return totalRecords.reduce(0) { $0 + $1.steps }
    }
    
    subscript(section: Int) -> DateSeperateRecords? {
        guard self.totalCount > section else { return nil }
        return totalRecords[section]
    }
    
    func add(records: Records) {
        guard let date = records.date else { return }
        let year = Calendar.current.component(.year, from: date)
        let month = Calendar.current.component(.month, from: date)
        let key = "\(year)\(month)"
        
        if let seperateDateRecords = self.mappingDateSeperateRecords[key] {
            seperateDateRecords.add(records: records)
        } else {
            let seperateDateRecords = DateSeperateRecords(year: year, month: month)
            seperateDateRecords.add(records: records)
            self.mappingDateSeperateRecords[key] = seperateDateRecords
            self.totalRecords.append(seperateDateRecords)
        }
    }
}

class DateSeperateRecords {
    let year: Int
    let month: Int
    
    private(set) var dateSeperateRecords: [Records] = []
    
    subscript(item: Int) -> Records? {
        guard self.count > item else { return nil }
        return dateSeperateRecords[item]
    }
    
    init(year: Int, month: Int) {
        self.year = year
        self.month = month
    }
    
    var distances: Double {
        return dateSeperateRecords.reduce(0) { $0 + $1.distances }
    }
    
    var count: Int {
        return dateSeperateRecords.count
    }
    
    var times: TimeInterval {
        return dateSeperateRecords.reduce(0) { $0 + $1.times }
    }
    
    var steps: Int {
        return dateSeperateRecords.reduce(0) { $0 + $1.steps }
    }
    
    func add(records: Records) {
        self.dateSeperateRecords.append(records)
    }
}


struct Records {
    private(set) var title: String
    private(set) var records: [Record]
    private(set) var assetIdentifiers: [String]
    private(set) var secondPerHighestSpeed: Int
    private(set) var secondPerMinimumSpeed: Int
    private(set) var id: String
    
    
    
    var date: Date? {
        return records.last?.endTime
    }
    
    var distances: Double {
        return records.reduce(0) { $0 + $1.distance }
    }
    
    var times: TimeInterval {
        return records.reduce(0) { $0 + $1.time }
    }
    
    var steps: Int {
        return records.reduce(0) { $0 + $1.step }
    }
    
    var maxAltitude: Double {
        guard let max = records.compactMap({ $0.maxAltitude }).max() else {
            return 0
        }
        return max
    }
    
    var minAltitude: Double {
        guard let min = records.compactMap({ $0.minAltitude }).min() else {
            return 0
        }
        return min
    }
    
    var maxAltitudeDifference: Double {
        guard let max = records.compactMap({ $0.maxAltitude }).max(),
              let min = records.compactMap({ $0.minAltitude }).min()
        else {
            return 0
        }
        return max - min
    }
    
    mutating func configureTitle(title: String) {
        self.title = title
    }
    
    mutating func configurePhoto(assetIdentifiers: [String]) {
        self.assetIdentifiers = assetIdentifiers
    }
    
    mutating func add(record: Record) {
        self.records.append(record)
    }
}

struct Record {
    let startTime: Date
    let endTime: Date
    let step: Int
    let distance: Double
    let locations: [Location]
    
    var time: TimeInterval {
        return endTime.timeIntervalSinceReferenceDate - startTime.timeIntervalSinceReferenceDate
    }
    
    var minAltitude: Double? {
        return locations.map{ $0.altitude }.min()
    }
    
    var maxAltitude: Double? {
        return locations.map{ $0.altitude }.max()
    }
}

struct Location {
    let latitude: Double
    let longitude: Double
    let altitude: Double
    
    func distance(to: Location) -> Double {
        let current = CLLocation(latitude: self.latitude, longitude: self.longitude)
        let destination = CLLocation(latitude: to.latitude, longitude: to.longitude)
        
        return abs(current.distance(from: destination))
    }
}

struct Locations {
    private(set) var locations: [Location]
    
    init(locations: [Location]) {
        self.locations = locations
    }
    
    func totalUphillDistance() -> Double {
        var uphillDistance: Double = 0
        var prevLocation: Location? = nil
        for location in locations {
            if let prevLocation = prevLocation {
                let distance = location.distance(to: prevLocation)
                if location.altitude > prevLocation.altitude {
                    uphillDistance += distance
                }
            }
            prevLocation = location
        }
        
        return uphillDistance
    }
    
    func totalDownhillDistance() -> Double {
        var downhillDistance: Double = 0
        var prevLocation: Location? = nil
        for location in locations {
            if let prevLocation = prevLocation {
                let distance = location.distance(to: prevLocation)
                if location.altitude < prevLocation.altitude {
                    downhillDistance += distance
                }
            }
            prevLocation = location
        }
        
        return downhillDistance
    }
    
    func totalPlainDistance() -> Double {
        var plainDistance: Double = 0
        var prevLocation: Location? = nil
        for location in locations {
            if let prevLocation = prevLocation {
                let distance = location.distance(to: prevLocation)
                if location.altitude == prevLocation.altitude {
                    plainDistance += distance
                }
            }
            prevLocation = location
        }
        
        return plainDistance
    }
    
    func totalIncline() -> Double {
        var incline: Double = 0
        var prevLocation: Location? = nil
        
        for location in locations {
            if let prevLocation = prevLocation {
                let distanceDelta = location.distance(to: prevLocation)
                let altitudeDelta = location.altitude > prevLocation.altitude ? location.altitude - prevLocation.altitude : 0
                if distanceDelta != 0 {
                    incline += atan(altitudeDelta / distanceDelta)
                }
            }
            prevLocation = location
        }
        
        return incline
    }
    
    func steepestIncline() -> Double {
        var steepest: Double = 0
        var prevLocation: Location? = nil
        
        for location in locations {
            if let prevLocation = prevLocation {
                let distanceDelta = location.distance(to: prevLocation)
                let altitudeDelta = location.altitude > prevLocation.altitude ? location.altitude - prevLocation.altitude : 0
                if distanceDelta != 0 {
                    let incline = atan(altitudeDelta / distanceDelta)
                    steepest = max(incline, steepest)
                }
            }
            prevLocation = location
        }
        return steepest
    }
}
