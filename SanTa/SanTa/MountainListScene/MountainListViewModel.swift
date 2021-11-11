//
//  MountainListViewModel.swift
//  SanTa
//
//  Created by 김민창 on 2021/11/11.
//

import Combine

final class MountainListViewModel {
    @Published private(set) var mountains: [MountainEntity]?
    
    private let useCase: MountainListUseCase
    
    init(useCase: MountainListUseCase) {
        self.useCase = useCase
    }
    
    func viewDidLoad() {
        self.useCase.prepareMountainList { [weak self] mountains in
            self?.mountains = mountains
        }
    }
    
    func findMountains(name: String) {
        
    }
}
