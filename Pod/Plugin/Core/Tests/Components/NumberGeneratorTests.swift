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
    func test_uniquenessOfAlphanumericIdGeneration() throws {
        // Given
        let length = 32
        let numberGenerator = NumberGenerator()
        var listOfItems:[String] = []
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
}
