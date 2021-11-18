//
//  RecordingSceneTests.swift
//  RecordingSceneTests
//
//  Created by 김민창 on 2021/11/18.
//

import XCTest

class RecordingUseCaseTests: XCTestCase {

    private var useCase: DefaultRecordingUseCase!
    private var repository: RecordRepository!
    
    class TestRecordingRepository : RecordRepository {
        func save(records: Records,
                  completion: @escaping (Result<Records, Error>) -> Void) {
            return
        }
        
        func fetchRecordOption(key: Settings, completion: @escaping (Result<Bool, Error>) -> Void) {
            completion(.success(true))
        }
    }
    
    override func setUpWithError() throws {
        repository = TestRecordingRepository()
        useCase = DefaultRecordingUseCase(recordRepository: repository, recordingModel: RecordingModel(), recordingPhoto: RecordingPhotoModel())
    }
    
    func test_음성안내_옵션_True_값_가져오기_성공() {
        _ = XCTWaiter.wait(for: [expectation(description: "Wait for 0.5 seconds")], timeout: 0.5)
        self.repository.fetchRecordOption(key: Settings.voiceGuidanceEveryOnekm) { result in
            switch result {
            case .failure(_):
                return
            case .success(let status):
                XCTAssertTrue(status)
            }
        }
    }

}
