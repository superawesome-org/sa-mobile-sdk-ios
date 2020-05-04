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
    func test_dauId_advertisingDisabled_returnsZero() throws {
        // Given
        let mockAdvertisingIdentifier = UUID()
        let mockAlphanumeric = "123abc"
        let mockAdvertisingManager = ASIdentifierManagerMock(mockIsAdvertisingTrackingEnabled: false,
                                                             mockAdvertisingIdentifier: mockAdvertisingIdentifier)
        let idGenerator = IdGenerator(preferencesRepository: PreferencesRepositoryMock(),
                                      sdkInfo: SdkInfoMock(),
                                      numberGenerator: NumberGeneratorMock(0, nextAlphaNumberic: mockAlphanumeric),
                                      identifierManager: mockAdvertisingManager)
        
        // When
        let dauId = idGenerator.findDauId()
        
        
        // Then
        expect(dauId).to(equal(IdGenerator.Keys.noTracking))
    }
    
    func test_dauId_advertisingEnabled_returnsUniqueDauId() throws {
        // Given
        let mockAdvertisingIdentifier = UUID(uuidString: "EDB32944-B4D1-4299-8BCC-B421885B2716")!
        let mockAlphanumeric = "123abc"
        let mockAdvertisingManager = ASIdentifierManagerMock(mockIsAdvertisingTrackingEnabled: true,
                                                             mockAdvertisingIdentifier: mockAdvertisingIdentifier)
        let idGenerator = IdGenerator(preferencesRepository: PreferencesRepositoryMock(),
                                      sdkInfo: SdkInfoMock(),
                                      numberGenerator: NumberGeneratorMock(0, nextAlphaNumberic: mockAlphanumeric),
                                      identifierManager: mockAdvertisingManager)
        
        // When
        let dauId = idGenerator.findDauId()
        
        // Then
        expect(dauId).to(equal(7884738852088729949))
    }
}
