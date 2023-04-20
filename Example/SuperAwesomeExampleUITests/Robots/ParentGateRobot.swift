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
    
    let title = "Parental Gate"
    let questionMessage = "Please solve the following problem to continue:"
    let wrongAnswerTitle = "Oops! That was the wrong answer."
    let wrongAnswerMessage = "Please seek guidance from a responsible adult to help you continue."
    
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
        guard let label = getMessage(withText: text) else {
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
    
    func solve() -> String {
        guard let question = getMessage(withText: questionMessage) else {
            XCTFail("Label not found with text: \(questionMessage)")
            return ""
        }
        
        let elements = question.label.split(separator: "+")
        
        guard
            elements.count == 2,
            let firstNumber = Int.parse(from: String(elements[0])),
            let secondNumber = Int.parse(from: String(elements[1]))
        else {
            XCTFail("Failed to extract numbers for the parental gate question")
            return ""
        }
                
        return String(firstNumber + secondNumber)
    }
    
    private func getMessage(withText text: String) -> XCUIElement? {
        
        guard let label = alert.staticTexts
            .allElementsBoundByIndex
            .first(where:{$0.label.contains(text)})
        else { return nil }
        
        return label
    }
}

@discardableResult
func parentGateAlert(_ app: XCUIApplication, call: (ParentGateRobot) -> Void) -> ParentGateRobot {
    let robot = ParentGateRobot(app: app)
    call(robot)
    return robot
}
