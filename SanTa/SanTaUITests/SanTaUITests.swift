//
//  SanTaUITests.swift
//  SanTaUITests
//
//  Created by CHANGMIN OH on 2021/12/01.
//

import XCTest

class SanTaUITests: XCTestCase {
    
    var app: XCUIApplication!
    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }

    override func tearDown() {
        app = nil
        super.tearDown()
    }
    
    func test_측정시작후_측정종료() {
        app/*@START_MENU_TOKEN@*/.staticTexts["시작"]/*[[".buttons.matching(identifier: \"시작\").staticTexts[\"시작\"]",".staticTexts[\"시작\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        app.buttons["종료"].tap()
        app.alerts["기록 종료"].scrollViews.otherElements.buttons["종료"].tap()
        app/*@START_MENU_TOKEN@*/.staticTexts["입력 안함"]/*[[".buttons[\"입력 안함\"].staticTexts[\"입력 안함\"]",".staticTexts[\"입력 안함\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
    }
    
    
    func test_산_검색후_산_상세화면_확인_후_뒤로가기() {
        app.tabBars["Tab Bar"].buttons["목록"].tap()
        app.navigationBars["산 목록"].searchFields["검색"].tap()
        if !app/*@START_MENU_TOKEN@*/.keys["ㄱ"]/*[[".keyboards.keys[\"ㄱ\"]",".keys[\"ㄱ\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.isHittable {
            app.buttons["Next keyboard"].tap()
        }
        
        app/*@START_MENU_TOKEN@*/.keys["ㄱ"]/*[[".keyboards.keys[\"ㄱ\"]",".keys[\"ㄱ\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        app/*@START_MENU_TOKEN@*/.keys["ㅏ"]/*[[".keyboards.keys[\"ㅏ\"]",".keys[\"ㅏ\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        app/*@START_MENU_TOKEN@*/.keys["ㄹ"]/*[[".keyboards.keys[\"ㄹ\"]",".keys[\"ㄹ\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        app/*@START_MENU_TOKEN@*/.keys["ㄱ"]/*[[".keyboards.keys[\"ㄱ\"]",".keys[\"ㄱ\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        app/*@START_MENU_TOKEN@*/.keys["ㅣ"]/*[[".keyboards.keys[\"ㅣ\"]",".keys[\"ㅣ\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        app/*@START_MENU_TOKEN@*/.keys["ㅅ"]/*[[".keyboards.keys[\"ㅅ\"]",".keys[\"ㅅ\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        app.keys["ㅏ"].tap()
        app/*@START_MENU_TOKEN@*/.keys["ㄴ"]/*[[".keyboards.keys[\"ㄴ\"]",".keys[\"ㄴ\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        app/*@START_MENU_TOKEN@*/.buttons["Search"]/*[[".keyboards",".buttons[\"검색\"]",".buttons[\"Search\"]"],[[[-1,2],[-1,1],[-1,0,1]],[[-1,2],[-1,1]]],[0]]@END_MENU_TOKEN@*/.tap()
        XCTAssert(app.collectionViews/*@START_MENU_TOKEN@*/.cells["갈기산 685 m 경기도 양평군, 강원도 홍천군 Cell"]/*[[".cells[\"갈기산 685 m 경기도 양평군, 강원도 홍천군\"]",".cells[\"갈기산 685 m 경기도 양평군, 강원도 홍천군 Cell\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.waitForExistence(timeout: 2))
        app.collectionViews/*@START_MENU_TOKEN@*/.cells["갈기산 685 m 경기도 양평군, 강원도 홍천군 Cell"]/*[[".cells[\"갈기산 685 m 경기도 양평군, 강원도 홍천군\"]",".cells[\"갈기산 685 m 경기도 양평군, 강원도 홍천군 Cell\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        app.buttons["닫기"].tap()
    }
    
    func test_기록화면의_첫_번째_정보_클릭_후_상세_기록_정보_확인() {
        app.tabBars["Tab Bar"].buttons["기록"].tap()
        guard app.collectionViews/*@START_MENU_TOKEN@*/.cells["RecordsViewCell 1 0"]/*[[".cells[\"오늘(수) 오후 4시 13분 등산기록 정보, 제목: 없음, 거리: 0.00km, 시간: 00:00, 고도차: -, 걸음: 0\"]",".cells[\"RecordsViewCell 1 0\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.isHittable else { return }
        app.collectionViews/*@START_MENU_TOKEN@*/.cells["RecordsViewCell 1 0"]/*[[".cells[\"오늘(수) 오후 4시 13분 등산기록 정보, 제목: 없음, 거리: 0.00km, 시간: 00:00, 고도차: -, 걸음: 0\"]",".cells[\"RecordsViewCell 1 0\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        app.otherElements["기록 정보 거리: 0km, 시간: 00:00, 걸음: 0, 최고고도: -, 최저고도: -, 평균속도: -"].swipeUp()
        app.windows.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.swipeDown()
        app.buttons["뒤로가기"].tap()
    }
    
}
