//
//  InterstitialScreenRobot.swift
//  SuperAwesomeExampleUITests
//
//  Created by Myles Eynon on 31/03/2023.
//

import XCTest

class InterstitialScreenRobot: Robot {

    private let accessibilityPrefix = "SuperAwesome.Interstital."

    private var screen: XCUIElement {
        app.otherElements["\(accessibilityPrefix)Screen"]
    }

    private var bannerView: XCUIElement {
        screen.otherElements["\(accessibilityPrefix)Banner"]
    }

    private var closeButton: XCUIElement {
        screen.buttons["\(accessibilityPrefix)Buttons.Close"]
    }
    
    func checkCloseButtonExists() {
        XCTAssertTrue(closeButton.exists)
    }
    
    func checkCloseButtonDoesNotExist() {
        XCTAssertFalse(closeButton.exists)
    }
    
    func waitForCloseButton() {
        XCTAssertTrue(closeButton.waitForExistence(timeout: 5))
    }

    func waitForView() {
        XCTAssertTrue(screen.waitForExistence(timeout: 5))
    }
    
    func waitForRender() {
        waitForExpectedColor(
            expectedColor: "#F7E26B",
            image: XCUIScreen.main.screenshot().image
        )
    }

    func tapClose() {
        closeButton.tap()
    }

    func tapOnAd() {
        bannerView.tap()
    }
}

@discardableResult
func interstitialScreen(_ app: XCUIApplication, call: (InterstitialScreenRobot) -> Void) -> InterstitialScreenRobot {
    let robot = InterstitialScreenRobot(app: app)
    call(robot)
    return robot
}
