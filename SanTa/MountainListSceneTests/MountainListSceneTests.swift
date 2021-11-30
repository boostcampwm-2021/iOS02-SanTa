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
            let mountainList = [MountainEntity]()
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
    
    func test_MountainList_가져오기_성공 () {
        successViewModel.viewDidLoad()
        _ = XCTWaiter.wait(for: [expectation(description: "Wait for 0.1 seconds")], timeout: 0.1)
        XCTAssertNotNil(successViewModel.mountains)
    }
    
    func test_MountainList_가져오기_실패 () {
        failViewModel.viewDidLoad()
        _ = XCTWaiter.wait(for: [expectation(description: "Wait for 0.1 seconds")], timeout: 0.1)
        XCTAssertNil(failViewModel.mountains)
    }
}
