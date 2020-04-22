//
//  EncoderTests.swift
//  Tests
//
//  Created by Gunhan Sancar on 22/04/2020.
//  Copyright © 2020 Gabriel Coman. All rights reserved.
//

import XCTest
import Nimble
@testable import SuperAwesome

class EncoderTests: XCTestCase {
    func testEncoding() throws {
        // Given
        let encoder = Encoder()
        let given1 = "https://s3-eu-west-1.amazonaws.com/sb-ads-video-transcoded/x7XkGy43vim5P1OpldlOUuxk2cuKsDSn.mp4"
        let given2 = ""
        let given3: String? = nil
        let given4 = "Gunhan Sancar"
        
        // Then
        expect(encoder.encodeUri(given1)).to(equal("https%3A%2F%2Fs3-eu-west-1.amazonaws.com%2Fsb-ads-video-transcoded%2Fx7XkGy43vim5P1OpldlOUuxk2cuKsDSn.mp4"))
        expect(encoder.encodeUri(given2)).to(equal(""))
        expect(encoder.encodeUri(given3)).to(equal(""))
        expect(encoder.encodeUri(given4)).to(equal("Gunhan%20Sancar"))
    }
}
