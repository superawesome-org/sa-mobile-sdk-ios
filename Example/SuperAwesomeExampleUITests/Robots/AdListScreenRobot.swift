//
//  AdListScreenRobot.swift
//  SuperAwesomeExampleUITests
//
//  Created by Myles Eynon on 31/03/2023.
//

import XCTest

class AdListScreenRobot: Robot {

    private var screen: XCUIElement {
        app.otherElements["AdList.Screen"]
    }

    private var tableView: XCUIElement {
        screen.tables["AdList.TableView"]
    }

    func checkTableViewDoesNotExists() {
        XCTAssertFalse(tableView.exists)
    }

    func checkTableViewExists() {
        XCTAssertTrue(tableView.exists)
    }

    func waitForView(timeout: Timeout = .standard) {
        XCTAssertTrue(screen.waitForExistence(timeout: timeout.duration))
    }

    func tapPlacement(withName name: String) {
        tableView.cells[name].tap()
    }

    func tapSettingsButton() {
        screen.buttons["AdList.Buttons.Settings"].tap()
    }
}

@discardableResult
func adsListScreen(_ app: XCUIApplication, call: (AdListScreenRobot) -> Void) -> AdListScreenRobot {
    let robot = AdListScreenRobot(app: app)
    call(robot)
    return robot
}
