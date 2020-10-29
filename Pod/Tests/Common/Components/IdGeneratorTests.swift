//
//  IdGeneratorTests.swift
//  SuperAwesome-Unit-Moya-Tests
//
//  Created by Gunhan Sancar on 04/05/2020.
//

import XCTest
import Nimble
@testable import SuperAwesome

class IdGeneratorTests: XCTestCase {
    func test_dauId_advertisingEnabled_returnsUniqueDauId() throws {
        // Given
        let mockAlphanumeric = "123abc"
        let idGenerator = IdGenerator(preferencesRepository: PreferencesRepositoryMock(),
                                      sdkInfo: SdkInfoMock(),
                                      numberGenerator: NumberGeneratorMock(0, nextAlphaNumberic: mockAlphanumeric), dateProvider: DateProviderMock(monthYear: "102020"))
        
        // When
        let result = idGenerator.uniqueDauId
        
        // Then
        expect(5118545265961385482).to(equal(result))
    }
}
