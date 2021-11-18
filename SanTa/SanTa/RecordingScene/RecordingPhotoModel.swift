//
//  RecordingPhotoModel.swift
//  SanTa
//
//  Created by 김민창 on 2021/11/15.
//

import Foundation
import Photos

final class RecordingPhotoModel {
    
    private let imageManager = PHImageManager()
    private var willRecordPhoto = false
    
    func fetchPhotos(startDate: Date, endDate: Date) -> [String]? {
        guard self.willRecordPhoto == true else {
            return nil
        }
        
        let allMedia = PHAsset.fetchAssets(with: .image, options: nil)
        var assetIdentifiers = [String]()
        
        for i in stride(from: allMedia.count - 1, through: 0, by: -1) {
            let asset = allMedia[i]
            if asset.creationDate == nil || asset.location == nil {
                continue
            }
            
            guard let creationDate = asset.creationDate else { return nil }
            
            switch startDate.compare(creationDate) {
            case .orderedDescending, .orderedSame:
                switch endDate.compare(creationDate) {
                case .orderedAscending, .orderedSame:
                    assetIdentifiers.append(asset.localIdentifier)
                case .orderedDescending:
                    break
                }
            case .orderedAscending:
                break
            }
        }
        
        return assetIdentifiers
    }
    
    func changedWillRecordPhotoStatus(status: Bool) {
        self.willRecordPhoto = status
    }
}
