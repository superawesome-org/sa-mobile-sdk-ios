//
//  InteractiveVideoAdUITests.swift
//  SuperAwesomeExampleUITests
//
//  Created by Tom O'Rourke on 27/04/2023.
//

import XCTest
import DominantColor

class IVVideoAdUITests: BaseUITest {

    func testAdAppears() throws {
        adsListScreen(app) {
            $0.waitForView()
            $0.tapPlacement(withName: "Plain Grey VPAID Ad")

            interactiveVideoScreen(app) { screen in
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
            
            $0.tapPlacement(withName: "Plain Grey VPAID Ad")
            
            interactiveVideoScreen(app) { screen in
                screen.waitForView()
                screen.waitForRender()
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
            
            $0.tapPlacement(withName: "Plain Grey VPAID Ad")
            
            interactiveVideoScreen(app) { screen in
                screen.waitForView()
                screen.waitForRender()
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
            
            adsList.tapPlacement(withName: "Plain Grey VPAID Ad")
            
            interactiveVideoScreen(app) { screen in
                screen.waitForView()
                screen.waitForRender()
                screen.tapOnAd()
                
                parentGateAlert(app) { parentGate in
                    parentGate.waitForView()
                    parentGate.checkTitle(hasText: parentGate.title)
                    parentGate.checkMessage(hasText: parentGate.questionMessage)
                    parentGate.checkPlaceholder(hasText: "")
                    parentGate.tapCancelButton()
                }
                
                // The ad content is visible
                screen.waitForRender()
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
            
            adsList.tapPlacement(withName: "Plain Grey VPAID Ad")
            
            interactiveVideoScreen(app) { screen in
                screen.waitForView()
                screen.waitForRender()
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
                
                // The ad content is visible
                screen.waitForRender()
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
            
            adsList.tapPlacement(withName: "Plain Grey VPAID Ad")
            
            interactiveVideoScreen(app) { screen in
                screen.waitForView()
                screen.waitForRender()
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

    func test_closeButton_no_delay() throws {
        adsListScreen(app) {
            $0.waitForView()
            $0.tapSettingsButton()
            
            settingsScreen(app) { settings in
                settings.waitForView()
                settings.tapCloseButtonNoDelay()
                settings.tapCloseButton()
            }
            
            $0.tapPlacement(withName: "Plain Grey VPAID Ad")
            
            interactiveVideoScreen(app) { screen in
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
            
            $0.tapPlacement(withName: "Plain Grey VPAID Ad")
            
            interactiveVideoScreen(app) { screen in
                screen.waitForView()
                // Check that the close button is not visible at first
                screen.checkCloseButtonDoesNotExist()
                // Wait for the close button to be visible
                screen.waitAndCheckForCloseButton()
            }
        }
    }

    func test_closeButton_disabled() throws {
        adsListScreen(app) {
            $0.waitForView()
            $0.tapSettingsButton()
            
            settingsScreen(app) { settings in
                settings.waitForView()
                settings.tapCloseButtonHidden()
                settings.tapCloseButton()
            }
            
            $0.tapPlacement(withName: "Plain Grey VPAID Ad")
            
            interactiveVideoScreen(app) { screen in
                screen.waitForView()
                // Check that the close button is not visible
                screen.checkCloseButtonDoesNotExist()
                UIAwait(forSeconds: 5)
                // Check that the close button is still not visible
                screen.checkCloseButtonDoesNotExist()
            }
        }
    }

    func test_leaveVideoWarning_Enabled() throws {
        adsListScreen(app) { adsList in
            adsList.waitForView()
            adsList.tapSettingsButton()

            settingsScreen(app) { settings in
                settings.waitForView()
                settings.tapLeaveVideoWarningEnable()
                settings.tapCloseButtonNoDelay()
                settings.tapCloseButton()
            }

            adsList.tapPlacement(withName: "Plain Grey VPAID Ad")

            interactiveVideoScreen(app) { screen in
                screen.waitForView()
                screen.tapClose()

                // Show dialog and resume video
                questionDialog(app) { dialog in
                    dialog.checkTitle(hasText: "Close Video?")
                    dialog.tapNoButton()
                }

                screen.waitForRender()
                screen.tapClose()

                adsList.checkTableViewDoesNotExists()

                // Show dialog and exit video
                questionDialog(app) { dialog in
                    dialog.checkTitle(hasText: "Close Video?")
                    dialog.tapYesButton()
                }

                adsList.checkTableViewExists()
            }
        }
    }

    func test_adPause_adPlay() throws {
        adsListScreen(app) { adsList in
            adsList.waitForView()
            adsList.tapSettingsButton()
            
            settingsScreen(app) { settings in
                settings.waitForView()
                settings.tapParentalGateEnable()
                settings.tapCloseButton()
            }
            
            adsList.tapPlacement(withName: "Plain Grey VPAID Ad")
            
            interactiveVideoScreen(app) { screen in
                screen.waitForView()
                screen.waitForRender()
                screen.tapOnAd()
                
                parentGateAlert(app) { parentGate in
                    parentGate.waitForView()
                    parentGate.checkTitle(hasText: parentGate.title)
                    parentGate.checkMessage(hasText: parentGate.questionMessage)
                    parentGate.checkPlaceholder(hasText: "")
                    parentGate.tapCancelButton()
                }
                
                screen.waitForRender()
                screen.tapClose()
                
                adsList.assertEvent("adPaused")
                adsList.assertEvent("adPlaying")
            }
        }
    }

    func test_adLoaded_event() throws {
        adsListScreen(app) { adsList in
            adsList.waitForView()
            adsList.tapSettingsButton()
            
            settingsScreen(app) { settings in
                settings.waitForView()
                settings.tapCloseButtonNoDelay()
                settings.tapCloseButton()
            }
            
            adsList.tapPlacement(withName: "Plain Grey VPAID Ad")
            
            interactiveVideoScreen(app) { screen in
                screen.waitForView()
                screen.waitForRender()
                screen.tapClose()
                
                adsList.assertEvent("adLoaded")
            }
        }
    }

    func test_adShown_event() throws {
        adsListScreen(app) { adsList in
            adsList.waitForView()
            adsList.tapSettingsButton()
            
            settingsScreen(app) { settings in
                settings.waitForView()
                settings.tapCloseButtonNoDelay()
                settings.tapCloseButton()
            }
            
            adsList.tapPlacement(withName: "Plain Grey VPAID Ad")
            
            interactiveVideoScreen(app) { screen in
                screen.waitForView()
                screen.waitForRender()
                screen.tapClose()
                
                adsList.assertEvent("adShown")
            }
        }
    }

    func test_adClicked_event() throws {
        adsListScreen(app) { adsList in
            adsList.waitForView()
            adsList.tapSettingsButton()
            
            settingsScreen(app) { settings in
                settings.waitForView()
                settings.tapCloseButtonNoDelay()
                settings.tapCloseButton()
            }
            
            adsList.tapPlacement(withName: "Plain Grey VPAID Ad")
            
            interactiveVideoScreen(app) { screen in
                screen.waitForView()
                screen.waitForRender()
                screen.tapOnAd()
                
                safari { safari in
                    safari.waitForView()
                }
                
                // Return to the app from Safari
                app.activate()
                
                // The ad content is visible
                screen.waitForRender()
                
                screen.tapClose()
                
                adsList.assertEvent("adClicked")
            }
        }
    }

    func test_adEnded_event() throws {
        adsListScreen(app) { adsList in
            adsList.waitForView()
            
            adsList.tapPlacement(withName: "Plain Grey VPAID Ad")
            
            interactiveVideoScreen(app) { screen in
                screen.waitForView()
                screen.waitForRender()
                
                // The ad list is visible again after the ad ends
                adsList.waitForView(timeout: .extraLong)
                adsList.assertEvent("adEnded")
            }
        }
    }

    func test_adClosed_event() throws {
        adsListScreen(app) { adsList in
            adsList.waitForView()
            adsList.tapSettingsButton()
            
            settingsScreen(app) { settings in
                settings.waitForView()
                settings.tapCloseButtonNoDelay()
                settings.tapCloseButton()
            }
            
            adsList.tapPlacement(withName: "Plain Grey VPAID Ad")
            
            interactiveVideoScreen(app) { screen in
                screen.waitForView()
                screen.waitForRender()
                screen.tapClose()
                
                adsList.assertEvent("adClosed")
            }
        }
    }

    func test_adFailedToLoad_event() throws {
        adsListScreen(app) { adsList in
            adsList.waitForView()
            adsList.tapPlacement(withName: "VPAID Ad Not Found")
            UIAwait(forSeconds: 3)
            adsList.assertEvent("adFailedToLoad")
        }
    }
}
