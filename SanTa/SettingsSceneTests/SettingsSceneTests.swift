//
//  SettingsViewModelTests.swift
//  SettingsTests
//
//  Created by CHANGMIN OH on 2021/11/08.
//

import XCTest

class SettingsViewModelTests: XCTestCase {

    class MockRepository: SettingsRepository {
        func save<T>(value: T, key: Settings) where T: Decodable, T: Encodable {

        }

        func makeToggleOption(key: Settings, completion: @escaping (Option) -> Void) {
            completion(ToggleOption(text: "토글", toggle: true))
        }

        func makeMapOption(key: Settings, completion: @escaping (Option) -> Void) {
            completion(MapOption(text: "맵", map: .infomation))
        }
    }

    private var viewModel: SettingsViewModel!
    private var useCase: SettingsUsecase!

    override func setUpWithError() throws {
        useCase = SettingsUsecase(settingsRepository: MockRepository())
        viewModel = SettingsViewModel(settingsUseCase: useCase)
    }

    func test_ViewModel은_viewDidLoad시_UseCase의_반환값_settings프로퍼티에_세팅() throws {
        viewModel.viewDidLoad()
        XCTAssertEqual(viewModel.settingsCount, 3)
    }

    func test_ViewModel은_change호출시_문자열이면_settings프로퍼티_업데이트() throws {
        viewModel.change(value: 1, key: .mapFormat)
        XCTAssertEqual(viewModel.settingsCount, 0)

        viewModel.change(value: "string", key: .mapFormat)
        XCTAssertEqual(viewModel.settingsCount, 3)
    }

    func test_UseCase는_repository반환_값에_따른_배열생성() {
        let options = useCase.makeSettings()

        let option1 = options[0] as? ToggleOption
        let option2 = options[1] as? ToggleOption
        let option3 = options[2] as? MapOption

        XCTAssertNotNil(option1)
        XCTAssertNotNil(option2)
        XCTAssertNotNil(option3)
    }
}
