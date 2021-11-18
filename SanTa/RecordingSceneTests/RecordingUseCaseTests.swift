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
            return
        }
    }
    
    override func setUpWithError() throws {
        repository = TestRecordingRepository()
        useCase = DefaultRecordingUseCase(recordRepository: repository, recordingModel: RecordingModel(), recordingPhoto: RecordingPhotoModel())
    }
    
    func test() {
        
    }

}
