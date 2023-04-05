//
//  AdRepositoryTests.swift
//  Tests
//
//  Created by Gunhan Sancar on 22/04/2020.
//

import XCTest
import Nimble

@testable import SuperAwesome

class AdRepositoryTests: XCTestCase {

    private let mockDataSource = AdDataSourceMock()
    private let mockAdQueryMaker = AdQueryMakerMock()
    private let mockAdProcessor = AdProcessorMock()
    private lazy var adRepository = AdRepository(
        dataSource: mockDataSource,
        adQueryMaker: mockAdQueryMaker,
        adProcessor: mockAdProcessor
    )

    private var result: Result<AdResponse, Error>?

    override func setUp() {
        super.setUp()
        result = nil
    }

    private func prepareWithSingleId(expectedResult: Result<Ad, Error>) {
        // Given
        let placementId: Int = 1
        mockDataSource.mockAdResult = expectedResult

        // When
        let expectation = self.expectation(description: "request")

        adRepository.getAd(placementId: placementId, request: MockFactory.makeAdRequest()) { [weak self] result in
            self?.result = result
            expectation.fulfill()
        }

        waitForExpectations(timeout: 2.0, handler: nil)

        // Then
        expect(self.result?.isSuccess).to(equal(expectedResult.isSuccess))
    }

    private func prepareWithMultiId(expectedResult: Result<Ad, Error>) {
        // Given
        let placementId: Int = 1
        let lineItemId: Int = 2
        let creativeId: Int = 3
        mockDataSource.mockAdResult = expectedResult

        // When
        let expectation = self.expectation(description: "request")

        adRepository.getAd(
            placementId: placementId,
            lineItemId: lineItemId,
            creativeId: creativeId,
            request: MockFactory.makeAdRequest()) { [weak self] result in
                self?.result = result
                expectation.fulfill()
            }

        waitForExpectations(timeout: 2.0, handler: nil)

        // Then
        expect(self.result?.isSuccess).to(equal(expectedResult.isSuccess))
    }

    func test_getAdCalled_validResponse_success() throws {
        prepareWithSingleId(expectedResult: Result.success(MockFactory.makeAd()))
    }

    func test_getAdCalled_invalidResponse_failure() throws {
        prepareWithSingleId(expectedResult: Result.failure(MockFactory.makeError()))
    }

    func test_getAdWithMultiIdCalled_validResponse_success() throws {
        prepareWithMultiId(expectedResult: Result.success(MockFactory.makeAd()))
    }

    func test_getAdWithMultiIdCalled_invalidResponse_failure() throws {
        prepareWithMultiId(expectedResult: Result.failure(MockFactory.makeError()))
    }
}
