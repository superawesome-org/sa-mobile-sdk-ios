//
//  BaseUITest.swift
//  SuperAwesomeExampleUITests
//
//  Created by Myles Eynon on 03/04/2023.
//

import XCTest

class BaseUITest: XCTestCase {

    internal var app: XCUIApplication!

    internal var clearPersistantData: String {
        "true"
    }

    internal var hasStartedInAirplaneMode: Bool {
        false
    }

    internal var launchEnvironment: [String: String] {
        ["animations": "0",
         "clearPersistantData": clearPersistantData]
    }

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    override func setUp() {
        super.setUp()

        app = XCUIApplication()
        app.terminate()
        app.launchEnvironment = launchEnvironment
        app.launchArguments.append("--UITests")

        if hasStartedInAirplaneMode {
            app.launchArguments.append("--AirplaneMode")
        }

        app.launch()
    }
}
