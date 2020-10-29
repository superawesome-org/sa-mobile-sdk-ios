//
//  SuperAwesomeExampleUITests.swift
//  SuperAwesomeExampleUITests
//
//  Created by Gunhan Sancar on 29/10/2020.
//

import XCTest

class SuperAwesomeExampleUITests: XCTestCase {
    let exists = NSPredicate(format: "exists == true")
    
    override func setUpWithError() throws {
        continueAfterFailure = false
    }
    
    override func tearDownWithError() throws {
    }
    
    func testBanner() throws {
        let app = XCUIApplication()
        app.launch()
        
        app.staticTexts["  Banner - 44258  "].tap()
        
        //let expectation = expectation(for: predicate, evaluatedWith: element, handler: nil)
    }
}
