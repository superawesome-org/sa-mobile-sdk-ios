//
//  BannerUITests.swift
//  SuperAwesomeExampleUITests
//
//  Created by Myles Eynon on 03/04/2023.
//

import XCTest

class BannerUITests: BaseUITest {
    
    func testAdAppears() throws {
        
        adsListScreen(app) {
            $0.waitForView()
            $0.tapPlacement(withName: "Banner")
            
            banner(app) { banner in
                banner.waitForView()
                banner.waitForRender()
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
            
            $0.tapPlacement(withName: "Banner")
            
            banner(app) { banner in
                banner.waitForView()
                banner.checkPadlockButtonExists()
                banner.tapBanner()
                
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
            
            banner(app) { banner in
                banner.waitForView()
                banner.checkPadlockButtonExists()
                banner.tapBanner()
                
                parentGateAlert(app) { parentGate in
                    parentGate.waitForView()
                    parentGate.checkTitle(hasText: parentGate.title)
                    parentGate.checkMessage(hasText: parentGate.questionMessage)
                    parentGate.checkPlaceholder(hasText: "")
                    parentGate.tapCancelButton()
                }
                
                banner.tapBanner()
                
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
}
