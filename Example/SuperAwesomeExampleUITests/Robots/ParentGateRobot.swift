//
//  ParentGateRobot.swift
//  SuperAwesomeExampleUITests
//
//  Created by Myles Eynon on 31/03/2023.
//

import XCTest

class ParentGateRobot: Robot {

    private let accessibilityPrefix = "SuperAwesome.Alerts.ParentGate"

    private var alert: XCUIElement {
        app.alerts[accessibilityPrefix]
    }

    private var answerField: XCUIElement {
        app.textFields["\(accessibilityPrefix).TextFields.Answer"]
    }

    func waitForView() {
        XCTAssertTrue(alert.waitForExistence(timeout: 5))
    }

    func tapContinueButton() {
        alert.buttons["\(accessibilityPrefix).Buttons.Continue"].tap()
    }

    func tapCancelButton() {
        alert.buttons["\(accessibilityPrefix).Buttons.Cancel"].tap()
    }

    func checkTitle(hasText text: String) {
        let label = alert.staticTexts[text]
        XCTAssertTrue(label.exists)
    }

    func checkMessage(hasText text: String) {
        guard let label = alert.staticTexts.allElementsBoundByIndex.first(where: { $0.label.contains(text) }) else {
            XCTFail("Label not found with text: \(text)")
            return
        }
        XCTAssertTrue(label.exists)
    }

    func checkPlaceholder(hasText: String) {
        XCTAssertEqual(hasText, answerField.placeholderValue)
    }

    func typeAnswer(text: String) {
        answerField.clearAndEnterText(text)
        UIAwait(forSeconds: 2)
    }
}

@discardableResult
func parentGateAlert(_ app: XCUIApplication, call: (ParentGateRobot) -> Void) -> ParentGateRobot {
    let robot = ParentGateRobot(app: app)
    call(robot)
    return robot
}
