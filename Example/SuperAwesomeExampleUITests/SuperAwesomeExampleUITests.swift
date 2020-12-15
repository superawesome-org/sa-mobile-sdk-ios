//
//  SuperAwesomeExampleUITests.swift
//  SuperAwesomeExampleUITests
//
//  Created by Gunhan Sancar on 29/10/2020.
//

import XCTest

/*
 In this test configuration 1 and configuration 2 is used
 Configuration 1 represents the following options and Configuration 2 represents the otherwise
 enableParantalGate = true
 enableBumperPage = true
 */
class SuperAwesomeExampleUITests: XCTestCase {
    let bannerId = 44258
    let interstitialId = 44259
    let videoId = 44262
    
    let exists = NSPredicate(format: "exists == true")
    let parentalQuestionPredicate = NSPredicate(format: "label BEGINSWITH 'Please solve the following problem to continue'")
    private var app: XCUIApplication!
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }
    
    private func tapConfig1() { app.buttons["Config 1"].tap() }
    private func tapConfig2() { app.buttons["Config 2"].tap() }

    private func tapBanner() { app.staticTexts["  Banner - \(bannerId)  "].tap() }
    private func tapInterstitial() { app.staticTexts["  Interstitial - \(interstitialId)  "].tap() }
    private func tapVideo() { app.staticTexts["  Video - \(videoId)  "].tap() }
    
    private func waitAndTapWebView() {
        let webElement = app.webViews.webViews.webViews.links.children(matching: .image).element
        _ = webElement.waitForExistence(timeout: 10.0)
        webElement.tap()
    }
    
    private func waitAndTapBackFromSafari() {
        let safari = XCUIApplication(bundleIdentifier: "com.apple.mobilesafari")
        _ = safari.wait(for: .runningForeground, timeout: 30)
        app.activate()
    }
    
    private func findParentalGateAndTypeAnswer() {
        // Find Parantal gate popup
        let elementsQuery = app.alerts["Parental Gate"].scrollViews.otherElements
        let questionLabel = elementsQuery.staticTexts.element(matching: parentalQuestionPredicate)
        
        // Extract the numbers from the question
        let numbers = questionLabel.label.components(separatedBy: CharacterSet.decimalDigits.inverted).filter { text -> Bool in
            !text.isEmpty
        }
        let total = (Int(numbers[0]) ?? 0) + (Int(numbers[1]) ?? 0)
        debugPrint("Extracted \(numbers[0]) + \(numbers[1]) = \(total)")
        
        // Type total into the textfield
        let inputElement = elementsQuery.textFields.firstMatch
        inputElement.tap()
        inputElement.typeText("\(total)")
        elementsQuery.buttons["Continue"].tap()
    }
    
    private func tapCoordinate(x: CGFloat, y: CGFloat) {
        let normalized = app.coordinate(withNormalizedOffset: CGVector(dx: 0, dy: 0))
        let coordinate = normalized.withOffset(CGVector(dx: x, dy: y))
        coordinate.tap()
    }
    
    private func tapCloseButton() {
        app.windows.children(matching: .other).element.children(matching: .other).element.children(matching: .button).element.tap()
    }
    
    private func tapVideoCloseButton() {
        app.windows.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .button).element(boundBy: 1).tap()
    }
    
    private func waitAndClickOnVideo() {
        let button = app.windows.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .button).element(boundBy: 0)
        _ = button.waitForExistence(timeout: 10.0)
        sleep(1)
        button.tap()
    }
    
    func test_config1_banner() throws {
        tapConfig1()
        tapBanner()
        
        // Wait for banner to appear and tap
        waitAndTapWebView()
        
        findParentalGateAndTypeAnswer()
        
        // Wait for bumper to appear
        let bumper = app.children(matching: .window).element(boundBy: 1).children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element
        _ = bumper.waitForExistence(timeout: 4.0)
        
        // Wait for redirect and come back to test app
        waitAndTapBackFromSafari()
    }
    
    func test_config2_banner() throws {
        tapConfig2()
        tapBanner()
        waitAndTapWebView()
        waitAndTapBackFromSafari()
    }
    
    func test_config1_interstitial() throws {
        tapConfig1()
        tapInterstitial()
        
        let element = app.webViews.webViews.webViews.element
        _ = element.waitForExistence(timeout: 5.0)
        
        sleep(1)
        
        // Trigger action on the test ad
        tapCoordinate(x: element.frame.midX, y: element.frame.midY + 40)
        
        findParentalGateAndTypeAnswer()
        
        waitAndTapBackFromSafari()
        
        tapCloseButton()
    }
    
    func test_config2_interstitial() throws {
        tapConfig2()
        tapInterstitial()
        
        let element = app.webViews.webViews.webViews.element
        _ = element.waitForExistence(timeout: 5.0)
        
        // Trigger action on the test ad
        tapCoordinate(x: element.frame.midX, y: element.frame.midY + 40)
                
        waitAndTapBackFromSafari()
        
        tapCloseButton()
    }
    
    func test_config1_video() throws {
        tapConfig1()
        tapVideo()
        waitAndClickOnVideo()
        findParentalGateAndTypeAnswer()
        waitAndTapBackFromSafari()
        tapVideoCloseButton()
    }
    
    func test_config2_video() throws {
        tapConfig2()
        tapVideo()
        waitAndClickOnVideo()
        waitAndTapBackFromSafari()
        tapVideoCloseButton()
    }
}
