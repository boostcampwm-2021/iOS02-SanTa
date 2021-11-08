//
//  SettingsUseCaseTests.swift
//  SettingsTests
//
//  Created by CHANGMIN OH on 2021/11/08.
//

import XCTest

class SettingsUsecaseTests: XCTestCase {
    
    class MockRepository: SettingsRepository {
        func save<T>(value: T, key: Settings) where T : Decodable, T : Encodable {
            
        }
        
        func getToggleOption(key: Settings, completion: @escaping (Option) -> Void) {
            completion(ToggleOption(text: "토글", toggle: true))
        }
        
        func getMapOption(key: Settings, completion: @escaping (Option) -> Void) {
            completion(MapOption(text: "맵", map: .infomation))
        }
    }
    
    private var useCase: SettingsUsecase!
    private var repository: MockRepository!
    
    override func setUpWithError() throws {
        repository = MockRepository()
        useCase = DefaultSettingsUsecase(settingsRepository: repository)
    }
    
    func test_repository반환_값에_따른_배열생성() {
        let options = useCase.makeSettings()
        
        let option1 = options[0][0] as? ToggleOption
        let option2 = options[0][1] as? ToggleOption
        let option3 = options[1][0] as? ToggleOption
        let option4 = options[1][1] as? ToggleOption
        let option5 = options[2][0] as? ToggleOption
        let option6 = options[3][0] as? MapOption
        let option7 = options[3][1] as? ToggleOption
        
        XCTAssertNotNil(option1)
        XCTAssertNotNil(option2)
        XCTAssertNotNil(option3)
        XCTAssertNotNil(option4)
        XCTAssertNotNil(option5)
        XCTAssertNotNil(option6)
        XCTAssertNotNil(option7)
    }
}

