//
//  MountainListSceneTestss.swift
//  MountainListSceneTestss
//
//  Created by 김민창 on 2021/11/30.
//

import XCTest

final class MountainListSceneTests: XCTestCase {
    
    private var successUseCase: MountainListUseCase!
    private var failUseCase: MountainListUseCase!
    private var successViewModel: MountainListViewModel!
    private var failViewModel: MountainListViewModel!
    
    enum TestError: Error {
        case error
    }
    
    class SuccessMountainViewRepository: MountainListViewRepository {
        func fetchMountains(completion: @escaping (Result<[MountainEntity], Error>) -> Void) {
            let mountainList = [MountainEntity(mountain: MountainEntity.MountainDetail(mountainName: "한라산", mountainRegion: "", mountainHeight: "", mountainShortDescription: "제주도에 있습니다."), latitude: 0, longitude: 0),
                                MountainEntity(mountain: MountainEntity.MountainDetail(mountainName: "토함산", mountainRegion: "", mountainHeight: "", mountainShortDescription: "경주에 있습니다."), latitude: 0, longitude: 0)]
            completion(.success(mountainList))
        }
    }
    
    class FailMountainViewRepository: MountainListViewRepository {
        func fetchMountains(completion: @escaping (Result<[MountainEntity], Error>) -> Void) {
            completion(.failure(TestError.error))
        }
    }
    
    override func setUp() {
        self.successUseCase = MountainListUseCase(repository: SuccessMountainViewRepository())
        self.failUseCase = MountainListUseCase(repository: FailMountainViewRepository())
        self.successViewModel = MountainListViewModel(useCase: successUseCase)
        self.failViewModel = MountainListViewModel(useCase: failUseCase)
    }
    
    func test_MountainList_가져오기_성공() {
        successViewModel.viewDidLoad()
        _ = XCTWaiter.wait(for: [expectation(description: "Wait for 0.1 seconds")], timeout: 0.1)
        XCTAssertNotNil(successViewModel.mountains)
    }
    
    func test_MountainList_가져오기_실패() {
        failViewModel.viewDidLoad()
        _ = XCTWaiter.wait(for: [expectation(description: "Wait for 0.1 seconds")], timeout: 0.1)
        XCTAssertNil(failViewModel.mountains)
    }
    
    func test_MountainList_산_개수_비교_성공() {
        successViewModel.viewDidLoad()
        _ = XCTWaiter.wait(for: [expectation(description: "Wait for 0.1 seconds")], timeout: 0.1)
        XCTAssertTrue(!successViewModel.mountains!.isEmpty)
    }
    
    func test_MountainList_산_개수_비교_실패() {
        successViewModel.viewDidLoad()
        _ = XCTWaiter.wait(for: [expectation(description: "Wait for 0.1 seconds")], timeout: 0.1)
        XCTAssertFalse(successViewModel.mountains?.count == 0)
    }
    
    func test_MountainList_첫번째_산_이름_비교_성공() {
        successViewModel.viewDidLoad()
        _ = XCTWaiter.wait(for: [expectation(description: "Wait for 0.1 seconds")], timeout: 0.1)
        XCTAssertTrue(successViewModel.mountains?[0].mountain.mountainName == "한라산")
    }
    
    func test_MountainList_첫번째_산_이름_비교_실패() {
        successViewModel.viewDidLoad()
        _ = XCTWaiter.wait(for: [expectation(description: "Wait for 0.1 seconds")], timeout: 0.1)
        XCTAssertFalse(successViewModel.mountains?[0].mountain.mountainName == "")
    }
    
    func test_MountainList_토함산_찾기_성공() {
        successViewModel.viewDidLoad()
        successViewModel.mountainName = "토함산"
        
        successViewModel.findMountains()
        _ = XCTWaiter.wait(for: [expectation(description: "Wait for 0.1 seconds")], timeout: 0.1)
        
        
        XCTAssertTrue(successViewModel.mountains?[0].mountain.mountainName == "토함산")
        XCTAssertTrue(successViewModel.mountains!.count == 1)
    }
    
    func test_MountainList_산_찾기_실패() {
        successViewModel.viewDidLoad()
        successViewModel.mountainName = ""
        
        let mountainCount = successViewModel.mountains!.count
        
        successViewModel.findMountains()
        _ = XCTWaiter.wait(for: [expectation(description: "Wait for 0.1 seconds")], timeout: 0.1)
        
        
        XCTAssertTrue(successViewModel.mountains!.count == mountainCount)
    }
}
