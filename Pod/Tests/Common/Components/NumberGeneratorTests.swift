//
//  NumberGeneratorTests.swift
//  SuperAwesome-Unit-Moya-Tests
//
//  Created by Gunhan Sancar on 04/05/2020.
//

import XCTest
import Nimble
@testable import SuperAwesome

class NumberGeneratorTests: XCTestCase {
    let numberGenerator = NumberGenerator()

    func test_uniquenessOfAlphanumericIdGeneration() throws {
        // Given
        let length = 32
        var listOfItems: [String] = []
        var duplicateFound = false

        // When
        for _ in 0...100 {
            let next = numberGenerator.nextAlphanumericString(length: length)

            if listOfItems.contains(next) {
                duplicateFound = true
                break
            }

            listOfItems.append(next)
        }

        // Then
        expect(duplicateFound).to(equal(false))
    }

    func test_nextFloatForMoat() throws {
        // When
        let result = numberGenerator.nextFloatForMoat()

        // Then
        expect(result) > 0
        expect(result) < 1
    }

    func test_nextIntForCache() throws {
        // When
        let result = numberGenerator.nextIntForCache()

        // Then
        expect(result) > 1000000
        expect(result) < 1500000
    }

    func test_nextIntForParentalGate() throws {
        // When
        let result = numberGenerator.nextIntForParentalGate()

        // Then
        expect(result) >= 50
        expect(result) < 99
    }
}
