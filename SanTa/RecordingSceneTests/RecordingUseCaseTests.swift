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
    
    enum testError: Error {
        case StoreError
    }
    
    class TestRecordingRepository : RecordRepository {
        func save(records: Records,
                  completion: @escaping (Result<Records, Error>) -> Void) {
            
            completion(.success(records))
        }
        
        func fetchRecordOption(key: Settings, completion: @escaping (Result<Bool, Error>) -> Void) {
            switch key {
            case .voiceGuidanceEveryOnekm:
                completion(.success(true))
            case .recordPhoto:
                completion(.success(true))
            default:
                completion(.success(false))
            }
        }
    }
    
    override func setUpWithError() throws {
        repository = TestRecordingRepository()
        useCase = DefaultRecordingUseCase(recordRepository: repository, recordingModel: nil, recordingPhoto: RecordingPhotoModel())
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
    
    func test_음성안내_옵션_False_값_가져오기_성공() {
        _ = XCTWaiter.wait(for: [expectation(description: "Wait for 0.5 seconds")], timeout: 0.5)
        self.repository.fetchRecordOption(key: Settings.photosOnMap) { result in
            switch result {
            case .failure(_):
                return
            case .success(let status):
                XCTAssertFalse(status)
            }
        }
    }
    
    func test_사진저장_옵션_True_값_가져오기_성공() {
        _ = XCTWaiter.wait(for: [expectation(description: "Wait for 0.5 seconds")], timeout: 0.5)
        self.repository.fetchRecordOption(key: Settings.recordPhoto) { result in
            switch result {
            case .failure(_):
                return
            case .success(let status):
                XCTAssertTrue(status)
            }
        }
    }
    
    func test_사진저장_옵션_False_값_가져오기_성공() {
        _ = XCTWaiter.wait(for: [expectation(description: "Wait for 0.5 seconds")], timeout: 0.5)
        self.repository.fetchRecordOption(key: Settings.photosOnMap) { result in
            switch result {
            case .failure(_):
                return
            case .success(let status):
                XCTAssertFalse(status)
            }
        }
    }
    
    func test_Records_저장_성공() {
        _ = XCTWaiter.wait(for: [expectation(description: "Wait for 0.5 seconds")], timeout: 0.5)
        let records = Records(title: "테스트", records: [Record](), assetIdentifiers: [String](), secondPerHighestSpeed: Int(), secondPerMinimumSpeed: Int())
        
        self.repository.save(records: records) { result in
            switch result {
            case .failure(_):
                return
            case .success(let records):
                XCTAssertEqual(records.title, records.title)
            }
            
        }
    }
}
