//
//  VideoScreenRobot.swift
//  SuperAwesomeExampleUITests
//
//  Created by Myles Eynon on 03/04/2023.
//

import XCTest

class VideoScreenRobot: Robot {

    private let accessibilityPrefix = "SuperAwesome.Video."

    private var screen: XCUIElement {
        app.otherElements["\(accessibilityPrefix)Screen"]
    }

    private var videoPlayer: XCUIElement {
        app.otherElements["\(accessibilityPrefix)Player"]
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

    private var volumeOnButton: XCUIElement {
        videoPlayerControls.buttons["\(accessibilityPrefix)Controls.Buttons.Volume.On"]
    }

    private var volumeOffButton: XCUIElement {
        videoPlayerControls.buttons["\(accessibilityPrefix)Controls.Buttons.Volume.Off"]
    }

    private var chronograph: XCUIElement {
        videoPlayerControls.otherElements["\(accessibilityPrefix)Controls.Views.Chronograph"]
    }

    private var blackMask: XCUIElement {
        videoPlayerControls.otherElements["\(accessibilityPrefix)Controls.Views.Chronograph"]
    }

    private var padlockButton: XCUIElement {
        videoPlayerControls.buttons["\(accessibilityPrefix)Controls.Buttons.Padlock"]
    }

    func waitForView() {
        XCTAssertTrue(screen.waitForExistence(timeout: 5))
    }

    func waitForRender() {
        waitForExpectedColor(
            expectedColor: "#F7DE60",
            image: XCUIScreen.main.screenshot().image
        )
    }

    func waitAndCheckForCloseButton() {
        XCTAssertTrue(closeButton.waitForExistence(timeout: 5))
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

    func checkCloseButtonDoesNotExist() {
        XCTAssertFalse(closeButton.exists)
    }

    func checkClickButtonExists() {
        XCTAssertTrue(clickButton.exists)
    }

    func checkVolumeButtonExists() {
        XCTAssertTrue(volumeButton.exists)
    }

    func checkVolumeButtonDoesNotExists() {
        XCTAssertFalse(volumeButton.exists)
        XCTAssertFalse(volumeOnButton.exists)
        XCTAssertFalse(volumeOffButton.exists)
    }

    func checkVolumeButtonOnExists() {
        XCTAssertTrue(volumeOnButton.exists)
    }

    func checkVolumeButtonOffExists() {
        XCTAssertTrue(volumeOffButton.exists)
    }

    func checkPadlockButtonDoesNotExist() {
        XCTAssertFalse(padlockButton.exists)
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

    func tapOnAd() {
        videoPlayer.tap()
    }

    func tapPadlockButton() {
        padlockButton.tap()
    }

    func tapOnVolumeOffButton() {
        volumeOffButton.tap()
    }
}

@discardableResult
func videoScreen(_ app: XCUIApplication, call: (VideoScreenRobot) -> Void) -> VideoScreenRobot {
    let robot = VideoScreenRobot(app: app)
    call(robot)
    return robot
}
