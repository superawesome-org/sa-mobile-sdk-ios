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

    override func setUp() {
        super.setUp()
        TestDependencies.register(adRepository: adRepository)
    }

    private func showPadlockTest(showPadlock: Bool, ksfUrl: String?, expectedResult: Bool) {
        // Given
        adRepository.response = .success(
            AdResponse(123, MockFactory.makeAd(.tag, nil, nil, nil, showPadlock, ksfUrl))
        )

        let controller = AdController()

        // When
        controller.load(123, MockFactory.makeAdRequest())

        // Then
        expect(controller.showPadlock).to(equal(expectedResult))
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

        let controller = AdController()
        var receivedEvent: AdEvent?

        controller.callback = { (placementId, event) in
            receivedEvent = event
        }

        // When
        controller.load(123, MockFactory.makeAdRequest())

        // Then
        XCTAssertEqual(receivedEvent, AdEvent.adLoaded)
    }

    func testAdFailedToLoadCallback() {
        // Given
        adRepository.response = .failure(MockFactory.makeError())

        let controller = AdController()
        var receivedEvent: AdEvent?

        controller.callback = { (placementId, event) in
            receivedEvent = event
        }

        // When
        controller.load(123, MockFactory.makeAdRequest())

        // Then
        XCTAssertEqual(receivedEvent, AdEvent.adFailedToLoad)
    }

    func testAdClosedCallback() {
        // Given
        let controller = AdController()
        var receivedEvent: AdEvent?

        controller.callback = { (placementId, event) in
            receivedEvent = event
        }

        // When
        controller.close()

        // Then
        XCTAssertEqual(receivedEvent, AdEvent.adClosed)
    }

    func testAdFailedToShowCallback() {
        // Given

        let controller = AdController()
        var receivedEvent: AdEvent?

        controller.callback = { (placementId, event) in
            receivedEvent = event
        }

        // When
        controller.adFailedToShow()

        // Then
        XCTAssertEqual(receivedEvent, AdEvent.adFailedToShow)
    }

    func testAdEndedCallback() {
        // Given

        let controller = AdController()
        var receivedEvent: AdEvent?

        controller.callback = { (placementId, event) in
            receivedEvent = event
        }

        // When
        controller.adEnded()

        // Then
        XCTAssertEqual(receivedEvent, AdEvent.adEnded)
    }

    func testAdShownCallback() {
        // Given

        let controller = AdController()
        var receivedEvent: AdEvent?

        controller.callback = { (placementId, event) in
            receivedEvent = event
        }

        // When
        controller.adShown()

        // Then
        XCTAssertEqual(receivedEvent, AdEvent.adShown)
    }

    func testAdClickedCallback() {
        // Given

        let controller = AdController()
        var receivedEvent: AdEvent?

        controller.callback = { (placementId, event) in
            receivedEvent = event
        }

        // When
        controller.adClicked()

        // Then
        XCTAssertEqual(receivedEvent, AdEvent.adClicked)
    }
}
