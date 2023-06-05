//
//  PerformanceTimerTests.swift
//  SuperAwesomeExampleTests
//
//  Created by Gunhan Sancar on 02/06/2023.
//

import XCTest
import Nimble
@testable import SuperAwesome

class PerformanceTimerTests: XCTestCase {
    func test_calculate() throws {
        // Given
        let timeProvider = TimeProviderMock()
        timeProvider.secondsSince1970Mock = 0
        let performanceTimer = PerformanceTimer(timeProvider: timeProvider)

        // When
        timeProvider.secondsSince1970Mock = 33
        let result = performanceTimer.calculate()

        // Then
        expect(result).to(equal(33000))
    }
}
