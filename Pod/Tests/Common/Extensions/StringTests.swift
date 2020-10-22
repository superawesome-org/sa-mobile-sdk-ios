//
//  StringTests.swift
//  SuperAwesome
//
//  Created by Gunhan Sancar on 09/07/2020.
//

import XCTest
import Nimble
@testable import SuperAwesome

class StringTests: XCTestCase {
    func testMD5Hash() {
        let hash = "https://www.superawesome.com/".toMD5
        
        expect(hash).to(equal("70fd049dae5aae534b4caba53576611f"))
    }
}
