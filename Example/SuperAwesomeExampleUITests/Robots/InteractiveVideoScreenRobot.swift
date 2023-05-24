//
//  InteractiveVideoScreenRobot.swift
//  SuperAwesomeExampleUITests
//
//  Created by Tom O'Rourke on 27/04/2023.
//

import XCTest
class InteractiveVideoScreenRobot: Robot {
    
    private let accessibilityPrefix = "SuperAwesome.ManagedAdView."

    private var screen: XCUIElement {
        app.otherElements["\(accessibilityPrefix)Screen"]
    }

    private var webView: XCUIElement {
        app.webViews["\(accessibilityPrefix)ManagedAd.Views.WebView"]
    }

    private var closeButton: XCUIElement {
        app.buttons["\(accessibilityPrefix)Buttons.Close"]
    }

    func checkCloseButtonExists() {
        XCTAssertTrue(closeButton.exists)
    }

    func checkCloseButtonDoesNotExist() {
        XCTAssertFalse(closeButton.exists)
    }

    func waitAndCheckForCloseButton(timeout: Timeout = .standard) {
        XCTAssertTrue(closeButton.waitForExistence(timeout: timeout.duration))
    }

    func waitForView() {
        XCTAssertTrue(screen.waitForExistence(timeout: 5))
    }

    func waitForRender() {
        waitForExpectedColor(
            expectedColor: "#CCCCCC",
            screenshotProvider: XCUIScreen.main
        )
    }

    func tapClose() {
        closeButton.tap()
    }

    func tapOnAd() {
        webView.tap()
    }
}

@discardableResult
func interactiveVideoScreen(_ app: XCUIApplication,
                            call: (InteractiveVideoScreenRobot) -> Void) -> InteractiveVideoScreenRobot {
    let robot = InteractiveVideoScreenRobot(app: app)
    call(robot)
    return robot
}
