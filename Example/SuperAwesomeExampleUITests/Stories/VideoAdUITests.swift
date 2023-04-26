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
                    bumper.waitForView()
                    bumper.checkSmallLabelExists(withText: bumper.warningMessage)
                    bumper.checkBigLabelExists(withText: bumper.goodByeMessage)
                    bumper.isPoweredByLogoVisible()
                    bumper.isBackgroundImageViewVisible()
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
                    parentGate.typeAnswer(text: "9999")
                    parentGate.tapContinueButton()
                }

                parentGateErrorAlert(app) { parentGateError in
                    parentGateError.waitForView()
                    parentGateError.checkTitle(hasText: parentGateError.wrongAnswerTitle)
                    parentGateError.checkMessage(hasText: parentGateError.wrongAnswerMessage)
                    parentGateError.tapCancelButton()
                }
            }
        }
    }

    func testParentalGateCancelled_thenAdResumes() throws {
        adsListScreen(app) { adsList in
            adsList.waitForView()
            adsList.tapSettingsButton()

            settingsScreen(app) { settings in
                settings.waitForView()
                settings.tapParentalGateEnable()
                settings.tapCloseButton()
            }

            adsList.tapPlacement(withName: "Direct Video Flat Colour")

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
            }

            // The ad list is visible again after the ad ends
            adsList.waitForView(timeout: .extraLong)
        }
    }

    func testParentalGateFailed_thenAdResumes() throws {
        adsListScreen(app) { adsList in
            adsList.waitForView()
            adsList.tapSettingsButton()

            settingsScreen(app) { settings in
                settings.waitForView()
                settings.tapParentalGateEnable()
                settings.tapCloseButton()
            }

            adsList.tapPlacement(withName: "Direct Video Flat Colour")

            videoScreen(app) { screen in
                screen.waitForView()
                screen.tapOnAd()

                parentGateAlert(app) { parentGate in
                    parentGate.waitForView()
                    parentGate.checkTitle(hasText: parentGate.title)
                    parentGate.checkMessage(hasText: parentGate.questionMessage)
                    parentGate.checkPlaceholder(hasText: "")
                    parentGate.typeAnswer(text: "9999")
                    parentGate.tapContinueButton()
                }

                parentGateErrorAlert(app) { parentGateError in
                    parentGateError.waitForView()
                    parentGateError.checkTitle(hasText: parentGateError.wrongAnswerTitle)
                    parentGateError.checkMessage(hasText: parentGateError.wrongAnswerMessage)
                    parentGateError.tapCancelButton()
                }
            }

            // The ad list is visible again after the ad ends
            adsList.waitForView(timeout: .extraLong)
        }
    }

    func testAdAppears_withBumper_andParentalGate() throws {
        adsListScreen(app) { adsList in
            adsList.waitForView()
            adsList.tapSettingsButton()

            settingsScreen(app) { settings in
                settings.waitForView()
                settings.tapParentalGateEnable()
                settings.tapBumperEnable()
                settings.tapCloseButton()
            }

            adsList.tapPlacement(withName: "Direct Video Flat Colour")

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
                    bumper.waitForView()
                    bumper.checkSmallLabelExists(withText: bumper.warningMessage)
                    bumper.checkBigLabelExists(withText: bumper.goodByeMessage)
                    bumper.isPoweredByLogoVisible()
                    bumper.isBackgroundImageViewVisible()
                }

                safari { safari in
                    safari.waitForView()
                }

                // Return to the app from Safari
                app.activate()

                // The ad content is visible
                screen.waitForRender()

                // The ad list is visible again after the ad ends
                adsList.waitForView(timeout: .extraLong)
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
                    parentGate.typeAnswer(text: "9999")
                    parentGate.tapContinueButton()
                }

                parentGateErrorAlert(app) { parentGateError in
                    parentGateError.waitForView()
                    parentGateError.checkTitle(hasText: parentGateError.wrongAnswerTitle)
                    parentGateError.checkMessage(hasText: parentGateError.wrongAnswerTitle)
                    parentGateError.tapCancelButton()
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

    func test_leaveVideoWarning_Enabled() throws {
        adsListScreen(app) { listScreen in
            listScreen.waitForView()
            listScreen.tapSettingsButton()

            settingsScreen(app) { settings in
                settings.waitForView()
                settings.tapLeaveVideoWarningEnable()
                settings.tapCloseButtonNoDelay()
                settings.tapCloseButton()
            }

            listScreen.tapPlacement(withName: "Direct Video Flat Colour")

            videoScreen(app) { screen in
                screen.waitForView()
                screen.tapCloseButton()

                // Show dialog and resume video
                questionDialog(app) { dialog in
                    dialog.checkTitle(hasText: "Close Video?")
                    dialog.tapNoButton()
                }

                screen.waitForRender()
                screen.tapCloseButton()

                listScreen.checkTableViewDoesNotExists()

                // Show dialog and exit video
                questionDialog(app) { dialog in
                    dialog.checkTitle(hasText: "Close Video?")
                    dialog.tapYesButton()
                }

                listScreen.checkTableViewExists()
            }
        }
    }

    func testParentalGate_navigatesToSafari_andBackToApp() throws {
        adsListScreen(app) { adsList in
            adsList.waitForView()
            adsList.tapSettingsButton()

            settingsScreen(app) { settings in
                settings.waitForView()
                settings.tapParentalGateEnable()
                settings.tapCloseButton()
            }

            adsList.tapPlacement(withName: "Direct Video Flat Colour")

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

                safari { safari in
                    safari.waitForView()
                }

                // Return to the app from Safari
                app.activate()

                // The ad content is visible
                screen.waitForRender()

                // The ad list is visible again after the ad ends
                adsList.waitForView(timeout: .extraLong)
            }
        }
    }

    func testBumper_navigatesToSafari_andBackToApp() throws {
        adsListScreen(app) { adsList in
            adsList.waitForView()
            adsList.tapSettingsButton()

            settingsScreen(app) { settings in
                settings.waitForView()
                settings.tapBumperEnable()
                settings.tapCloseButton()
            }

            adsList.tapPlacement(withName: "Direct Video Flat Colour")

            videoScreen(app) { screen in
                screen.waitForView()
                screen.tapOnAd()

                bumperScreen(app) { bumper in
                    bumper.waitForView()
                    bumper.checkSmallLabelExists(withText: bumper.warningMessage)
                    bumper.checkBigLabelExists(withText: bumper.goodByeMessage)
                    bumper.isPoweredByLogoVisible()
                    bumper.isBackgroundImageViewVisible()
                }

                safari { safari in
                    safari.waitForView()
                }

                // Return to the app from Safari
                app.activate()

                // The ad content is visible
                screen.waitForRender()

                // The ad list is visible again after the ad ends
                adsList.waitForView(timeout: .extraLong)
            }
        }
    }
}
