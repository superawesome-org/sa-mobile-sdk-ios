//
//  VideoAdUITests.swift
//  SuperAwesomeExampleUITests
//
//  Created by Tom O'Rourke on 07/06/2022.
//

import XCTest

class VideoAdUITests: XCTestCase {

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    func testCloseButtonAppearsWithNoDelay_WhenConfigured() throws {

        let app = XCUIApplication()
        app.launch()

        // Given

        // Close button appearing with no delay is configured via the SegmentControl
        app.segmentedControls["configControl"].buttons.element(boundBy: 1).tap()

        // Tap the video ad in the list
        app.otherElements["adsStackView"].buttons.element(boundBy: 3).tap()

        let padlockExpectation = expectation(
            for: NSPredicate(format: "exists == true"),
            evaluatedWith: app.buttons["padlock"],
            handler: .none
        )

        // When

        // The padlock is visible (it's visible immediately)
        let padlockResult = XCTWaiter.wait(for: [padlockExpectation], timeout: 5.0)
        XCTAssertEqual(padlockResult, .completed)

        // Then

        // The close button is visible
        XCTAssertTrue(app.buttons["closeButton"].exists)
    }

    func testCloseButtonAppearsWithDelay_WhenConfigured() throws {

        let app = XCUIApplication()
        app.launch()

        // Given

        // Close button appearing with a delay is configured via the SegmentControl
        app.segmentedControls["configControl"].buttons.element(boundBy: 0).tap()

        // Tap the video ad in the list
        app.otherElements["adsStackView"].buttons.element(boundBy: 3).tap()

        let padlockExpectation = expectation(
            for: NSPredicate(format: "exists == true"),
            evaluatedWith: app.buttons["padlock"],
            handler: .none
        )

        let closeButtonExpectation = expectation(
            for: NSPredicate(format: "exists == true"),
            evaluatedWith: app.buttons["closeButton"],
            handler: .none
        )

        // When

        // The padlock is visible (it's visible immediately)
        let padlockResult = XCTWaiter.wait(for: [padlockExpectation], timeout: 5.0)
        XCTAssertEqual(padlockResult, .completed)

        // The close button is not initially visible
        XCTAssertFalse(app.buttons["closeButton"].exists)

        // Then

        // The close button is visible after a delay
        let closeButtonResult = XCTWaiter.wait(for: [closeButtonExpectation], timeout: 5.0)

        XCTAssertEqual(closeButtonResult, .completed)
    }
}
