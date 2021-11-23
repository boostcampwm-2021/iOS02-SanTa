//
//  MountainAddingViewModel.swift
//  SanTa
//
//  Created by shin jae ung on 2021/11/17.
//

import Combine
import CoreLocation
import AVFoundation

class MountainAddingViewModel {
    private var useCase: MountainAddingViewUseCase?
    @Published private(set) var coordinate: CLLocationCoordinate2D?
    private(set) var altitude: CLLocationDistance?
    
    init(useCase: MountainAddingViewUseCase) {
        self.useCase = useCase
    }
    
    func updateUserLocation(coordinate: CLLocationCoordinate2D?, altitude: CLLocationDistance?) {
        self.coordinate = coordinate
        self.altitude = altitude
    }
    
    func addMountain(title: String, description: String) {
        guard let coordinate = coordinate,
              let altitude = altitude
        else { return }
        self.useCase?.saveMountain(
            name: title,
            altitude: altitude,
            latitude: coordinate.latitude,
            longitude: coordinate.longitude,
            description: description,
            completion: { result in
                guard result != nil else {
                    print("저장안됨")
                    return
                }
                print("저장됨")
            }
        )
    }
}
