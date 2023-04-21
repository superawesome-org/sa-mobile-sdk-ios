//
//  VideoAdUITests.swift
//  SuperAwesomeExampleUITests
//
//  Created by Tom O'Rourke on 07/06/2022.
//

import XCTest
import DominantColor

class VideoAdUITests: BaseUITest {
    func testAdAppears() throws {
        adsListScreen(app) {
            $0.waitForView()
            $0.tapPlacement(withName: "Direct Video Flat Colour")

            videoScreen(app) { screen in
                screen.waitForView()
                screen.waitForRender()
            }
        }
    }

    func testAdAppears_withBumper() throws {
        adsListScreen(app) {
            $0.waitForView()
            $0.tapSettingsButton()

            settingsScreen(app) { settings in
                settings.waitForView()
                settings.tapBumperEnable()
                settings.tapCloseButton()
            }

            $0.tapPlacement(withName: "Direct Video Flat Colour")

            videoScreen(app) { screen in
                screen.waitForView()
                screen.tapOnAd()

                bumperScreen(app) { bumper in
                    bumper.checkSmallLabelExists(withText: bumper.warningMessage)
                    bumper.checkBigLabelExists(withText: bumper.goodByeMessage)
                    bumper.isPoweredByLogoVisible()
                    bumper.isBackgroundImageViewVisible()
                    bumper.tapBumperBackgroundImageView()
                }
            }
        }
    }

    func testAdAppears_withParentalGate() throws {
        adsListScreen(app) {
            $0.waitForView()
            $0.tapSettingsButton()

            settingsScreen(app) { settings in
                settings.waitForView()
                settings.tapParentalGateEnable()
                settings.tapCloseButton()
            }

            $0.tapPlacement(withName: "Direct Video Flat Colour")

            videoScreen(app) { screen in
                screen.waitForView()
                screen.tapOnAd()

                parentGateAlert(app) { parentGate in
                    parentGate.waitForView()
                    parentGate.checkTitle(hasText: parentGate.title)
                    parentGate.checkMessage(hasText: parentGate.questionMessage)
                    parentGate.checkPlaceholder(hasText: "")
                    parentGate.tapCancelButton()
                }

                screen.tapOnAd()

                parentGateAlert(app) { parentGate in
                    parentGate.waitForView()
                    parentGate.checkTitle(hasText: parentGate.title)
                    parentGate.checkMessage(hasText: parentGate.questionMessage)
                    parentGate.checkPlaceholder(hasText: "")
                    parentGate.typeAnswer(text: "")
                    parentGate.tapContinueButton()

                    parentGateErrorAlert(app) { parentGateError in
                        parentGateError.waitForView()
                        parentGateError.checkTitle(hasText: parentGate.wrongAnswerTitle)
                        parentGateError.checkMessage(hasText: parentGate.wrongAnswerMessage)
                        parentGateError.tapCancelButton()
                    }
                }
            }
        }
    }

    func testAdAppears_withBumper_andParentalGate() throws {
        adsListScreen(app) {
            $0.waitForView()
            $0.tapSettingsButton()

            settingsScreen(app) { settings in
                settings.waitForView()
                settings.tapParentalGateEnable()
                settings.tapBumperEnable()
                settings.tapCloseButton()
            }

            $0.tapPlacement(withName: "Direct Video Flat Colour")

            videoScreen(app) { screen in
                screen.waitForView()
                screen.tapOnAd()

                parentGateAlert(app) { parentGate in
                    parentGate.waitForView()
                    parentGate.checkTitle(hasText: parentGate.title)
                    parentGate.checkMessage(hasText: parentGate.questionMessage)
                    parentGate.checkPlaceholder(hasText: "")
                    parentGate.typeAnswer(text: parentGate.solve())
                    parentGate.tapContinueButton()
                }

                bumperScreen(app) { bumper in
                    bumper.checkSmallLabelExists(withText: bumper.warningMessage)
                    bumper.checkBigLabelExists(withText: bumper.goodByeMessage)
                    bumper.isPoweredByLogoVisible()
                    bumper.isBackgroundImageViewVisible()
                    bumper.tapBumperBackgroundImageView()
                }
            }
        }
    }

    func test_safeAd_logo_withParentalGate() throws {
        adsListScreen(app) {
            $0.waitForView()
            $0.tapSettingsButton()

            settingsScreen(app) { settings in
                settings.waitForView()
                settings.tapParentalGateEnable()
                settings.tapCloseButton()
            }

            $0.tapPlacement(withName: "Direct Video Padlock Enabled")

            videoScreen(app) { screen in
                screen.waitForView()

                screen.tapPadlockButton()

                parentGateAlert(app) { parentGate in
                    parentGate.waitForView()
                    parentGate.checkTitle(hasText: parentGate.title)
                    parentGate.checkMessage(hasText: parentGate.questionMessage)
                    parentGate.checkPlaceholder(hasText: "")
                    parentGate.tapCancelButton()
                }

                screen.tapOnAd()

                parentGateAlert(app) { parentGate in
                    parentGate.waitForView()
                    parentGate.checkTitle(hasText: parentGate.title)
                    parentGate.checkMessage(hasText: parentGate.questionMessage)
                    parentGate.checkPlaceholder(hasText: "")
                    parentGate.typeAnswer(text: "")
                    parentGate.tapContinueButton()

                    parentGateErrorAlert(app) { parentGateError in
                        parentGateError.waitForView()
                        parentGateError.checkTitle(hasText: parentGate.wrongAnswerTitle)
                        parentGateError.checkMessage(hasText: parentGate.wrongAnswerTitle)
                        parentGateError.tapCancelButton()
                    }
                }
            }
        }
    }

    func test_safeAd_logo_disabled() throws {
        adsListScreen(app) {
            $0.waitForView()
            $0.tapPlacement(withName: "Direct Video Padlock Disabled")

            videoScreen(app) { screen in
                screen.waitForView()
                screen.checkPadlockButtonDoesNotExist()
            }
        }
    }

    func test_closeButton_no_delay() throws {
        adsListScreen(app) {
            $0.waitForView()
            $0.tapSettingsButton()

            settingsScreen(app) { settings in
                settings.waitForView()
                settings.tapCloseButtonNoDelay()
                settings.tapCloseButton()
            }

            $0.tapPlacement(withName: "Direct Video Flat Colour")

            videoScreen(app) { screen in
                screen.waitForView()
                // Check that the close button is visible immediately
                screen.checkCloseButtonExists()
            }
        }
    }

    func test_closeButton_with_delay() throws {
        adsListScreen(app) {
            $0.waitForView()
            $0.tapSettingsButton()

            settingsScreen(app) { settings in
                settings.waitForView()
                settings.tapCloseButtonWithDelay()
                settings.tapCloseButton()
            }

            $0.tapPlacement(withName: "Direct Video Flat Colour")

            videoScreen(app) { screen in
                screen.waitForView()
                // Check that the close button is not visible at first
                screen.checkCloseButtonDoesNotExist()
                // Wait for the close button to be visible
                screen.waitAndCheckForCloseButton()
            }
        }
    }

    func test_muteOnStart_Enabled_andDisabledLater() throws {
        adsListScreen(app) {
            $0.waitForView()
            $0.tapSettingsButton()

            settingsScreen(app) { settings in
                settings.waitForView()
                settings.tapMuteOnStartEnable()
                settings.tapCloseButton()
            }

            $0.tapPlacement(withName: "Direct Video Flat Colour")

            videoScreen(app) { screen in
                screen.waitForView()
                screen.checkVolumeButtonOffExists()

                screen.tapOnVolumeOffButton()

                screen.checkVolumeButtonOnExists()
            }
        }
    }

    func test_muteOnStart_Disabled() throws {
        adsListScreen(app) {
            $0.waitForView()
            $0.tapSettingsButton()

            settingsScreen(app) { settings in
                settings.waitForView()
                settings.tapMuteOnStartDisable()
                settings.tapCloseButton()
            }

            $0.tapPlacement(withName: "Direct Video Flat Colour")

            videoScreen(app) { screen in
                screen.waitForView()
                screen.checkVolumeButtonDoesNotExists()
            }
        }
    }
}
