//
//  ResultDetailTest.swift
//  ResultDetailTest
//
//  Created by Jiwon Yoon on 2021/11/30.
//

import XCTest

class ResultDetailTest: XCTestCase {
    let location1 = Location(latitude: 37.53456840060343, longitude: 127.1299119494656, altitude: 20)
    let location2 = Location(latitude: 37.53456840060343, longitude: 127.1299119494656, altitude: 40)
    let location3 = Location(latitude: 37.53456840060343, longitude: 127.1299119494656, altitude: 50)
    let location4 = Location(latitude: 37.53456840060343, longitude: 127.1299119494656, altitude: 10)
    
    private var resultAltitude: ResultDetailViewModel.AltitudeViewModel!


    func test_빈위치좌표배열받을시_고도가전부마이너스() throws {
        let emptyRecord = Record(startTime: Date.now, endTime: Date.now + 100, step: 7777, distance: 777, locations: [])
        let records = Records(title: "기록제목", records: [emptyRecord], assetIdentifiers: [], secondPerHighestSpeed: 600, secondPerMinimumSpeed: 600, id: "id")
        let altModel = ResultAltitude(records: records)
        resultAltitude = .init(altitudeData: altModel)
        XCTAssertEqual(resultAltitude.contents.filter{$0.content.contains("-")}.count, 5)
    }
    
    func test_최저고도_최고고도_레코드한개() throws {
        let record1 = Record(startTime: Date.now, endTime: Date.now + 100, step: 7777, distance: 777, locations: [location1, location2])
        let records = Records(title: "기록제목", records: [record1], assetIdentifiers: [], secondPerHighestSpeed: 600, secondPerMinimumSpeed: 600, id: "id")
        let altModel = ResultAltitude(records: records)
        resultAltitude = .init(altitudeData: altModel)
        XCTAssertEqual(resultAltitude.lowest, "20")
        XCTAssertEqual(resultAltitude.highest, "40")
    }
    
    func test_최저고도_최고고도_레코드여러개() throws {
        let record1 = Record(startTime: Date.now, endTime: Date.now + 100, step: 7777, distance: 777, locations: [location1, location2])
        let record2 = Record(startTime: Date.now, endTime: Date.now + 100, step: 7777, distance: 777, locations: [location3, location4])
        let records = Records(title: "기록제목", records: [record1, record2], assetIdentifiers: [], secondPerHighestSpeed: 600, secondPerMinimumSpeed: 600, id: "id")
        let altModel = ResultAltitude(records: records)
        resultAltitude = .init(altitudeData: altModel)
        XCTAssertEqual(resultAltitude.lowest, "10")
        XCTAssertEqual(resultAltitude.highest, "50")
    }
    
    func test_시작고도_종료고도_레코드한개() throws {
        let record1 = Record(startTime: Date.now, endTime: Date.now + 100, step: 7777, distance: 777, locations: [location1, location2])
        let records = Records(title: "기록제목", records: [record1], assetIdentifiers: [], secondPerHighestSpeed: 600, secondPerMinimumSpeed: 600, id: "id")
        let altModel = ResultAltitude(records: records)
        resultAltitude = .init(altitudeData: altModel)
        let start = resultAltitude.contents.filter {$0.contentTitle == "시작"}.first?.content ?? ""
        let end = resultAltitude.contents.filter {$0.contentTitle == "종료"}.first?.content ?? ""
        XCTAssertEqual(start, "20")
        XCTAssertEqual(end, "40")
    }

    func test_시작고도_종료고도_레코드여러개() throws {
        let record1 = Record(startTime: Date.now, endTime: Date.now + 100, step: 7777, distance: 777, locations: [location1, location2])
        let record2 = Record(startTime: Date.now, endTime: Date.now + 100, step: 7777, distance: 777, locations: [location3, location4])
        let records = Records(title: "기록제목", records: [record2, record1], assetIdentifiers: [], secondPerHighestSpeed: 600, secondPerMinimumSpeed: 600, id: "id")
        let altModel = ResultAltitude(records: records)
        resultAltitude = .init(altitudeData: altModel)
        let start = resultAltitude.contents.filter {$0.contentTitle == "시작"}.first?.content ?? ""
        let end = resultAltitude.contents.filter {$0.contentTitle == "종료"}.first?.content ?? ""
        XCTAssertEqual(start, "50")
        XCTAssertEqual(end, "40")
    }
}
