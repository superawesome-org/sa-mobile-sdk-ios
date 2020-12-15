//
//  AdQueryMakerTests.swift
//  SuperAwesome-Unit-Moya-Tests
//
//  Created by Gunhan Sancar on 30/04/2020.
//

import XCTest
import Nimble
@testable import SuperAwesome

class AdQueryMakerTests: XCTestCase {
    private let queryMaker = AdQueryMaker(device: DeviceMock(),
                                          sdkInfo: SdkInfoMock(),
                                          connectionProvider: ConnectionProviderMock(),
                                          numberGenerator: NumberGeneratorMock(400),
                                          idGenerator: IdGeneratorMock(300),
                                          encoder: EncoderMock())
    
    func test_adQuery() throws {
        // Given
        let request = AdRequest(test: false,
                                pos: .aboveTheFold,
                                skip: .no,
                                playbackmethod: 10,
                                startdelay: .genericMidRoll,
                                instl: .off,
                                w: 20,
                                h: 30)
        
        // When
        let query = queryMaker.makeAdQuery(request)
        
        // Then
        expect(query.bundle).to(equal("SdkInfoMockBundle"))
        expect(query.ct).to(equal(.ethernet))
        expect(query.dauid).to(equal(300))
        expect(query.device).to(equal("DeviceMockGenericType"))
        expect(query.h).to(equal(30))
        expect(query.instl).to(equal(0))
        expect(query.lang).to(equal("SdkInfoMockLang"))
        expect(query.name).to(equal("SdkInfoMockName"))
        expect(query.playbackmethod).to(equal(10))
        expect(query.pos).to(equal(1))
        expect(query.rnd).to(equal(400))
        expect(query.sdkVersion).to(equal("SdkInfoMockVersion"))
        expect(query.skip).to(equal(0))
        expect(query.startdelay).to(equal(-1))
        expect(query.test).to(equal(false))
        expect(query.w).to(equal(20))
    }
    
    func test_clickQuery() throws {
        // Given
        let response = MockFactory.makeAdResponse()
        
        // When
        let query = queryMaker.makeClickQuery(response)
        
        // Then
        expect(query.bundle).to(equal("SdkInfoMockBundle"))
        expect(query.creative).to(equal(80))
        expect(query.ct).to(equal(.ethernet))
        expect(query.data).to(beNil())
        expect(query.line_item).to(equal(50))
        expect(query.no_image).to(beNil())
        expect(query.placement).to(equal(10))
        expect(query.rnd).to(equal(400))
        expect(query.sdkVersion).to(equal("SdkInfoMockVersion"))
        expect(query.type).to(beNil())
    }
    
    func test_videoClickQuery() throws {
        // Given
        let response = MockFactory.makeAdResponse()
        
        // When
        let query = queryMaker.makeVideoClickQuery(response)
        
        // Then
        expect(query.bundle).to(equal("SdkInfoMockBundle"))
        expect(query.creative).to(equal(80))
        expect(query.ct).to(equal(.ethernet))
        expect(query.data).to(beNil())
        expect(query.line_item).to(equal(50))
        expect(query.no_image).to(beNil())
        expect(query.placement).to(equal(10))
        expect(query.rnd).to(equal(400))
        expect(query.sdkVersion).to(equal("SdkInfoMockVersion"))
        expect(query.type).to(beNil())
    }
    
    func test_eventQuery() throws {
        // Given
        let response = MockFactory.makeAdResponse()
        let data = EventData(placement: 10, line_item: 20, creative: 30, type: .impressionDownloaded)
        
        // When
        let query = queryMaker.makeEventQuery(response, data)
        
        // Then
        expect(query.bundle).to(equal("SdkInfoMockBundle"))
        expect(query.creative).to(equal(80))
        expect(query.ct).to(equal(.ethernet))
        expect(query.data).to(equal("EncoderMockEncodeUri"))
        expect(query.line_item).to(equal(50))
        expect(query.no_image).to(beNil())
        expect(query.placement).to(equal(10))
        expect(query.rnd).to(equal(400))
        expect(query.sdkVersion).to(equal("SdkInfoMockVersion"))
        expect(query.type).to(equal(.impressionDownloaded))
    }
}
