//
//  AdRepositoryTests.swift
//  Tests
//
//  Created by Gunhan Sancar on 22/04/2020.
//

import XCTest
import Nimble
import Mockingjay
import Moya
@testable import SuperAwesome

class AdRepositoryTests: XCTestCase {
    var result: Result<Ad,Error>? = nil
    
    override func setUp() {
        super.setUp()
        result = nil
    }
    
    private func prepare(expectedResult: Result<Ad, Error>) {
        // Given
        let placementId: Int = 1
        let mockDataSource = AdDataSourceMock(expectedResult)
        let adRepository = AdRepository(mockDataSource)

        // When
        let expectation = self.expectation(description: "request")
        
        adRepository.getAd(placementId: placementId, request: makeAdRequest()) { result in
            self.result = result
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 2.0, handler: nil)
        
        // Then
        expect(self.result?.isSuccess).to(equal(expectedResult.isSuccess))
    }
    
    func test_getAdCalled_validResponse_success() throws {
        prepare(expectedResult: Result.success(makeAd()))
    }
    
    func test_getAdCalled_invalidResponse_failure() throws {
        prepare(expectedResult: Result.failure(makeError()))
    }
}
