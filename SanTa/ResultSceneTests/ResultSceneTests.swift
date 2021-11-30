//
//  ResultSceneTests.swift
//  ResultSceneTests
//
//  Created by CHANGMIN OH on 2021/11/29.
//

import XCTest

class ResultSceneTests: XCTestCase {
    
    class MockRepository: ResultRepository {
        func fetch(completion: @escaping (Result<[Records], Error>) -> Void) {
            let location1 = Location(latitude: 10, longitude: 20, altitude: 30)
            let location2 = Location(latitude: 20, longitude: 30, altitude: 40)
            let location3 = Location(latitude: 30, longitude: 40, altitude: 50)
            let location4 = Location(latitude: 40, longitude: 50, altitude: 60)
            let location5 = Location(latitude: 50, longitude: 60, altitude: 70)
            let location6 = Location(latitude: 60, longitude: 70, altitude: 80)
            let location7 = Location(latitude: 70, longitude: 80, altitude: 90)
            let location8 = Location(latitude: 80, longitude: 90, altitude: 10)
            let record1 = Record(startTime: Date(timeIntervalSince1970: 1000),
                                 endTime: Date(timeIntervalSince1970: 2000),
                                 step: 10,
                                 distance: 20,
                                 locations: [location1, location2])
            let record2 = Record(startTime: Date(timeIntervalSince1970: 2000),
                                 endTime: Date(timeIntervalSince1970: 3000),
                                 step: 20,
                                 distance: 30,
                                 locations: [location3, location4])
            let record3 = Record(startTime: Date(timeIntervalSince1970: 4000),
                                 endTime: Date(timeIntervalSince1970: 5000),
                                 step: 30,
                                 distance: 40,
                                 locations: [location5, location6])
            let record4 = Record(startTime: Date(timeIntervalSince1970: 5000),
                                 endTime: Date(timeIntervalSince1970: 6000),
                                 step: 40,
                                 distance: 50,
                                 locations: [location7, location8])
            let records1 = Records(title: "기록1",
                                   records: [record1, record2],
                                   assetIdentifiers: ["1", "11"],
                                   secondPerHighestSpeed: 10,
                                   secondPerMinimumSpeed: 20,
                                   id: "1")
            let records2 = Records(title: "기록2",
                                   records: [record3, record4],
                                   assetIdentifiers: ["2", "22"],
                                   secondPerHighestSpeed: 30,
                                   secondPerMinimumSpeed: 40,
                                   id: "2")
            completion(.success([records1, records2]))
        }
    }
    
    private var viewModel: ResultViewModel!
    private var useCase: ResultUseCase!
    
    override func setUpWithError() throws {
        useCase = ResultUseCase(resultRepository: MockRepository())
        viewModel = ResultViewModel(useCase: useCase)
    }
    
    func test_ViewModel_viewWillAppear시_UseCase에_TotalRecords_세팅() throws {
        viewModel.viewWillAppear { }
        XCTAssertNotNil(useCase.totalRecords)
    }
    
    func test_ViewModel_itemsInSection호출시_section넘버에_따라_Records갯수_반환() {
        viewModel.viewWillAppear { }
        XCTAssertEqual(viewModel.itemsInSection(section: 0), 2)
    }
    
    func test_ViewModel_totalInfo호출시_총_Records를_View에_보여줄_문자열정보로_반환() {
        viewModel.viewWillAppear { }
        let infomation = viewModel.totalInfo()
        XCTAssertEqual(infomation.distance, "140.00")
        XCTAssertEqual(infomation.count, "2")
        XCTAssertEqual(infomation.time, "01:06")
        XCTAssertEqual(infomation.steps, "100")
    }
    
    func test_ViewModel_sectionInfo호출시_섹션넘버에_맞는_Records를_View에_보여줄_문자열정보로_반환() {
        viewModel.viewWillAppear { }
        let infomation = viewModel.sectionInfo(section: 0)
        XCTAssertEqual(infomation.date, "1970. 1.")
        XCTAssertEqual(infomation.accessibiltyDate, "1970년 1월")
        XCTAssertEqual(infomation.count, "2회")
        XCTAssertEqual(infomation.distance, "140.00km")
        XCTAssertEqual(infomation.time, "01:06")
    }
    
    func test_ViewModel_cellInfo호출시_IndexPath에_맞는_Records를_View에_보여줄_문자열정보로_반환() {
        viewModel.viewWillAppear { }
        let infomation = viewModel.cellInfo(indexPath: IndexPath(item: 0, section: 0))
        XCTAssertEqual(infomation.date, "1. 1. (목) 오전 9시 50분")
        XCTAssertEqual(infomation.distance, "50.00")
        XCTAssertEqual(infomation.time, "00:33")
        XCTAssertEqual(infomation.altitudeDifference, "30")
        XCTAssertEqual(infomation.steps, "30")
        XCTAssertEqual(infomation.title, "기록1")
    }
    
    func test_ViewModel_selectedRecords호출시_IndexPath에_맞는_Records반환() {
        viewModel.viewWillAppear { }
        let record = viewModel.selectedRecords(indexPath: IndexPath(item: 0, section: 0))
        XCTAssertEqual(record?.id, "1")
    }
}

