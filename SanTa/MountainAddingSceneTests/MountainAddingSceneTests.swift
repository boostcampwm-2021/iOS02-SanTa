//
//  MountainAddingSceneTests.swift
//  MountainAddingSceneTests
//
//  Created by shin jae ung on 2021/11/30.
//

import XCTest
import Combine
import CoreLocation

class MountainAddingSceneTests: XCTestCase {
    var viewModel: MountainAddingViewModel!
    var useCase: MountainAddingViewUseCase!
    var expectation: XCTestExpectation!
    var coordinate: CLLocationCoordinate2D!
    var altitude: CLLocationDistance!
    var observers: [AnyCancellable] = []
    
    class MockRepository: MountainAddingRepository {
        func save(_ mountainEntity: MountainEntity, completion: @escaping (Result<Void, Error>) -> Void) {
            completion(.success(Void()))
        }
    }

    override func setUp() {
        super.setUp()
        self.useCase = MountainAddingViewUseCase(repository: MockRepository())
        self.viewModel = MountainAddingViewModel(useCase: useCase)
        self.expectation = XCTestExpectation(description: "expectation")
        self.coordinate = CLLocationCoordinate2D(latitude: 0, longitude: 0)
        self.altitude = 0
    }

    override func tearDown() {
        self.viewModel = nil
        self.useCase = nil
        self.expectation = nil
        super.tearDown()
    }
    
    func test_ViewModel_updateUserLocation_호출시_위치를_저장함() {
        self.viewModel.$coordinate
            .dropFirst()
            .sink(receiveValue: { [weak self] coordinate in
                XCTAssertNotNil(coordinate, "updateUserLocation에서 coordinate가 올바르게 저장되지 않음")
                self?.expectation.fulfill()
            })
            .store(in: &observers)
        self.viewModel.updateUserLocation(coordinate: self.coordinate, altitude: self.altitude)
        self.wait(for: [expectation], timeout: 1.0)
    }

    func test_ViewModel_addMountain_호출시_산을_추가함() {
        self.viewModel.updateUserLocation(coordinate: self.coordinate, altitude: self.altitude)
        self.viewModel.addMountainResult
            .sink(receiveValue: { [weak self] result in
                XCTAssertNotNil(result, "repository로 부터 AddingMountainResult가 nil로 반환됨")
                XCTAssertEqual(result, .success, "산이 추가되지 않음")
                self?.expectation.fulfill()
            })
            .store(in: &self.observers)
        self.viewModel.addMountain(title: "산", description: "설명")
        self.wait(for: [expectation], timeout: 1.0)
    }
}
