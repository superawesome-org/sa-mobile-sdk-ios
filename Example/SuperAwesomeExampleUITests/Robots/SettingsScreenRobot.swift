//
//  SettingsScreenRobot.swift
//  SuperAwesomeExampleUITests
//
//  Created by Myles Eynon on 31/03/2023.
//

import XCTest

class SettingsScreenRobot: Robot {

    private var settingsView: XCUIElement {
        app.otherElements["SettingsView"]
    }

    func waitForView() {
        let view = settingsView
        XCTAssertTrue(view.waitForExistence(timeout: 5))
    }

    func tapCloseButton() {
        settingsView.buttons["Settings.Buttons.Close"].tap()
    }

    func tapResetButton() {
        settingsView.buttons["Settings.Buttons.Reset"].tap()
    }

    func tapCloseButtonNoDelay() {
        button(withSetting: "CloseButtonMode", option: "NoDelay").tap()
    }

    func tapCloseButtonWithDelay() {
        button(withSetting: "CloseButtonMode", option: "Delay").tap()
    }

    func tapCloseButtonHidden() {
        button(withSetting: "CloseButtonMode", option: "Hidden").tap()
    }

    func tapTestModeEnable() {
        button(withSetting: "TestMode", option: "Enable").tap()
    }

    func tapTestModeDisable() {
        button(withSetting: "TestMode", option: "Disable").tap()
    }

    func tapBumperEnable() {
        button(withSetting: "Bumper", option: "Enable").tap()
    }

    func tapBumperDisable() {
        button(withSetting: "Bumper", option: "Disable").tap()
    }

    func tapParentalGateEnable() {
        button(withSetting: "ParentalGate", option: "Enable").tap()
    }

    func tapParentalGateDisable() {
        button(withSetting: "ParentalGate", option: "Disable").tap()
    }

    func tapPlayAdImmediatelyEnable() {
        button(withSetting: "PlayAdImmediately", option: "Enable").tap()
    }

    func tapPlayAdImmediatelyDisable() {
        button(withSetting: "PlayAdImmediately", option: "Disable").tap()
    }

    func tapMuteOnStartEnable() {
        button(withSetting: "MuteOnStart", option: "Enable").tap()
    }

    func tapMuteOnStartDisable() {
        button(withSetting: "MuteOnStart", option: "Disable").tap()
    }

    func tapLeaveVideoWarningEnable() {
        button(withSetting: "LeaveVideoWarning", option: "Enable").tap()
    }

    func tapLeaveVideoWarningDisable() {
        button(withSetting: "LeaveVideoWarning", option: "Disable").tap()
    }

    func tapCloseAtEndEnable() {
        button(withSetting: "CloseAtEnd", option: "Enable").tap()
    }

    func tapCloseAtEndDisable() {
        button(withSetting: "CloseAtEnd", option: "Disable").tap()
    }

    private func button(withSetting setting: String, option: String) -> XCUIElement {
        settingsView.buttons["SettingsItem.\(setting).Button.\(option)"]
    }
}

@discardableResult
func settingsScreen(_ app: XCUIApplication, call: (SettingsScreenRobot) -> Void) -> SettingsScreenRobot {
    let robot = SettingsScreenRobot(app: app)
    call(robot)
    return robot
}
