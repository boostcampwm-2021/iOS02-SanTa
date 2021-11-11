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
    private var entireMountains: [MountainEntity]?
    
    init(repository: MountainListViewRepository) {
        self.repository = repository
    }
    
    func prepareMountainList(completion: @escaping ([MountainEntity]?) -> Void) {
        guard self.entireMountains == nil else {
            completion(self.entireMountains)
            return
        }
        
        self.repository.fetchMountains { result in
            switch result {
            case .failure(let error):
                os_log(.error, log: .default, "\(error.localizedDescription)")
                completion(nil)
            case .success(let mountains):
                self.entireMountains = mountains
                completion(mountains)
            }
        }
    }
    
    func findMountains(name: String, completion: @escaping ([MountainEntity]?) -> Void) {
        guard self.entireMountains == nil else {
            return
        }
        
        completion(entireMountains?.filter {  $0.mountain.mountainName == name })
    }
}
