//
//  URLExtensionTests.swift
//  SuperAwesomeExampleTests
//
//  Created by Myles Eynon on 09/05/2023.
//

import XCTest

@testable import SuperAwesome

class URLExtenstionTests: XCTestCase {

    func test_cleanBaseUrl_with_path_params() {

        // given
        let url = URL(string: "https://something.com/blah/web.js?something=some&blah=3")!

        // when
        let result = url.cleanBaseUrl

        // then
        XCTAssertEqual(result, "https://something.com")
    }

    func test_cleanBaseUrl_with_noPath_noParams_trailingSlash() {

        // given
        let url = URL(string: "https://something.com/")!

        // when
        let result = url.cleanBaseUrl

        // then
        XCTAssertEqual(result, "https://something.com")
    }

    func test_cleanBaseUrl_with_noPath_noParams() {

        // given
        let url = URL(string: "https://something.com")!

        // when
        let result = url.cleanBaseUrl

        // then
        XCTAssertEqual(result, "https://something.com")
    }

    func test_cleanBaseUrl_with_path() {

        // given
        let url = URL(string: "https://something.com/blah/web.js")!

        // when
        let result = url.cleanBaseUrl

        // then
        XCTAssertEqual(result, "https://something.com")
    }
}
