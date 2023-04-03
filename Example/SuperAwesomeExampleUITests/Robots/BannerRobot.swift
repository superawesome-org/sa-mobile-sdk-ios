//
//  BannerRobot.swift
//  SuperAwesomeExampleUITests
//
//  Created by Myles Eynon on 31/03/2023.
//

import XCTest

class BannerRobot: Robot {

    private var banner: XCUIElement {
        app.otherElements["AdList.BannerView"]
    }

    func waitForView() {
        XCTAssertTrue(banner.waitForExistence(timeout: 5))
    }

    func tapBanner() {
        banner.tap()
    }
}

@discardableResult
func banner(_ app: XCUIApplication, call: (BannerRobot) -> Void) -> BannerRobot {
    let robot = BannerRobot(app: app)
    call(robot)
    return robot
}
