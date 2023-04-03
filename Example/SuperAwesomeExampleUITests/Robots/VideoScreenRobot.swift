//
//  VideoScreenRobot.swift
//  SuperAwesomeExampleUITests
//
//  Created by Myles Eynon on 03/04/2023.
//

import XCTest

class VideoScreenRobot: Robot {

    private let accessibilityPrefix = "SuperAwesome.Video."

    private var videoPlayer: XCUIElement {
        app.otherElements["\(accessibilityPrefix)Layer"]
    }

    private var videoPlayerControls: XCUIElement {
        app.otherElements["\(accessibilityPrefix)Controls.Screen"]
    }

    private var closeButton: XCUIElement {
        videoPlayerControls.buttons["\(accessibilityPrefix)Controls.Buttons.Close"]
    }

    private var clickButton: XCUIElement {
        videoPlayerControls.buttons["\(accessibilityPrefix)Controls.Buttons.Clicker"]
    }

    private var volumeButton: XCUIElement {
        videoPlayerControls.buttons["\(accessibilityPrefix)Controls.Buttons.Volume"]
    }

    private var chronograph: XCUIElement {
        videoPlayerControls.otherElements["\(accessibilityPrefix)Controls.Views.Chronograph"]
    }

    private var blackMask: XCUIElement {
        videoPlayerControls.otherElements["\(accessibilityPrefix)Controls.Views.Chronograph"]
    }

    func waitForView() {
        let view = app.otherElements["\(accessibilityPrefix)Screen"]
        XCTAssertTrue(view.waitForExistence(timeout: 5))
    }

    func checkChronoExists() {
        XCTAssertTrue(chronograph.exists)
    }

    func checkBlackMaskExists() {
        XCTAssertTrue(blackMask.exists)
    }

    func checkCloseButtonExists() {
        XCTAssertTrue(closeButton.exists)
    }

    func checkClickButtonExists() {
        XCTAssertTrue(clickButton.exists)
    }

    func checkVolumeButtonExists() {
        XCTAssertTrue(volumeButton.exists)
    }

    func tapCloseButton() {
        closeButton.tap()
    }

    func tapVolumeButton() {
        volumeButton.tap()
    }

    func tapVideo() {
        clickButton.tap()
    }
}

@discardableResult
func videoScreen(_ app: XCUIApplication, call: (VideoScreenRobot) -> Void) -> VideoScreenRobot {
    let robot = VideoScreenRobot(app: app)
    call(robot)
    return robot
}
