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
    
    override func setUpWithError() throws {
        repository = DefaultRecordRepository()
        useCase = DefaultRecordingUseCase(settingsRepository: repository)
    }
    
    func test() {
        
    }
}
