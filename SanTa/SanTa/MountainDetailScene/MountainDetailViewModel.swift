//
//  MountainDetailViewModel.swift
//  SanTa
//
//  Created by Jiwon Yoon on 2021/11/08.
//

import Foundation

class MountainDetailViewModel {
    private let useCase: MountainDetailUseCase
    var mountainDetail: MountainDetailModel?
    var mountainInfoReceived: (MountainDetailModel) -> Void = { info in }
    
    init(useCase: MountainDetailUseCase) {
        self.useCase = useCase
    }
    
    func setUpViewModel() {
        useCase.transferMountainInformation { [weak self] mountainInfo in
            self?.mountainDetail = mountainInfo
            self?.mountainInfoReceived(mountainInfo)
        }
    }
}
