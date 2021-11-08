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
    
//    func mountainName() -> String {
//        return self.mountainDetail.moutainName
//    }
//
//    func distanceToMountainFromCurrentLocation() -> Double? {
//        return self.mountainDetail.distance
//    }
//
//    func mountainRegions() -> [String] {
//        return self.mountainDetail.regions
//    }
//
//    func altitude() -> String {
//        return self.mountainDetail.altitude + "m"
//    }
//
//    func mountainDescription() -> String {
//        return self.mountainDetail.mountainDescription
//    }
//
//    func latitude() -> Double {
//        return self.mountainDetail.latitude
//    }
//
//    func longitude() -> Double {
//        return self.mountainDetail.longitude
//    }
}
