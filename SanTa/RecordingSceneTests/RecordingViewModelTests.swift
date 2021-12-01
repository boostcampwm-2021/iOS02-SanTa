//
//  RecordingViewModelTests.swift
//  RecordingSceneTests
//
//  Created by 김민창 on 2021/11/29.
//

import XCTest
import Combine

final class RecordingViewModelTests: XCTestCase {

    private let recordingUseCase: RecordingUseCase? = nil
    private var subscriptions = Set<AnyCancellable>()
    private var recordingViewModel = RecordingViewModel(recordingUseCase: nil)
    
    override func setUp() {
    }
    
    func test_시간_받기_성공() {

        var result = ""
        self.recordingViewModel.$currentTime
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { time in
                result = time
            })
            .store(in: &self.subscriptions)

        let timeText = "0:00"
        recordingViewModel.currentTime = timeText
        _ = XCTWaiter.wait(for: [expectation(description: "Wait for 0.2 seconds")], timeout: 0.5)

        XCTAssertTrue(timeText == result)
    }

    func test_시간_받기_실패() {

        var result = ""
        self.recordingViewModel.$currentTime
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { time in
                result = time
            })
            .store(in: &self.subscriptions)

        let timeText = "0:00"
        recordingViewModel.currentTime = "0:01"
        _ = XCTWaiter.wait(for: [expectation(description: "Wait for 0.2 seconds")], timeout: 0.2)

        XCTAssertFalse(timeText == result)
    }

    func test_접근성_현재_시간_받기_성공() {

        var result = ""
        self.recordingViewModel.$accessibilityCurrentTime
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { time in
                result = time
            })
            .store(in: &self.subscriptions)

        let timeText = "0:00"
        recordingViewModel.accessibilityCurrentTime = timeText
        _ = XCTWaiter.wait(for: [expectation(description: "Wait for 0.2 seconds")], timeout: 0.2)

        XCTAssertTrue(timeText == result)
    }

    func test_접근성_현재_시간_받기_실패() {

        var result = ""
        self.recordingViewModel.$accessibilityCurrentTime
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: {  time in
                result = time
            })
            .store(in: &self.subscriptions)

        let timeText = "0:00"
        recordingViewModel.accessibilityCurrentTime = "0:01"
        _ = XCTWaiter.wait(for: [expectation(description: "Wait for 0.2 seconds")], timeout: 0.2)

        XCTAssertFalse(timeText == result)
    }

    func test_킬로미터_받기_성공() {

        var result = ""
        self.recordingViewModel.$kilometer
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { kilometer in
                result = kilometer
            })
            .store(in: &self.subscriptions)

        let kiloText = "5km"
        recordingViewModel.kilometer = kiloText
        _ = XCTWaiter.wait(for: [expectation(description: "Wait for 0.2 seconds")], timeout: 0.2)

        XCTAssertTrue(kiloText == result)
    }

    func test_킬로미터_받기_실패() {

        var result = ""
        self.recordingViewModel.$kilometer
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { kilometer in
                result = kilometer
            })
            .store(in: &self.subscriptions)

        let kiloText = "5km"
        recordingViewModel.kilometer = "4km"
        _ = XCTWaiter.wait(for: [expectation(description: "Wait for 0.2 seconds")], timeout: 0.2)

        XCTAssertFalse(kiloText == result)
    }

    func test_고도_받기_성공() {

        var result = ""
        self.recordingViewModel.$altitude
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { altitude in
                result = altitude
            })
            .store(in: &self.subscriptions)

        let altitudeText = "50"
        recordingViewModel.altitude = altitudeText
        _ = XCTWaiter.wait(for: [expectation(description: "Wait for 0.2 seconds")], timeout: 0.2)

        XCTAssertTrue(altitudeText == result)
    }

    func test_고도_받기_실패() {

        var result = ""
        self.recordingViewModel.$altitude
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { altitude in
                result = altitude
            })
            .store(in: &self.subscriptions)

        let altitudeText = "5km"
        recordingViewModel.altitude = "40"
        _ = XCTWaiter.wait(for: [expectation(description: "Wait for 0.2 seconds")], timeout: 0.2)

        XCTAssertFalse(altitudeText == result)
    }

    func test_걸음_받기_성공() {

        var result = ""
        self.recordingViewModel.$walk
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { walk in
                result = walk
            })
            .store(in: &self.subscriptions)

        let walkText = "300"
        recordingViewModel.walk = walkText
        _ = XCTWaiter.wait(for: [expectation(description: "Wait for 0.2 seconds")], timeout: 0.2)

        XCTAssertTrue(walkText == result)
    }

    func test_걸음_받기_실패() {

        var result = ""
        self.recordingViewModel.$walk
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { walk in
                result = walk
            })
            .store(in: &self.subscriptions)

        let walkText = "300"
        recordingViewModel.walk = "200"
        _ = XCTWaiter.wait(for: [expectation(description: "Wait for 0.2 seconds")], timeout: 0.2)

        XCTAssertFalse(walkText == result)
    }

    func test_GPS상태_받기_성공() {

        var result = true
        self.recordingViewModel.$gpsStatus
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { gps in
                result = gps
            })
            .store(in: &self.subscriptions)

        let gpsStatus = false
        recordingViewModel.gpsStatus = gpsStatus
        _ = XCTWaiter.wait(for: [expectation(description: "Wait for 0.2 seconds")], timeout: 0.2)

        XCTAssertTrue(gpsStatus == result)
    }

    func test_GPS상태_받기_실패() {

        var result = false
        self.recordingViewModel.$gpsStatus
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { gps in
                result = gps
            })
            .store(in: &self.subscriptions)

        let gpsStatus = false
        recordingViewModel.gpsStatus = true
        _ = XCTWaiter.wait(for: [expectation(description: "Wait for 0.2 seconds")], timeout: 0.2)

        XCTAssertFalse(gpsStatus == result)
    }

    func test_motion권한_받기_성공() {

        var result = true
        self.recordingViewModel.$motionAuth
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { motion in
                result = motion
            })
            .store(in: &self.subscriptions)

        let motionStatus = false
        recordingViewModel.motionAuth = motionStatus
        _ = XCTWaiter.wait(for: [expectation(description: "Wait for 0.2 seconds")], timeout: 0.2)

        XCTAssertTrue(motionStatus == result)
    }

    func test_motion권한_받기_실패() {

        var result = false
        self.recordingViewModel.$motionAuth
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { motion in
                result = motion
            })
            .store(in: &self.subscriptions)

        let motionStatus = false
        recordingViewModel.motionAuth = true
        _ = XCTWaiter.wait(for: [expectation(description: "Wait for 0.2 seconds")], timeout: 0.2)

        XCTAssertFalse(motionStatus == result)
    }
}
