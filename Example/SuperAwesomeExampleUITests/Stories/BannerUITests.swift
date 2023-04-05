//
//  BannerUITests.swift
//  SuperAwesomeExampleUITests
//
//  Created by Myles Eynon on 03/04/2023.
//

import XCTest

class BannerUITests: BaseUITest {

    func testAdAppears_withBumper() throws {

        adsListScreen(app) {
            $0.waitForView()
            $0.tapSettingsButton()

            settingsScreen(app) { settings in
                settings.waitForView()
                settings.tapBumperEnable()
                settings.tapCloseButton()
            }

            $0.tapPlacement(withName: "Banner")
            UIAwait(forSeconds: 1)

            banner(app) { banner in
                banner.waitForView()
                banner.checkPadlockButtonExists()
                banner.tapBanner()

                bumperScreen(app) { bumper in
                    bumper.checkSmallLabelExists(withText: " seconds. Remember to stay safe online and don’t share your username or password with anyone!")
                    bumper.checkBigLabelExists(withText: "Bye! You’re now leaving Demo App.")
                    bumper.isPoweredByLogoVisible()
                    bumper.isBackgroundImageViewVisible()
                    bumper.tapBumperBackgroundImageView()
                    UIAwait(forSeconds: 3)
                }
            }
        }
    }

    func testAdAppears_withParentGate() throws {

        adsListScreen(app) {
            $0.waitForView()
            $0.tapSettingsButton()

            settingsScreen(app) { settings in
                settings.waitForView()
                settings.tapParentalGateEnable()
                settings.tapCloseButton()
            }

            $0.tapPlacement(withName: "Banner")
            UIAwait(forSeconds: 1)

            banner(app) { banner in
                banner.waitForView()
                banner.checkPadlockButtonExists()
                banner.tapBanner()

                parentGateAlert(app) { parentGate in
                    parentGate.waitForView()
                    parentGate.checkTitle(hasText: "Parental Gate")
                    parentGate.checkMessage(hasText: "Please solve the following problem to continue:")
                    parentGate.checkPlaceholder(hasText: "")
                    parentGate.tapCancelButton()
                }

                banner.tapBanner()

                parentGateAlert(app) { parentGate in
                    parentGate.waitForView()
                    parentGate.checkTitle(hasText: "Parental Gate")
                    parentGate.checkMessage(hasText: "Please solve the following problem to continue:")
                    parentGate.checkPlaceholder(hasText: "")
                    parentGate.typeAnswer(text: "")
                    parentGate.tapContinueButton()

                    parentGateErrorAlert(app) { parentGateError in
                        parentGateError.waitForView()
                        parentGateError.checkTitle(hasText: "Oops! That was the wrong answer.")
                        parentGateError.checkMessage(hasText: "Please seek guidance from a responsible adult to help you continue.")
                        parentGateError.tapCancelButton()
                    }
                }
            }
        }
    }
}
