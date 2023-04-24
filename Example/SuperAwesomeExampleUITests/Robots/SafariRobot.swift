//
//  SafariRobot.swift
//  SuperAwesomeExampleUITests
//
//  Created by Tom O'Rourke on 24/04/2023.
//

import XCTest

class SafariRobot: Robot {
    
    func waitForView(timeout: Timeout = .standard) {
        app.wait(for: .runningForeground, timeout: timeout.duration)
    }
}

@discardableResult
func safari(call: (SafariRobot) -> Void) -> SafariRobot {
    let robot = SafariRobot(app: XCUIApplication(bundleIdentifier: "com.apple.mobilesafari"))
    call(robot)
    return robot
}
