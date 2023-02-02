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
    private lazy var queryMaker = { buildQueryMaker(options: nil) }()

    private let initialOptions: [String: Any] = [
        "testKey1": "testValue1",
        "testKey2": 2
    ]

    private let additionalOptions: [String: Any] = [
        "testKey3": "testValue3",
        "testKey4": 4
    ]
    private let combinedOptions: [String: Any] = [
        "testKey1": "testValue1",
        "testKey2": 2,
        "testKey3": "testValue3",
        "testKey4": 4
    ]

    func test_adQuery() throws {
        // Given
        let request = AdRequest(test: false,
                                position: .aboveTheFold,
                                skip: .no,
                                playbackMethod: 5,
                                startDelay: AdRequest.StartDelay.midRoll,
                                instl: .off,
                                width: 20,
                                height: 30,
                                options: nil)

        // When
        let bundle = queryMaker.makeAdQuery(request)
        guard let query = bundle.parameters as? AdQuery else { return }

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
        expect(query.startDelay).to(equal(AdRequest.StartDelay.midRoll.rawValue))
        expect(query.test).to(equal(false))
        expect(query.width).to(equal(20))
    }

    func test_clickQuery() throws {
        // Given
        let response = MockFactory.makeAdResponse()

        // When
        let bundle = queryMaker.makeClickQuery(response)
        guard let query = bundle.parameters as? EventQuery else { return }

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
        let bundle = queryMaker.makeClickQuery(response)
        guard let query = bundle.parameters as? EventQuery else { return }

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
        let bundle = queryMaker.makeEventQuery(response, data)
        guard let query = bundle.parameters as? EventQuery else { return }

        // Then
        expect(query.bundle).to(equal("SdkInfoMockBundle"))
        expect(query.creative).to(equal(80))
        expect(query.connectionType).to(equal(.ethernet))
        expect(query.data).to(equal("EncoderMockToJson"))
        expect(query.lineItem).to(equal(50))
        expect(query.noImage).to(beNil())
        expect(query.placement).to(equal(10))
        expect(query.rnd).to(equal(400))
        expect(query.sdkVersion).to(equal("SdkInfoMockVersion"))
        expect(query.type).to(equal(.impressionDownloaded))
    }

    // MARK: - Test options

    func test_adQuery_with_no_options() throws {
        // Given
        let queryMaker = buildQueryMaker(options: nil)

        let request = AdRequest(test: false,
                                position: .aboveTheFold,
                                skip: .no,
                                playbackMethod: 5,
                                startDelay: AdRequest.StartDelay.midRoll,
                                instl: .off,
                                width: 20,
                                height: 30,
                                options: nil)

        // When
        let bundle = queryMaker.makeAdQuery(request)
        guard let options = bundle.options else { return }

        // Then
        XCTAssertTrue(options.isEmpty)
    }

    func test_adQuery_with_initial_options_only() throws {
        // Given
        let queryMaker = buildQueryMaker(options: initialOptions)

        let request = AdRequest(test: false,
                                position: .aboveTheFold,
                                skip: .no,
                                playbackMethod: 5,
                                startDelay: AdRequest.StartDelay.midRoll,
                                instl: .off,
                                width: 20,
                                height: 30,
                                options: nil)

        // When
        let bundle = queryMaker.makeAdQuery(request)
        guard let options = bundle.options else { return }

        // Then
        verifyOptions(options: options, expectedOptions: initialOptions)
    }

    func test_adQuery_with_additional_options_only() throws {
        // Given
        let queryMaker = buildQueryMaker(options: nil)

        let request = AdRequest(test: false,
                                position: .aboveTheFold,
                                skip: .no,
                                playbackMethod: 5,
                                startDelay: AdRequest.StartDelay.midRoll,
                                instl: .off,
                                width: 20,
                                height: 30,
                                options: additionalOptions)

        // When
        let bundle = queryMaker.makeAdQuery(request)
        guard
            let options = bundle.options
        else { return }

        // Then
        verifyOptions(options: options, expectedOptions: additionalOptions)
    }

    func test_adQuery_with_initial_options_and_additional_options() throws {
        // Given
        let queryMaker = buildQueryMaker(options: initialOptions)

        let request = AdRequest(test: false,
                                position: .aboveTheFold,
                                skip: .no,
                                playbackMethod: 5,
                                startDelay: AdRequest.StartDelay.midRoll,
                                instl: .off,
                                width: 20,
                                height: 30,
                                options: additionalOptions)

        // When
        let bundle = queryMaker.makeAdQuery(request)
        guard let options = bundle.options else { return }

        // Then
        verifyOptions(options: options, expectedOptions: combinedOptions)
    }

    func test_adQuery_additional_options_can_override_initial_options_when_keys_conflict() throws {
        // Given
        let queryMaker = buildQueryMaker(options: initialOptions)

        let additionalOptions = ["testKey1": "x"]

        let request = AdRequest(test: false,
                                position: .aboveTheFold,
                                skip: .no,
                                playbackMethod: 5,
                                startDelay: AdRequest.StartDelay.midRoll,
                                instl: .off,
                                width: 20,
                                height: 30,
                                options: additionalOptions)

        // When
        let bundle = queryMaker.makeAdQuery(request)
        guard let options = bundle.options else { return }

        // Then
        let expectedOptions: [String: Any] = ["testKey1": "x",
                                              "testKey2": 2,
                                              "testKey3": true]
        verifyOptions(options: options, expectedOptions: expectedOptions)
    }

    func test_adQuery_unsuitable_types_are_not_included() throws {
        // Given
        let queryMaker = buildQueryMaker(options: initialOptions)

        let additionalOptions: [String: Any] = ["testKey3": UIViewController(), "testKey4": 4]

        let request = AdRequest(test: false,
                                position: .aboveTheFold,
                                skip: .no,
                                playbackMethod: 5,
                                startDelay: AdRequest.StartDelay.midRoll,
                                instl: .off,
                                width: 20,
                                height: 30,
                                options: additionalOptions)

        // When
        let bundle = queryMaker.makeAdQuery(request)
        guard let options = bundle.options else { return }

        // Then
        let expectedOptions: [String: Any] = ["testKey1": "testValue1", "testKey2": 2, "testKey4": 4]
        verifyOptions(options: options, expectedOptions: expectedOptions)
    }

    // MARK: - Conveniences

    private func buildQueryMaker(options: [String: Any]?) -> AdQueryMaker {
        return AdQueryMaker(device: DeviceMock(),
                            sdkInfo: SdkInfoMock(),
                            connectionProvider: ConnectionProviderMock(),
                            numberGenerator: NumberGeneratorMock(400),
                            idGenerator: IdGeneratorMock(300),
                            encoder: EncoderMock(),
                            options: options)
    }

    private func verifyOptions(options: [String: Any], expectedOptions: [String: Any]) {
        for (key, value) in options {
            switch(value, expectedOptions[key]) {
            case let (x, y) as (String, String):
                expect(x).to(equal(y))
            case let (x, y) as (Int, Int):
                expect(x).to(equal(y))
            default:
                XCTFail("The dictionary did not contain the expected value")
            }
        }
    }
}
