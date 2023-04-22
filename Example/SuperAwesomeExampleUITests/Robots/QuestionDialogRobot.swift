//
//  LeaveWarningRobot.swift
//  SuperAwesomeExampleUITests
//
//  Created by Gunhan Sancar on 21/04/2023.
//

import XCTest

class QuestionDialogRobot: Robot {

    private let accessibilityPrefix = "SuperAwesome.Alerts.Question"

    private var alert: XCUIElement {
        app.alerts[accessibilityPrefix]
    }

    private var yesAlert: XCUIElement {
        app.buttons["\(accessibilityPrefix).Button.Yes"]
    }

    private var noAlert: XCUIElement {
        app.buttons["\(accessibilityPrefix).Button.No"]
    }

    func waitForView() {
        XCTAssertTrue(alert.waitForExistence(timeout: 5))
    }

    func tapYesButton() {
        yesAlert.tap()
    }

    func tapNoButton() {
        noAlert.tap()
    }

    func checkTitle(hasText text: String) {
        let label = alert.staticTexts[text]
        XCTAssertTrue(label.exists)
    }

    func checkMessage(hasText text: String) {
        let label = alert.staticTexts[text]
        XCTAssertTrue(label.exists)
    }
}

@discardableResult
func questionDialog(_ app: XCUIApplication, call: (QuestionDialogRobot) -> Void) -> QuestionDialogRobot {
    let robot = QuestionDialogRobot(app: app)
    call(robot)
    return robot
}
