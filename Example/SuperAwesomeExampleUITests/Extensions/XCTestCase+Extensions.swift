//
//  XCTestCase+Extensions.swift
//  SuperAwesomeExampleUITests
//
//  Created by Tom O'Rourke on 30/10/2022.
//

import XCTest

extension XCTestCase {

    func localApp() -> XCUIApplication {
        let app = XCUIApplication()
        app.launchArguments = LaunchArguments.launchLocalArguments
        return app
    }
}
