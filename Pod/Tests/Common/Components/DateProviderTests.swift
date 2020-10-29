//
//  DateProviderTests.swift
//  SuperAwesome-Unit-Full-Tests
//
//  Created by Gunhan Sancar on 29/10/2020.
//

import XCTest
import Nimble
@testable import SuperAwesome

class DateProviderTests: XCTestCase {
    func test_nowAsMonthYear() throws {
        // Given
        let dateProvider = DateProvider()
        
        // When
        let result = dateProvider.nowAsMonthYear()
        
        // Then
        expect(Date().monthYearString).to(equal(result))
    }
}
