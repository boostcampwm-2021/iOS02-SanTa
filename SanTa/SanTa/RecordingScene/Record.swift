//
//  Recording.swift
//  SanTa
//
//  Created by CHANGMIN OH on 2021/11/03.
//

import Foundation

struct Record {
    let startTime: [Date]
    let endTime: [Date]
    let step: Int
    let distance: Double
    
    let locations: [Location]
}

struct Location {
    let latitude: Double
    let longitude: Double
    let altitude: Double
}
