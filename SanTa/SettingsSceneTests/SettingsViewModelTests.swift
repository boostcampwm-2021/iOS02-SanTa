//
//  SettingsViewModelTests.swift
//  SettingsTests
//
//  Created by CHANGMIN OH on 2021/11/08.
//

import XCTest

class SettingsViewModelTests: XCTestCase {
    
    class MockUseCase: SettingsUsecase {
        
        let options: [[Option]] = [[MapOption(text: "맵", map: .infomation)]]
        
        func save<T>(value: T, key: Settings) {
            
        }
        
        func makeSettings() -> [[Option]] {
            return options
        }
    }
    
    private var viewModel: SettingsViewModel!
    private var useCase: MockUseCase!
    
    override func setUpWithError() throws {
        useCase = MockUseCase()
        viewModel = SettingsViewModel(settingsUseCase: useCase)
    }
    
    func test_viewDidLoad시_UseCase의_반환값_settings프로퍼티에_세팅() throws {
        viewModel.viewDidLoad()
        guard let mapOption = viewModel.settings[0][0] as? MapOption else { return }
        XCTAssertEqual(mapOption.text, "맵")
        XCTAssertEqual(mapOption.map, .infomation)
    }
    
    func test_change호출시_문자열이면_settings프로퍼티_업데이트() throws {
        viewModel.change(value: 1, key: .mapFormat)
        XCTAssertEqual(viewModel.sectionCount, 0)
        
        viewModel.change(value: "string", key: .mapFormat)
        let mapOption = viewModel.settings[0][0] as? MapOption
        XCTAssertNotNil(mapOption)
        XCTAssertEqual(mapOption?.text, "맵")
        XCTAssertEqual(mapOption?.map, .infomation)
    }
}
