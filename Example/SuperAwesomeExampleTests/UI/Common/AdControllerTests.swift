//
//  AdControllerTests.swift
//  SuperAwesomeExampleTests
//
//  Created by Gunhan Sancar on 30/03/2022.
//

import XCTest
import Nimble

@testable import SuperAwesome

class AdControllerTests: XCTestCase {
    private var adRepository: AdRepositoryMock = AdRepositoryMock()
    private var performanceRepository: PerformanceRepositoryMock = PerformanceRepositoryMock()
    private var timeProvider: TimeProviderMock = TimeProviderMock()
    private let controller = AdController()
    private var receivedEvent: AdEvent?
    private var receivedEvents: [AdEvent] = []

    override func setUp() {
        super.setUp()
        TestDependencies.register(adRepository: adRepository,
                                  timeProvider: timeProvider,
                                  performanceRepository: performanceRepository)
        receivedEvent = nil
        receivedEvents = []

        controller.callback = { [weak self] (_, event) in
            self?.receivedEvent = event
            self?.receivedEvents.append(event)
        }
    }

    private func showPadlockTest(showPadlock: Bool, ksfUrl: String?, expectedResult: Bool) {
        // Given
        adRepository.response = .success(
            AdResponse(123, MockFactory.makeAd(format: .tag, showPadlock: showPadlock, ksfRequest: ksfUrl), nil)
        )

        // When
        controller.load(123, MockFactory.makeAdRequest())

        // Then
        XCTAssertEqual(controller.showPadlock, expectedResult)
    }

    func test_showPadlock() {
        showPadlockTest(showPadlock: true, ksfUrl: "http", expectedResult: false)
        showPadlockTest(showPadlock: true, ksfUrl: nil, expectedResult: true)
        showPadlockTest(showPadlock: false, ksfUrl: "http", expectedResult: false)
    }

    // Callbacks

    func testAdLoadedCallback() {
        // Given
        adRepository.response = .success(
            AdResponse(123, MockFactory.makeAd(), nil)
        )

        // When
        controller.load(123, MockFactory.makeAdRequest())

        // Then
        XCTAssertEqual(receivedEvent, AdEvent.adLoaded)
    }

    func testAdFailedToLoadCallback() {
        // Given
        adRepository.response = .failure(
            MockFactory.makeError()
        )

        // When
        controller.load(123, MockFactory.makeAdRequest())

        // Then
        XCTAssertEqual(receivedEvent, AdEvent.adFailedToLoad)
    }

    func testAdClosedCallback() {
        // Given
        controller.close()

        // Then
        XCTAssertEqual(receivedEvent, AdEvent.adClosed)
    }

    func testAdFailedToShowCallback() {
        // Given
        controller.adFailedToShow()

        // Then
        XCTAssertEqual(receivedEvent, AdEvent.adFailedToShow)
    }

    func testAdEndedCallback() {
        // Given
        controller.adEnded()

        // Then
        XCTAssertEqual(receivedEvent, AdEvent.adEnded)
    }

    func testAdShownCallback() {
        // Given
        controller.adShown()

        // Then
        XCTAssertEqual(receivedEvent, AdEvent.adShown)
    }

    func testAdClickedCallback() {
        // Given
        let adResponse = AdResponse(123, MockFactory.makeAd(format: .tag, bumper: false), nil)
        adResponse.vast = MockFactory.makeVastAd(clickThrough: "https://www.superawesome.com/")
        adRepository.response = .success(adResponse)
        controller.load(123, MockFactory.makeAdRequest())

        // When
        controller.handleAdTapForVast()

        // Then
        XCTAssertEqual(receivedEvent, AdEvent.adClicked)
    }

    func test_two_consecutive_clicks_then_only_one_event() {
        // Given
        let initialTime = Date().timeIntervalSince1970
        let adResponse = AdResponse(
            123,
            MockFactory.makeAd(format: .tag, bumper: false),
            nil)
        adResponse.vast = MockFactory.makeVastAd(clickThrough: "https://www.superawesome.com/")
        adRepository.response = .success(adResponse)
        controller.load(123, MockFactory.makeAdRequest())

        // When ad is clicked
        timeProvider.secondsSince1970Mock = initialTime
        controller.handleAdTapForVast()

        // And 1 second passed
        timeProvider.secondsSince1970Mock = initialTime + 1
        controller.handleAdTapForVast()

        let filtered = receivedEvents.filter { $0 == AdEvent.adClicked }

        // Then
        XCTAssertEqual(filtered.count, 1)
    }

    func test_click_after_threshold_then_multiple_events() {
        // Given
        let initialTime = Date().timeIntervalSince1970
        let adResponse = AdResponse(123, MockFactory.makeAd(format: .tag, bumper: false), nil)
        adResponse.vast = MockFactory.makeVastAd(clickThrough: "https://www.superawesome.com/")
        adRepository.response = .success(adResponse)
        controller.load(123, MockFactory.makeAdRequest())

        // When ad is clicked
        timeProvider.secondsSince1970Mock = initialTime
        controller.handleAdTapForVast()

        // And 5 seconds passed
        timeProvider.secondsSince1970Mock = initialTime + 5
        controller.handleAdTapForVast()

        let filtered = receivedEvents.filter { $0 == AdEvent.adClicked }

        // Then
        XCTAssertEqual(filtered.count, 2)
    }
    
    func test_dwellTime_withoutAdShown_noCall() {
        // Given adShown is not called

        // When ad is closed
        controller.trackAdClosed()

        // Then dwell time is not sent
        XCTAssertEqual(performanceRepository.sendDwellTimeCount, 0)
    }
    
    func test_dwellTime_withAdShown_sendDwellTime() {
        // Given adShown is called
        controller.trackAdShown()

        // When ad is closed
        controller.trackAdClosed()

        // Then dwell time is not sent
        XCTAssertEqual(performanceRepository.sendDwellTimeCount, 1)
    }
    
    func test_closeButton_withoutVisibleEvent_noCall() {
        // Given close button visible is not called

        // When close button is clicked
        controller.trackCloseButtonClicked()

        // Then dwell time is not sent
        XCTAssertEqual(performanceRepository.sendCloseButtonPressTimeCount, 0)
    }
    
    func test_closeButton_withVisibleEvent_sendCloseButtonTime() {
        // Given close button visible is called
        controller.trackCloseButtonVisible()

        // When close button is clicked
        controller.trackCloseButtonClicked()

        // Then dwell time is not sent
        XCTAssertEqual(performanceRepository.sendCloseButtonPressTimeCount, 1)
    }
}
