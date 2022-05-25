//
//  AwesomeAdsTargetTest.swift
//  SuperAwesomeExampleTests
//
//  Created by Tom O'Rourke on 25/05/2022.
//

import XCTest
import Nimble
@testable import SuperAwesome

class AwesomeAdsTargetTest: XCTestCase {

    private let environment: Environment = .staging
    private let mockAdQuery: AdQuery = AdQueryMakerMock.mockQuery
    private let mocEventdQuery: EventQuery = MockFactory.makeEventQueryInstance()
    private let placementId = 1
    private let lineItemId = 2
    private let creativeId = 3

    func test_target_path_equals_expected_path_for_ad() {

        let target = AwesomeAdsTarget(environment,
                                      .ad(
                                        placementId: placementId,
                                        query: mockAdQuery
                                      ))

        let expectedPath = "/ad/1"

        XCTAssertEqual(expectedPath, target.path)
    }

    func test_target_path_equals_expected_path_for_adByPlacementLineAndCreativeId() {

        let target = AwesomeAdsTarget(environment,
                                      .adByPlacementLineAndCreativeId(
                                        placementId: placementId,
                                        lineItemId: lineItemId,
                                        creativeId: creativeId,
                                        query: mockAdQuery
                                      ))

        let expectedPath = "/ad/1/2/3"

        XCTAssertEqual(expectedPath, target.path)
    }

    func test_target_path_equals_expected_path_for_impression() {

        let target = AwesomeAdsTarget(environment,
                                      .impression(
                                        query: mocEventdQuery
                                      ))

        let expectedPath = "/impression"

        XCTAssertEqual(expectedPath, target.path)
    }

    func test_target_path_equals_expected_path_for_click() {

        let target = AwesomeAdsTarget(environment,
                                      .click(
                                        query: mocEventdQuery
                                      ))

        let expectedPath = "/click"

        XCTAssertEqual(expectedPath, target.path)
    }

    func test_target_path_equals_expected_path_for_videoClick() {

        let target = AwesomeAdsTarget(environment,
                                      .videoClick(
                                        query: mocEventdQuery
                                      ))

        let expectedPath = "/video/click"

        XCTAssertEqual(expectedPath, target.path)
    }

    func test_target_path_equals_expected_path_for_event() {

        let target = AwesomeAdsTarget(environment,
                                      .event(
                                        query: mocEventdQuery
                                      ))

        let expectedPath = "/event"

        XCTAssertEqual(expectedPath, target.path)
    }

    func test_target_path_equals_expected_path_for_signature() {

        let target = AwesomeAdsTarget(environment,
                                      .signature(
                                        lineItemId: lineItemId,
                                        creativeId: creativeId
                                      ))

        let expectedPath = "/skadnetwork/sign/2/3"

        XCTAssertEqual(expectedPath, target.path)
    }
}
