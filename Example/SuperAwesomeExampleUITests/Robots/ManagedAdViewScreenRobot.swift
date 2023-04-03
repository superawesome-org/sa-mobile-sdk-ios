//
//  ManagedAdViewScreenRobot.swift
//  SuperAwesomeExampleUITests
//
//  Created by Myles Eynon on 31/03/2023.
//

import XCTest

class ManagedAdViewScreenRobot: Robot {

    private let accessibilityPrefix = "SuperAwesome.ManagedAdView."

    private var screen: XCUIElement {
        app.otherElements["\(accessibilityPrefix)Screen"]
    }

    private var managedAd: XCUIElement {
        screen.otherElements["\(accessibilityPrefix)Views.ManagedAd"]
    }

    private var closeButton: XCUIElement {
        screen.buttons["\(accessibilityPrefix)Buttons.Close"]
    }

    func waitForView() {
        XCTAssertTrue(screen.waitForExistence(timeout: 5))
    }

    func checkCloseButtonExists() {
        XCTAssertTrue(closeButton.exists)
    }

    func tapClose() {
        closeButton.tap()
    }

    func tapVideo() {
        managedAd.tap()
    }
}

@discardableResult
func managedAdViewScreen(_ app: XCUIApplication, call: (ManagedAdViewScreenRobot) -> Void) -> ManagedAdViewScreenRobot {
    let robot = ManagedAdViewScreenRobot(app: app)
    call(robot)
    return robot
}
