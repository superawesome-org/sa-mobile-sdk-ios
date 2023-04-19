//
//  InterstitialUITests.swift
//  SuperAwesomeExampleUITests
//
//  Created by Gunhan Sancar on 04/10/2022.
//

import XCTest

class InterstitialUITests: BaseUITest {
        
    func test_ad_load_success() throws {

        adsListScreen(app) {
            $0.waitForView()

            $0.tapPlacement(withName: "Mobile Interstitial Flat Colour Portrait")

            interstitialScreen(app) { interstitialScreen in
                interstitialScreen.waitForView()
                interstitialScreen.waitForRender()
            }
        }
    }
    
    func test_ad_load_success_withBumper() throws {

        adsListScreen(app) {
            $0.waitForView()
            $0.tapSettingsButton()

            settingsScreen(app) { settings in
                settings.waitForView()
                settings.tapBumperEnable()
                settings.tapCloseButton()
            }

            $0.tapPlacement(withName: "Mobile Interstitial Flat Colour Portrait")

            interstitialScreen(app) { interstitialScreen in
                interstitialScreen.waitForView()
                interstitialScreen.tapOnAd()

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
    
    func test_ad_load_success_withParentalGate() throws {

        adsListScreen(app) {
            $0.waitForView()
            $0.tapSettingsButton()

            settingsScreen(app) { settings in
                settings.waitForView()
                settings.tapParentalGateEnable()
                settings.tapCloseButton()
            }
            
            $0.tapPlacement(withName: "Mobile Interstitial Flat Colour Portrait")

            interstitialScreen(app) { interstitialScreen in
                interstitialScreen.waitForView()
                interstitialScreen.tapOnAd()

                parentGateAlert(app) { parentGate in
                    parentGate.waitForView()
                    parentGate.checkTitle(hasText: parentGate.title)
                    parentGate.checkMessage(hasText: parentGate.questionMessage)
                    parentGate.checkPlaceholder(hasText: "")
                    parentGate.tapCancelButton()
                }

                interstitialScreen.tapOnAd()

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
    
    func test_safeAd_logo_parental_gate() throws {
        
        adsListScreen(app) {
            $0.waitForView()
            $0.tapSettingsButton()

            settingsScreen(app) { settings in
                settings.waitForView()
                settings.tapParentalGateEnable()
                settings.tapCloseButton()
            }
            
            $0.tapPlacement(withName: "Mobile Interstitial Flat Colour Portrait")

            interstitialScreen(app) { interstitialScreen in
                interstitialScreen.waitForView()
                
                banner(app) { banner in
                    // Interstitials use the banner internally
                    banner.tapPadlockButton()
                }

                parentGateAlert(app) { parentGate in
                    parentGate.waitForView()
                    parentGate.checkTitle(hasText: parentGate.title)
                    parentGate.checkMessage(hasText: parentGate.questionMessage)
                    parentGate.checkPlaceholder(hasText: "")
                    parentGate.tapCancelButton()
                }

                interstitialScreen.tapOnAd()

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
            $0.tapPlacement(withName: "Mobile Interstitial Portrait")

            interstitialScreen(app) { interstitialScreen in
                interstitialScreen.waitForView()
                banner(app) { banner in
                    // Interstitials use the banner internally
                    banner.checkPadlockButtonDoesNotExist()
                }
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

            $0.tapPlacement(withName: "Mobile Interstitial Flat Colour Portrait")

            interstitialScreen(app) { interstitialScreen in
                interstitialScreen.waitForView()
                // Check that the close button is visible immediately
                interstitialScreen.checkCloseButtonExists()
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

            $0.tapPlacement(withName: "Mobile Interstitial Flat Colour Portrait")

            interstitialScreen(app) { interstitialScreen in
                interstitialScreen.waitForView()
                // Check that the close button is not visible at first
                interstitialScreen.checkCloseButtonDoesNotExist()
                // Wait for the close button to be visible
                interstitialScreen.waitForCloseButton()
            }
        }
    }
}
