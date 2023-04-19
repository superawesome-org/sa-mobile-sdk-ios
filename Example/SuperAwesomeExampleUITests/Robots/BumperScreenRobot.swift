//
//  BumperScreenRobot.swift
//  SuperAwesomeExampleUITests
//
//  Created by Myles Eynon on 03/04/2023.
//

import XCTest

class BumperScreenRobot: Robot {

    private let accessibilityPrefix = "SuperAwesome.Bumper."

    private var screen: XCUIElement {
        app.otherElements["\(accessibilityPrefix)Screen"]
    }

    private var backgroundImageView: XCUIElement {
        screen.images["\(accessibilityPrefix)ImageViews.Background"]
    }

    private var appLogoImageView: XCUIElement {
        screen.images["\(accessibilityPrefix)ImageViews.AppLogo"]
    }

    private var poweredByLogoImageView: XCUIElement {
        screen.images["\(accessibilityPrefix)ImageViews.PoweredByLogo"]
    }

    private var smallLabel: XCUIElement {
        screen.staticTexts["\(accessibilityPrefix)Labels.Small"]
    }

    private var bigLabel: XCUIElement {
        screen.staticTexts["\(accessibilityPrefix)Labels.Big"]
    }
    
    let warningMessage = " seconds. Remember to stay safe online and don’t share your username or password with anyone!"
    
    let goodByeMessage = "Bye! You’re now leaving Demo App."

    func waitForView() {
        XCTAssertTrue(screen.waitForExistence(timeout: 5))
    }
    
    func tapBumperBackground() {
        screen.tapTopLeft()
    }

    func tapBumperBackgroundImageView() {
        backgroundImageView.tap()
    }

    func isBackgroundImageViewVisible() {
        XCTAssertTrue(backgroundImageView.exists)
    }

    func isAppLogoVisible() {
        XCTAssertTrue(appLogoImageView.exists)
    }

    func isPoweredByLogoVisible() {
        XCTAssertTrue(poweredByLogoImageView.exists)
    }

    func checkSmallLabelExists(withText text: String) {
        XCTAssertTrue(smallLabel.label.contains(text))
    }

    func checkBigLabelExists(withText text: String) {
        XCTAssertEqual(bigLabel.label, text)
    }
}

@discardableResult
func bumperScreen(_ app: XCUIApplication, call: (BumperScreenRobot) -> Void) -> BumperScreenRobot {
    let robot = BumperScreenRobot(app: app)
    call(robot)
    return robot
}
