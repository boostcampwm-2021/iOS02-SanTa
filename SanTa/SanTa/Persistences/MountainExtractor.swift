//
//  MountainExtractor.swift
//  SanTa
//
//  Created by Jiwon Yoon on 2021/11/03.
//

import Foundation
import UIKit

final class MountainExtractor {

    enum ExtractError: Error {
        case extractionFailed
    }

    func extract(completion: @escaping (Result<NSDataAsset, Error>) -> Void) {
        guard let dataAsset = NSDataAsset(name: "MountainsWithLocation") else {
            return completion(.failure(ExtractError.extractionFailed))
        }

        completion(.success(dataAsset))
    }
}
