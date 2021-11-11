//
//  MountainListUseCase.swift
//  SanTa
//
//  Created by 김민창 on 2021/11/11.
//

import Foundation
import OSLog

final class MountainListUseCase {
    private let repository: MountainListViewRepository
    
    init(repository: MountainListViewRepository) {
        self.repository = repository
    }
    
    func prepareMountainList(completion: @escaping ([MountainEntity]?) -> Void) {
        self.repository.fetchMountains { result in
            switch result {
            case .failure(let error):
                os_log(.error, log: .default, "\(error.localizedDescription)")
                completion(nil)
            case .success(let mountains):
                completion(mountains)
            }
        }
    }
}
