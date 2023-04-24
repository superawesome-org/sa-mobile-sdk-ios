//
//  ParentGateErrorRobot.swift
//  SuperAwesomeExampleUITests
//
//  Created by Myles Eynon on 03/04/2023.
//

import XCTest

class ParentGateErrorRobot: Robot {

    private let accessibilityPrefix = "SuperAwesome.Alerts.ParentGateError"
    let wrongAnswerTitle = "Oops! That was the wrong answer."
    let wrongAnswerMessage = "Please seek guidance from a responsible adult to help you continue."

    private var alert: XCUIElement {
        app.alerts[accessibilityPrefix]
    }

    func waitForView() {
        XCTAssertTrue(alert.waitForExistence(timeout: 20))
    }

    func tapCancelButton() {
        alert.buttons["\(accessibilityPrefix).Buttons.Cancel"].tap()
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
func parentGateErrorAlert(_ app: XCUIApplication, call: (ParentGateErrorRobot) -> Void) -> ParentGateErrorRobot {
    let robot = ParentGateErrorRobot(app: app)
    call(robot)
    return robot
}
