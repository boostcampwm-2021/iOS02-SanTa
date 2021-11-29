//
//  ResultDetailModel.swift
//  SanTa
//
//  Created by Jiwon Yoon on 2021/11/16.
//

import Foundation
import CoreLocation

struct ResultDetailData {
    let timeStamp: ResultTimeStamp
    let distance: ResultDistance
    let time: ResultTime
    let pace: ResultPace
    let altitude: ResultAltitude
    let incline: ResultIncline
    let id: String
    let assetIdentifiers: [String]
    let coordinates: [[CLLocationCoordinate2D]]
    private(set) var title: String
    
    init(records: Records) {
        self.timeStamp = ResultTimeStamp(records: records)
        self.distance = ResultDistance(records: records)
        self.time = ResultTime(records: records)
        self.pace = ResultPace(records: records)
        self.altitude = ResultAltitude(records: records)
        self.incline = ResultIncline(records: records)
        self.id = records.id
        self.title = records.title
        self.assetIdentifiers = records.assetIdentifiers
        var locations: [[CLLocationCoordinate2D]] = []
        records.records.forEach{locations.append($0.locations.coordinates)}
        self.coordinates = locations
    }
    
    mutating func change(title: String) {
        self.title = title
    }
}

struct ResultTimeStamp {
    let startTime: Date
    let endTime: Date
    let startLocation: Location?
    let endLocation: Location?
    
    init(records: Records) {
        self.startTime = records.records.first?.startTime ?? Date.distantPast
        self.endTime = records.records.last?.endTime ?? Date.distantFuture
        self.startLocation = records.records.first?.locations.startLocation
        self.endLocation = records.records.last?.locations.endLocation
    }
}

struct ResultDistance {
    let total: Double
    let steps: Int
    
    init(records: Records) {
        self.steps = records.steps
        guard let totalDistance = records.records.last?.distance else {
            self.total = 0
            return
        }
        self.total = totalDistance
    }
}

struct ResultTime {
    let spent: TimeInterval
    let active: TimeInterval
    let inactive: TimeInterval
    
    init(records: Records) {
        var inactive: TimeInterval = 0
        for index in 0..<records.records.count - 1 {
            inactive += records.records[index].endTime.timeIntervalSince(records.records[index+1].startTime)
        }
        self.active = records.records.map{$0.endTime.timeIntervalSince($0.startTime)}.reduce(0, +)
        self.inactive = inactive
        self.spent = records.times
    }
}

struct ResultPace {
    let timePerKilometer: TimeInterval
    let fastestPace: TimeInterval
    let slowestPace: TimeInterval
    
    init(records: Records) {
        self.timePerKilometer = records.distances / records.times / 1000
        self.fastestPace = TimeInterval(records.secondPerHighestSpeed)
        self.slowestPace = TimeInterval(records.secondPerMinimumSpeed)
    }
}

struct ResultAltitude {
    let total: Int
    let highest: Int
    let lowest: Int
    let starting: Int
    let ending: Int
    
    init(records: Records) {
        var paths: [Locations] = []
        for record in records.records {
            paths.append(record.locations)
        }
        var maxAltitude: Int = Int.min
        var minAltitude: Int = Int.max
        for path in paths {
            maxAltitude = max(Int(round(path.maxAltitude)), Int(maxAltitude))
            minAltitude = min(Int(round(path.minAltitude)), Int(minAltitude))
        }
        
        self.total = maxAltitude - minAltitude
        self.highest = maxAltitude
        self.lowest = minAltitude
        self.starting = Int(round(paths.first?.firstAltitude ?? 0))
        self.ending = Int(round(paths.last?.lastAltitude ?? 0))
    }
}

struct ResultIncline {
    let average: Int
    let highest: Int
    let uphillKilometer: Double
    let downhillKilometer: Double
    let plainKilometer: Double
    
    init(records: Records) {
        var totalIncline: Double = 0
        var steepest: Double = 0
        var uphillDistance: Double = 0
        var downHillDistance: Double = 0
        var plainDistance: Double = 0
        
        var paths: [Locations] = []
        for record in records.records {
            paths.append(record.locations)
        }
        
        for locations in paths {
            
            totalIncline += locations.totalIncline()
            steepest = locations.steepestIncline()
            uphillDistance += locations.totalUphillDistance()
            downHillDistance += locations.totalDownhillDistance()
            plainDistance += locations.totalPlainDistance()
        }
        
        self.average = paths.count > 1 ? Int(totalIncline / Double(paths.count - 1)) : 0
        self.highest = Int(steepest)
        self.uphillKilometer = uphillDistance / 1000
        self.downhillKilometer = downHillDistance / 1000
        self.plainKilometer = plainDistance / 1000
    }
}
