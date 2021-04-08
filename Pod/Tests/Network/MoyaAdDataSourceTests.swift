//
//  MoyaAdDataSourceTests.swift
//  SuperAwesome
//
//  Created by Gunhan Sancar on 30/04/2020.
//

import XCTest
import Nimble
import Moya
import Mockingjay
@testable import SuperAwesome

class MoyaAdDataSourceTests: XCTestCase {
    private var dataSource: MoyaAwesomeAdsApiDataSource!
    private var provider: MoyaProvider<AwesomeAdsTarget>!
    private var adResult: Result<Ad, Error>?
    private var eventResult: Result<Void, Error>?

    override func setUp() {
        provider = MoyaProvider<AwesomeAdsTarget>(plugins: [NetworkLoggerPlugin()])
        dataSource = MoyaAwesomeAdsApiDataSource(provider: provider, environment: .staging)
        adResult = nil
        eventResult = nil
    }

    func test_validResponse_getAdCalled_returnsSuccess() {
        // Given
        let placementId = 1
        stub(uri("/v2/ad/\(placementId)"), jsonData(jsonFile("mock_ad_response_1")))

        // When
        let expectation = self.expectation(description: "Network request")
        dataSource.getAd(placementId: placementId, query: MockFactory.makeAdQueryInstance()) { result in
            self.adResult = result
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2.0, handler: nil)

        // Then
        expect(self.adResult?.isSuccess).to(equal(true))
    }

    func test_invalidResponse_getAdCalled_returnsFailure() {
        // Given
        let placementId = 1
        stub(uri("/v2/ad/\(placementId)"), jsonData(jsonFile("mock_ad_response_no_placement")))

        // When
        let expectation = self.expectation(description: "Network request")
        dataSource.getAd(placementId: placementId, query: MockFactory.makeAdQueryInstance()) { result in
            self.adResult = result
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2.0, handler: nil)

        // Then
        expect(self.adResult?.isFailure).to(equal(true))
    }

    func test_validResponse_impressionCalled_returnsSuccess() {
        // Given
        stub(uri("/v2/impression"), jsonData(Data()))

        // When
        let expectation = self.expectation(description: "Network request")
        dataSource.impression(query: MockFactory.makeEventQueryInstance()) { result in
            self.eventResult = result
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2.0, handler: nil)

        // Then
        expect(self.eventResult?.isSuccess).to(equal(true))
    }

    func test_validResponse_clickCalled_returnsSuccess() {
        // Given
        stub(uri("/v2/click"), jsonData(Data()))

        // When
        let expectation = self.expectation(description: "Network request")
        dataSource.click(query: MockFactory.makeEventQueryInstance()) { result in
            self.eventResult = result
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2.0, handler: nil)

        // Then
        expect(self.eventResult?.isSuccess).to(equal(true))
    }

    func test_validResponse_videoClickCalled_returnsSuccess() {
        // Given
        stub(uri("/v2/video/click"), jsonData(Data()))

        // When
        let expectation = self.expectation(description: "Network request")
        dataSource.videoClick(query: MockFactory.makeEventQueryInstance()) { result in
            self.eventResult = result
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2.0, handler: nil)

        // Then
        expect(self.eventResult?.isSuccess).to(equal(true))
    }

    func test_validResponse_eventCalled_returnsSuccess() {
        // Given
        stub(uri("/v2/event"), jsonData(Data()))

        // When
        let expectation = self.expectation(description: "Network request")
        dataSource.event(query: MockFactory.makeEventQueryInstance()) { result in
            self.eventResult = result
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2.0, handler: nil)

        // Then
        expect(self.eventResult?.isSuccess).to(equal(true))
    }
}
