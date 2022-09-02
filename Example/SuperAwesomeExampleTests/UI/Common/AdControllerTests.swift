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
    private let controller = AdController()
    private var receivedEvent: AdEvent?

    override func setUp() {
        super.setUp()
        TestDependencies.register(adRepository: adRepository)
        receivedEvent = nil

        controller.callback = { [weak self] (placementId, event) in
            self?.receivedEvent = event
        }
    }

    private func showPadlockTest(showPadlock: Bool, ksfUrl: String?, expectedResult: Bool) {
        // Given
        adRepository.response = .success(
            AdResponse(123, MockFactory.makeAd(.tag, nil, nil, nil, showPadlock, ksfUrl))
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
            AdResponse(123, MockFactory.makeAd())
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
}
