//
//  TimeProviderTests.swift
//  SuperAwesomeExampleTests
//
//  Created by Gunhan Sancar on 20/10/2022.
//

import XCTest
import Nimble
@testable import SuperAwesome

class TimeProviderTests: XCTestCase {
    func test_secondsSince1970() throws {
        // Given
        let timeProvider = TimeProvider()

        // When
        let result = timeProvider.secondsSince1970
        let diff = abs(NSDate().timeIntervalSince1970 - result)

        // Then
        expect(diff).to(beLessThan(0.1))
    }
}
