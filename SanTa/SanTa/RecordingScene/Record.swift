//
//  Record.swift
//  SanTa
//
//  Created by 김민창 on 2021/11/03.
//

import Foundation

struct Record {
    let time: String
    let step: String
    let distance: String?
    
    let locations: [Location]
}

struct Location {
    let latitude: Double
    let longitude: Double
    let altitude: Double
}
