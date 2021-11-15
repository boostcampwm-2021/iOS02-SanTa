//
//  RecordingPhotoModel.swift
//  SanTa
//
//  Created by 김민창 on 2021/11/15.
//

import Foundation
import Photos

final class RecordingPhotoModel {
    
    func fetchPhotos() {
        let allMedia = PHAsset.fetchAssets(with: .image, options: nil)
        print(allMedia)
    }
}
