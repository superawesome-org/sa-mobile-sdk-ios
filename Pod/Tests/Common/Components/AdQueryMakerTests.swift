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
                                position: .aboveTheFold,
                                skip: .no,
                                instl: .off,
                                width: 20 ,
                                height:30)

        // When
        let query = queryMaker.makeAdQuery(request)

        // Then
        expect(query.bundle).to(equal("SdkInfoMockBundle"))
        expect(query.connectionType).to(equal(.ethernet))
        expect(query.dauid).to(equal(300))
        expect(query.device).to(equal("DeviceMockGenericType"))
        expect(query.height).to(equal(30))
        expect(query.instl).to(equal(0))
        expect(query.lang).to(equal("SdkInfoMockLang"))
        expect(query.name).to(equal("SdkInfoMockName"))
        expect(query.playbackMethod).to(equal(5))
        expect(query.position).to(equal(1))
        expect(query.random).to(equal(400))
        expect(query.sdkVersion).to(equal("SdkInfoMockVersion"))
        expect(query.skip).to(equal(0))
        expect(query.startDelay).to(equal(0))
        expect(query.test).to(equal(false))
        expect(query.width).to(equal(20))
    }

    func test_clickQuery() throws {
        // Given
        let response = MockFactory.makeAdResponse()

        // When
        let query = queryMaker.makeClickQuery(response)

        // Then
        expect(query.bundle).to(equal("SdkInfoMockBundle"))
        expect(query.creative).to(equal(80))
        expect(query.connectionType).to(equal(.ethernet))
        expect(query.data).to(beNil())
        expect(query.lineItem).to(equal(50))
        expect(query.noImage).to(beNil())
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
        expect(query.connectionType).to(equal(.ethernet))
        expect(query.data).to(beNil())
        expect(query.lineItem).to(equal(50))
        expect(query.noImage).to(beNil())
        expect(query.placement).to(equal(10))
        expect(query.rnd).to(equal(400))
        expect(query.sdkVersion).to(equal("SdkInfoMockVersion"))
        expect(query.type).to(beNil())
    }

    func test_eventQuery() throws {
        // Given
        let response = MockFactory.makeAdResponse()
        let data = EventData(placement: 10, lineItem: 20, creative: 30, type: .impressionDownloaded)

        // When
        let query = queryMaker.makeEventQuery(response, data)

        // Then
        expect(query.bundle).to(equal("SdkInfoMockBundle"))
        expect(query.creative).to(equal(80))
        expect(query.connectionType).to(equal(.ethernet))
        expect(query.data).to(equal("EncoderMockEncodeUri"))
        expect(query.lineItem).to(equal(50))
        expect(query.noImage).to(beNil())
        expect(query.placement).to(equal(10))
        expect(query.rnd).to(equal(400))
        expect(query.sdkVersion).to(equal("SdkInfoMockVersion"))
        expect(query.type).to(equal(.impressionDownloaded))
    }
}
