//
//  AwesomeAdsApiTests.swift
//  Tests
//
//  Created by Gunhan Sancar on 16/04/2020.
//

import XCTest
import Nimble
import Moya
import Mockingjay
@testable import SuperAwesome

class UITests: XCTestCase {
    var app: XCUIApplication!

    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        app = XCUIApplication()
        app.launchArguments.append("--uitesting")
    }

    func test_banner_ads() {
        app.launch()
//        let controller = TestViewController()
//        UIApplication.shared.keyWindow?.rootViewController = controller
//
//        // Make sure we're displaying onboarding
////        XCTAssertTrue(a//pp?.isdi)
//
//        // Swipe left three times to go through the pages
//        app.swipeLeft()
//        app.swipeLeft()
//        app.swipeLeft()
//
//        // Tap the "Done" button
//        app.buttons["Done"].tap()

        // Onboarding should no longer be displayed
//        XCTAssertFalse(app.isDisplayingOnboarding)
    }
}
