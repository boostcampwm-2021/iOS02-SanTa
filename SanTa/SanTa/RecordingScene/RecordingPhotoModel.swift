//
//  RecordingPhotoModel.swift
//  SanTa
//
//  Created by 김민창 on 2021/11/15.
//

import Foundation
import UIKit
import Photos

final class RecordingPhotoModel {
    
    private let imageManager = PHImageManager()
    private let thumbnailSize = CGSize(width: 1024, height: 1024)
    
    var representedAssetIdentifier: String?
    
    func fetchPhotos(startDate: Date, endDate: Date) -> [Date]? {
        let allMedia = PHAsset.fetchAssets(with: .image, options: nil)
        
        for i in 0..<allMedia.count {
            let asset = allMedia[i]
            requestIamge(with: asset, thumbnailSize: self.thumbnailSize) { (image) in
//                print(image)
            }
        }
        return nil
    }
    
    func requestIamge(with asset: PHAsset?, thumbnailSize: CGSize, completion: @escaping (Data?) -> Void) {
        guard let asset = asset,
              let date = asset.creationDate else {
            completion(nil)
            return
        }
        print(date)
        self.representedAssetIdentifier = asset.localIdentifier
        
//        self.imageManager.requestImageDataAndOrientation(for: asset, options: nil, resultHandler: { data, str, orientation, info in
//            if self.representedAssetIdentifier == asset.localIdentifier {
//
//            }
//        })
    }
}
