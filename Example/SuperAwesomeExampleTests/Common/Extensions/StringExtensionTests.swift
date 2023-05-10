//
//  StringTests.swift
//  SuperAwesome
//
//  Created by Gunhan Sancar on 09/07/2020.
//

import XCTest
import Nimble
@testable import SuperAwesome

class StringExtensionTests: XCTestCase {

    func test_toMD5_method_on_String_type() {
        // given
        let string = "https://www.superawesome.com/"

        // when
        let hash = string.toMD5

        // then
        expect(hash).to(equal("70fd049dae5aae534b4caba53576611f"))
    }

    func test_fileExtension_method_on_String_type() {
        // given
        let file1 = "myfile.txt"
        let file2 = "myfile.something.png"
        let file3 = "myfile"

        // when
        let result1 = file1.fileExtension
        let result2 = file2.fileExtension
        let result3 = file3.fileExtension

        // then
        expect(result1).to(equal("txt"))
        expect(result2).to(equal("png"))
        expect(result3).to(beNil())
    }

    func test_baseUrl_method_on_String_type() {
        // given
        let url1 = "https://my.url.com/path/to/image.png"
        let url2 = "hhhsasaaaa"

        // when
        let result1 = url1.baseUrl
        let result2 = url2.baseUrl

        // then
        expect(result1).to(equal("https://my.url.com"))
        expect(result2).to(equal("://"))
    }

    func test_toInt_method_on_String_type() {
        // given
        let int1 = "65"
        let int2 = "wow"

        // when
        let result1 = int1.toInt
        let result2 = int2.toInt

        // then
        expect(result1).to(equal(65))
        expect(result2).to(beNil())
    }

    func test_nilOrEmpty_operator() {
        // given
        let control = "control"
        let given1 = ""
        let given2 = "abc"
        let given3: String? = nil

        // when
        let result1 = given1 ??? control
        let result2 = given2 ??? control
        let result3 = given3 ??? control

        // then
        expect(result1).to(equal(control))
        expect(result2).to(equal(given2))
        expect(result3).to(equal(control))
    }

    func test_extractURLs_when_string_contains_one_url_start_string() {

        // given
        let string = "https://website.com urls"

        // when
        let result = string.extractURLs()

        // then
        XCTAssertEqual(result.count, 1)
        XCTAssertEqual(result.first?.absoluteString, "https://website.com")
    }

    func test_extractURLs_when_string_contains_one_url_mid_string() {

        // given
        let string = "This is a string with https://website.com urls"

        // when
        let result = string.extractURLs()

        // then
        XCTAssertEqual(result.count, 1)
        XCTAssertEqual(result.first?.absoluteString, "https://website.com")
    }

    func test_extractURLs_when_string_contains_one_url_end_string() {

        // given
        let string = "This is a string with https://website.com"

        // when
        let result = string.extractURLs()

        // then
        XCTAssertEqual(result.count, 1)
        XCTAssertEqual(result.first?.absoluteString, "https://website.com")
    }

    func test_extractURLs_when_string_contains_two() {

        // given
        let string = "This is a string with https://website.com urls http://someurl.co.uk"

        // when
        let result = string.extractURLs()

        // then
        XCTAssertEqual(result.count, 2)
        XCTAssertEqual(result.first?.absoluteString, "https://website.com")
        XCTAssertEqual(result.last?.absoluteString, "http://someurl.co.uk")
    }

    func test_extractURLs_when_string_contains_three() {

        // given
        let string = "This is a string with https://website.com urls http://someurl.co.uk something something http://blah.com"

        // when
        let result = string.extractURLs()

        // then
        XCTAssertEqual(result.count, 3)
        XCTAssertEqual(result.first?.absoluteString, "https://website.com")
        XCTAssertEqual(result[1].absoluteString, "http://someurl.co.uk")
        XCTAssertEqual(result.last?.absoluteString, "http://blah.com")
    }

    func test_extractURLs_in_realistic_case() {

        // given
        let string = "<html>\n    <header>\n        <meta name='viewport' content='width=device-width'/>\n        <style>html, body, div { margin: 0px; padding: 0px; } html, body { width: 100%; height: 100%; }</style>\n    </header>\n    <body><script type=\"text/javascript\" src=\"https://eu-west-1-ads.superawesome.tv/v2/ad.js?placement=89056&lineItemId=182932&creativeId=510371&sdkVersion=ios_8.6.0&rnd=d31df441-aca9-4018-8a6b-61f3fe31886a&bundle=tv.superawesome.awesomeads.sdk&dauid=287646772018416067&ct=2&lang=en_US&device=phone&pos=7&timestamp=_TIMESTAMP_&skip=1&playbackmethod=5&startdelay=null&instl=1&isProgrammatic=true&vpaid=true\"></script></body>\n    </html>"

        // when
        let result = string.extractURLs()

        // then
        XCTAssertEqual(result.count, 1)
        XCTAssertEqual(result.first?.absoluteString, "https://eu-west-1-ads.superawesome.tv/v2/ad.js")
    }

    func test_extractURLs_when_string_contains_partial_url_host_only() {

        // given
        let string = "This is a string with https:// urls"

        // when
        let result = string.extractURLs()

        // then
        XCTAssertEqual(result.count, 0)
    }

    func test_extractURLs_when_string_contains_partial_url_incomplete_host_only() {

        // given
        let string = "This is a string with https:/ urls"

        // when
        let result = string.extractURLs()

        // then
        XCTAssertEqual(result.count, 0)
    }

    func test_extractURLs_when_string_contains_more_partial_url() {

        // given
        let string = "This is a string with https://something urls"

        // when
        let result = string.extractURLs()

        // then
        XCTAssertEqual(result.count, 1)
    }

    func test_extractURLs_when_string_contains_url_no_host() {

        // given
        let string = "This is a string with www.something.co.uk urls"

        // when
        let result = string.extractURLs()

        // then
        XCTAssertEqual(result.count, 1)
    }

    func test_extractURLs_when_string_does_not_contain_them() {

        // given
        let string = "This is a string with no urls"

        // when
        let result = string.extractURLs()

        // then
        XCTAssertEqual(result.count, 0)
    }
}
