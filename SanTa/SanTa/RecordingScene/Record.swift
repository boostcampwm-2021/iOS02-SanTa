//
//  Recording.swift
//  SanTa
//
//  Created by CHANGMIN OH on 2021/11/03.
//

import Foundation

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
    
    var maxAltitudeDifference: Double {
        let max = records.max { $0.altitudeDifference < $1.altitudeDifference }
        return (max?.altitudeDifference ?? 0)
    }
    
    mutating func configureTitle(title: String) {
        self.title = title
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

    var altitudeDifference: Double {
        let min = locations.min { $0.altitude < $1.altitude }
        let max = locations.max { $0.altitude < $1.altitude }
        return (max?.altitude ?? 0) - (min?.altitude ?? 0)
    }
}

struct Location {
    let latitude: Double
    let longitude: Double
    let altitude: Double
}
