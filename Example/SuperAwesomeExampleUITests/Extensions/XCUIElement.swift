//
//  XCUIElement.swift
//  SuperAwesomeExampleUITests
//
//  Created by Myles Eynon on 31/03/2023.
//

import XCTest

extension XCUIElement {
    func clearAndEnterText(_ text: String,
                           file: StaticString = #file,
                           line: UInt = #line) {

        tapTextInputIfNeeded()

        guard let stringValue = value as? String else {
            XCTFail("Tried to clear and enter text into a non string value", file: file, line: line)
            return
        }
        let lowerRightCorner = self.coordinate(withNormalizedOffset: CGVector(dx: 0.7, dy: 0.9))
        lowerRightCorner.tap()

        let deleteString = String(repeating: XCUIKeyboardKey.delete.rawValue, count: stringValue.count)
        typeText(deleteString)
        typeText(text)
    }

    private func tapTextInputIfNeeded() {
        let hasFocus = (value(forKey: "hasKeyboardFocus") as? Bool) ?? false
        if !hasFocus {
            tap()
        }
    }

    func dismissKeyboard() {
        let app = XCUIApplication()
        if app.keys.element(boundBy: 0).exists {
            app.typeText("\n")
        }
    }

    func tapTopLeft() {
        let coordinate = coordinate(withNormalizedOffset: CGVector(dx: 1, dy: 1))
        coordinate.tap()
    }
}
