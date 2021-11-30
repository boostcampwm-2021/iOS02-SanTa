//
//  MountainAddingViewModel.swift
//  SanTa
//
//  Created by shin jae ung on 2021/11/17.
//

import Combine
import CoreLocation
import AVFoundation

final class MountainAddingViewModel {
    private var useCase: MountainAddingViewUseCase?
    @Published private(set) var coordinate: CLLocationCoordinate2D?
    private(set) var altitude: CLLocationDistance?
    let addMountainResult = PassthroughSubject<AddMountainResult, Never>()

    enum AddMountainResult: String {
        case success = "저장에 성공하였습니다."
        case failure = "저장에 실패하였습니다."
    }

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
        self.useCase?.saveMountain(name: title, altitude: altitude, latitude: coordinate.latitude, longitude: coordinate.longitude, description: description) { [weak self] result in
            guard result != nil else {
                self?.addMountainResult.send(.failure)
                return
            }
            self?.addMountainResult.send(.success)
        }
    }
}
