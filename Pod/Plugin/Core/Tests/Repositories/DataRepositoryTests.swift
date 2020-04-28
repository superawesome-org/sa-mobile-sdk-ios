//
//  DataRepositoryTests.swift
//  Tests
//
//  Created by Gunhan Sancar on 06/04/2020.
//


import XCTest
import Nimble
@testable import SuperAwesome

class DataRepositoryTests: XCTestCase {
    func testUserAgentName() throws {
        expect(DataRepositoryMock("mockUserAgent").userAgent).to(equal("mockUserAgent"))
        expect(DataRepositoryMock(nil).userAgent).to(beNil())
    }
}
