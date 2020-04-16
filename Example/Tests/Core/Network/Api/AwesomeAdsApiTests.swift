//
//  AwesomeAdsApiTests.swift
//  Tests
//
//  Created by Gunhan Sancar on 16/04/2020.
//  Copyright © 2020 Gabriel Coman. All rights reserved.
//

import XCTest
import Nimble
import Moya
import Mockingjay
@testable import SuperAwesome

class AwesomeAdsApiTests: XCTestCase {
    var provider: MoyaProvider<AwesomeAdsTarget>!
    var ad: Ad? = nil
    
    override func setUp() {
        super.setUp()
        provider = MoyaProvider<AwesomeAdsTarget>(plugins:[NetworkLoggerPlugin()])
        ad = nil
    }

    func testRequestAd() throws {
        // Given
        let placementId = 1
        let request = AdRequest(test: true, sdkVersion: "", rnd: 1, bundle: "", name: "", dauid: 1, ct: 1, lang: "",
                                device: "", pos: 1, skip: 1, playbackmethod: 1, startdelay: 1, instl: 1, w: 1, h: 1)
    
        stub(uri("/v2/ad/\(placementId)"), jsonData(jsonFile("mock_ad_response_1")))
        
        let expectation = self.expectation(description: "Network request")

        // When
        provider.request(AwesomeAdsTarget(.production, .ad(placementId: placementId, request: request))) { result in
            switch result {
            case .success(let response):
                do { self.ad = try response.map(Ad.self) } catch { }
                break
            case .failure(_): break
            }
            expectation.fulfill()
        }
        waitForExpectations(timeout: 5, handler: nil)
        
        // Then
        let ad = self.ad!
        expect(ad.advertiserId).to(equal(1))
    }
}
