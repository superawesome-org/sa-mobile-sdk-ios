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
}
