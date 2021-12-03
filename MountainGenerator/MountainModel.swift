//
//  MountainModel.swift
//  MountainGenerator
//
//  Created by Jiwon Yoon on 2021/11/25.
//

import Foundation

struct MountainInfo: Codable {
    let mountainName, mountainRegion, mountainHeight, mountainShortDescription: String
    
    enum CodingKeys: String, CodingKey {
        case mountainName = "MNTN_NM"
        case mountainRegion = "MNTN_LOCPLC_REGION_NM"
        case mountainHeight = "MNTN_HG_VL"
        case mountainShortDescription = "DETAIL_INFO_DTCONT"
    }
}

struct MountainWithLocation: Codable, Hashable {
    let mountain: MountainInfo
    let latitude: Double
    let longitude: Double
    
    enum CodingKeys: String, CodingKey {
        case mountain = "mountain"
        case latitude = "latitude"
        case longitude = "longitude"
    }
    // 위도와 경도가 같을시 같은 데이터로 취급
    func hash(into hasher: inout Hasher) {
        hasher.combine(latitude)
        hasher.combine(longitude)
    }
    
    static func ==(lhs: MountainWithLocation, rhs: MountainWithLocation) -> Bool {
        return lhs.longitude == rhs.longitude && lhs.latitude == rhs.latitude
    }
}
