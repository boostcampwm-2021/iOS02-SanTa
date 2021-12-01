//
//  MapSceneTests.swift
//  MapSceneTests
//
//  Created by shin jae ung on 2021/11/29.
//

import XCTest
import Combine

class MapSceneTests: XCTestCase {
    var viewModel: MapViewModel!
    var useCase: MapViewUseCase!
    var expectation: XCTestExpectation!
    var observers: [AnyCancellable] = []
    
    class MockRepository: MapViewRepository {
        func fetchMountains(completion: @escaping (Result<[MountainEntity], Error>) -> Void) {
            let mountainDetail = MountainEntity.MountainDetail(
                mountainName: "Name",
                mountainRegion: "Region",
                mountainHeight: "100",
                mountainShortDescription: "Description"
            )
            let mountainEntity = MountainEntity(id: UUID(), mountain: mountainDetail, latitude: 37.3591, longitude: 127.1051)
            let mountainEntities = [mountainEntity]
            completion(.success(mountainEntities))
        }
        
        func fetchMapOption(key: Settings, completion: @escaping (Result<Map, Error>) -> Void) {
            completion(.success(Map.infomation))
        }
    }

    override func setUp() {
        super.setUp()
        self.useCase = MapViewUseCase(repository: MockRepository())
        self.viewModel = MapViewModel(useCase: self.useCase)
        self.expectation = XCTestExpectation(description: "expectation")
    }

    override func tearDown() {
        self.viewModel = nil
        self.useCase = nil
        self.expectation = nil
        super.tearDown()
    }
    
    func test_ViewModel_configureBindings호출시_MountainEntity를_저장함() {
        self.viewModel.$mountains
            .dropFirst()
            .sink(receiveValue: { [weak self] mountains in
                XCTAssertNotNil(mountains, "reposiroty로 부터 [MountainEntity]가 nil로 반환됨")
                XCTAssertTrue(mountains!.count == 1)
                self?.expectation.fulfill()
            })
            .store(in: &observers)
        self.viewModel.configureBindings()
        self.wait(for: [expectation], timeout: 1.0)
    }
    
    func test_ViewModel_viewWillAppear호출시_Map을_저장함() {
        self.viewModel.$map
            .dropFirst()
            .sink(receiveValue: { [weak self] map in
                XCTAssertNotNil(map, "reposiroty로 부터 Map이 nil로 반환됨")
                XCTAssertTrue(map == Map.infomation)
                self?.expectation.fulfill()
            })
            .store(in: &observers)
        self.viewModel.viewWillAppear()
        self.wait(for: [expectation], timeout: 1.0)
    }
}
