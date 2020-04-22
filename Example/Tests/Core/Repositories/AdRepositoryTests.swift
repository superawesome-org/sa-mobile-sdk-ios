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
    var result: NetworkResult<Ad>? = nil
    
    override func setUp() {
        super.setUp()
        result = nil
    }
    
    private func prepare(json:String, isSuccess: Bool) {
        // Given
        let placementId: Int = 1
        let request = AdRequest(environment: .staging, test: true, pos: 1,
                                skip: 1, playbackmethod: 1, startdelay: 1,
                                instl: 1, w: 1, h: 1)
        let mockProvider = MoyaProvider<AwesomeAdsTarget>()
        let mockQueryMaker = AdQueryMakerMock()
        let adRepository = AdRepository(mockProvider, adQueryMaker: mockQueryMaker)
        stub(uri("/v2/ad/\(placementId)"), jsonData(jsonFile(json)))

        // When
        let expectation = self.expectation(description: "request")
        
        adRepository.getAd(placementId: placementId, request: request) { result in
            self.result = result
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 2.0, handler: nil)
        
        // Then
        expect(self.result?.isSuccess).to(equal(isSuccess))
        expect(mockQueryMaker.isMakeCalled).to(equal(true))
    }
    
    func test_getAdCalled_validResponse_success() throws {
        prepare(json: "mock_ad_response_1", isSuccess: true)
    }
    
    func test_getAdCalled_invalidResponse_failure() throws {
        prepare(json: "mock_ad_response_no_placement", isSuccess: false)
    }
}
