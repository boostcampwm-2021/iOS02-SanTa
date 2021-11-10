//
//  Option.swift
//  SanTa
//
//  Created by CHANGMIN OH on 2021/11/08.
//

import Foundation

enum Map: String, CaseIterable {

    case infomation = "정보지도"
    case normal = "일반지도"
    case satellite = "위성지도"
    
    var name: String {
        return self.rawValue
    }
}

protocol Option {
    var text: String { get }
}

struct ToggleOption: Option {
    let text: String
    let toggle: Bool
}

struct MapOption: Option {
    let text: String
    let map: Map
}
