//
//  MountainEntity.swift
//  SanTa
//
//  Created by Jiwon Yoon on 2021/11/03.
//

import Foundation

struct MountainEntity: Codable {
    
    struct MountainDetail: Codable {
        let mountainName, mountainRegion, mountainHeight, mountainShortDescription: String
        
        enum CodingKeys: String, CodingKey {
            case mountainName = "MNTN_NM"
            case mountainRegion = "MNTN_LOCPLC_REGION_NM"
            case mountainHeight = "MNTN_HG_VL"
            case mountainShortDescription = "DETAIL_INFO_DTCONT"
        }
    }
    
    let mountain: MountainDetail
    let latitude: Double
    let longitude: Double
    
    enum CodingKeys: String, CodingKey {
        case mountain = "mountain"
        case latitude = "latitude"
        case longitude = "longitude"
    }
}
