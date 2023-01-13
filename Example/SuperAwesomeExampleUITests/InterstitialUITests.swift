//
//  InterstitialUITests.swift
//  SuperAwesomeExampleUITests
//
//  Created by Gunhan Sancar on 04/10/2022.
//

import XCTest

class InterstitialUITests: XCTestCase {

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    func testCloseButtonAppearsWithNoDelay_WhenConfigured() throws {
        let app = localApp()
        app.launch()

        // Given close button appearing with no delay is configured via the SegmentControl
        app.segmentedControls["configControl"].buttons.element(boundBy: 1).tap()

        let closeButtonExpectation = expectation(
            for: NSPredicate(format: "exists == true"),
            evaluatedWith: app.buttons["closeButton"],
            handler: .none
        )

        // When
        // Tap the interstitial ad in the list
        app.tables.matching(identifier: "adsTableView").cells.element(matching: .cell, identifier: "Mobile Interstitial Portrait").tap()

        // Then the close button is visible
        let closeButtonResult = XCTWaiter.wait(for: [closeButtonExpectation], timeout: 5.0)

        XCTAssertEqual(closeButtonResult, .completed)
        XCTAssertTrue(app.buttons["closeButton"].exists)
    }

    func testCloseButtonAppearsWithDelay_WhenConfigured() throws {
        let app = localApp()
        app.launch()

        // Given
        // Tap the interstitial ad in the list
        app.tables.matching(identifier: "adsTableView").cells.element(matching: .cell, identifier: "Mobile Interstitial Portrait").tap()

        let closeButtonExpectation = expectation(
            for: NSPredicate(format: "exists == true"),
            evaluatedWith: app.buttons["closeButton"],
            handler: .none
        )

        // When the close button is not initially visible
        XCTAssertFalse(app.buttons["closeButton"].exists)

        // Then the close button is visible after a delay
        let closeButtonResult = XCTWaiter.wait(for: [closeButtonExpectation], timeout: 5.0)

        XCTAssertEqual(closeButtonResult, .completed)
    }
}
