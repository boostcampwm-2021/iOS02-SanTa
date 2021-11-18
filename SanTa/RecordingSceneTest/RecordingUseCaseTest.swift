//
//  RecordingSceneTest.swift
//  RecordingSceneTest
//
//  Created by 김민창 on 2021/11/18.
//

import XCTest

class RecordingUseCaseTest: XCTestCase {
    
    private var useCase: DefaultRecordingUseCase!
    private var repository: RecordRepository!
    
    class TestRecordingRepository : RecordRepository {
        func save(records: Records,
                  completion: @escaping (Result<Records, Error>) -> Void) {
            
        }
        
        func fetchRecordOption(key: Settings, completion: @escaping (Result<Bool, Error>) -> Void) {
            
        }
    }
    
    override func setUpWithError() throws {
        repository = TestRecordingRepository()
        useCase = DefaultRecordingUseCase(settingsRepository: repository)
    }
    
    func test() {
        
    }
}
