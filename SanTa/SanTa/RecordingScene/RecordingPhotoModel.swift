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
    
    func fetchPhotos(startDate: Date, endDate: Date, completion: @escaping ([Photo]?) -> Void){
        let allMedia = PHAsset.fetchAssets(with: .image, options: nil)
        let dispatchGroup = DispatchGroup()
        var photos = [Photo]()
        
        dispatchGroup.enter()
        for i in stride(from: allMedia.count - 1, through: 0, by: -1) {
            let asset = allMedia[i]
            if asset.creationDate == nil || asset.location == nil {
                continue
            }
            
            guard let creationDate = asset.creationDate,
                  let location = asset.location else { return }
            
            switch startDate.compare(creationDate) {
            case .orderedDescending, .orderedSame:
                switch endDate.compare(creationDate) {
                case .orderedAscending, .orderedSame:
                    dispatchGroup.enter()
                    requestIamge(with: asset) { (image) in
                        guard let image = image else { return }
                        let photo = Photo(latitude: Double(location.coordinate.latitude), longitude: Double(location.coordinate.longitude), date: image)
                        photos.append(photo)
                        dispatchGroup.leave()
                    }
                case .orderedDescending:
                    break
                }
            case .orderedAscending:
                break
            }
        }
        
        dispatchGroup.leave()
        dispatchGroup.notify(queue: .global()) {
            completion(photos)
        }
    }
    
    func requestIamge(with asset: PHAsset?, completion: @escaping (Data?) -> Void) {
        guard let asset = asset else {
            completion(nil)
            return
        }
        
        self.representedAssetIdentifier = asset.localIdentifier
        
        self.imageManager.requestImageDataAndOrientation(for: asset, options: nil, resultHandler: { data, str, orientation, info in
            if self.representedAssetIdentifier == asset.localIdentifier {
                completion(data)
            }
        })
    }
}
