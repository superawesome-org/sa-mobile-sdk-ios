//
//  PreferencesRepositoryTests.swift
//  Tests
//
//  Created by Gunhan Sancar on 06/04/2020.
//

import XCTest
import Nimble
@testable import SuperAwesome

class PreferencesRepositoryTests: XCTestCase {
    func testUserAgentName() throws {
        expect(PreferencesRepositoryMock(userAgent: "mockUserAgent").userAgent).to(equal("mockUserAgent"))
        expect(PreferencesRepositoryMock(userAgent: nil).userAgent).to(beNil())
    }

    func testUniqueDauPart() throws {
        expect(PreferencesRepositoryMock(dauUniquePart: "mockDauId").dauUniquePart).to(equal("mockDauId"))
        expect(PreferencesRepositoryMock(dauUniquePart: nil).userAgent).to(beNil())
    }
}
