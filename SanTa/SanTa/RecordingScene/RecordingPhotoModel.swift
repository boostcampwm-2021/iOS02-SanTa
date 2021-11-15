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
    
    var representedAssetIdentifier: String?
    
    func fetchPhotos(startDate: Date, endDate: Date, completion: @escaping ([Data]?) -> Void){
        let allMedia = PHAsset.fetchAssets(with: .image, options: nil)
        
        for i in 0..<allMedia.count {
            let asset = allMedia[i]
            if asset.creationDate == nil || asset.location == nil {
                continue
            }
            
            guard let creationDate = asset.creationDate,
                  let location = asset.location else { return }
            
            requestIamge(with: asset) { (image) in
                print(image)
            }
        }
    }
    
    func requestIamge(with asset: PHAsset?, completion: @escaping (Data?) -> Void) {
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
