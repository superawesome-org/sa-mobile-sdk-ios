//
//  AwesomeAdsTargetTest.swift
//  SuperAwesomeExampleTests
//
//  Created by Tom O'Rourke on 25/05/2022.
//

import XCTest
@testable import SuperAwesome

class AwesomeAdsTargetTest: XCTestCase {

    private let environment: Environment = .staging
    private let mockAdQuery: QueryBundle = AdQueryMakerMock.mockQuery
    private let mocEventdQuery: QueryBundle = MockFactory.makeEventQueryInstance()
    private let placementId = 1
    private let lineItemId = 2
    private let creativeId = 3

    func test_target_path_equals_expected_path_for_ad() {

        let target = AwesomeAdsTarget(environment,
                                      .ad(
                                        placementId: placementId,
                                        query: mockAdQuery
                                      ))

        XCTAssertEqual("/ad/1", target.path)
    }

    func test_target_path_equals_expected_path_for_adByPlacementLineAndCreativeId() {

        let target = AwesomeAdsTarget(environment,
                                      .adByPlacementLineAndCreativeId(
                                        placementId: placementId,
                                        lineItemId: lineItemId,
                                        creativeId: creativeId,
                                        query: mockAdQuery
                                      ))

        XCTAssertEqual("/ad/1/2/3", target.path)
    }

    func test_target_path_equals_expected_path_for_impression() {

        let target = AwesomeAdsTarget(environment,
                                      .impression(
                                        query: mocEventdQuery
                                      ))

        XCTAssertEqual("/impression", target.path)
    }

    func test_target_path_equals_expected_path_for_click() {

        let target = AwesomeAdsTarget(environment,
                                      .click(
                                        query: mocEventdQuery
                                      ))

        XCTAssertEqual("/click", target.path)
    }

    func test_target_path_equals_expected_path_for_videoClick() {

        let target = AwesomeAdsTarget(environment,
                                      .videoClick(
                                        query: mocEventdQuery
                                      ))

        XCTAssertEqual("/video/click", target.path)
    }

    func test_target_path_equals_expected_path_for_event() {

        let target = AwesomeAdsTarget(environment,
                                      .event(
                                        query: mocEventdQuery
                                      ))

        XCTAssertEqual("/event", target.path)
    }

    func test_target_path_equals_expected_path_for_signature() {

        let target = AwesomeAdsTarget(environment,
                                      .signature(
                                        lineItemId: lineItemId,
                                        creativeId: creativeId
                                      ))

        XCTAssertEqual("/skadnetwork/sign/2/3", target.path)
    }
}
