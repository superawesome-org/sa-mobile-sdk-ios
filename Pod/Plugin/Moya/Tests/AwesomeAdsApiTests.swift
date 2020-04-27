//
//  AwesomeAdsApiTests.swift
//  Tests
//
//  Created by Gunhan Sancar on 16/04/2020.
//

import XCTest
import Nimble
import Moya
import Mockingjay
@testable import SuperAwesome

class AwesomeAdsApiTests: XCTestCase {
    private var provider: MoyaProvider<AwesomeAdsTarget>!
    private var ad: Ad? = nil
    private var error: Error?  = nil
    
    override func setUp() {
        super.setUp()
        provider = MoyaProvider<AwesomeAdsTarget>(plugins:[NetworkLoggerPlugin()])
        ad = nil
        error = nil
    }
    
    private func prepareResponse(json: String) {
        // Given
        let placementId: Int = 1
        
        stub(uri("/v2/ad/\(placementId)"), jsonData(jsonFile(json)))
        
        let expectation = self.expectation(description: "Network request")
        
        // When
        provider.request(AwesomeAdsTarget(.production,
                                          .ad(placementId: placementId, query: makeAdQuery()))) { result in
            switch result {
            case .success(let response):
                do {
                    let filteredResponse = try response.filterSuccessfulStatusCodes()
                    self.ad = try filteredResponse.map(Ad.self) }
                catch let error { self.error = error }
            case .failure(let error): self.error = NSError(domain:"", code:error.errorCode, userInfo:nil)
            }
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 2.0, handler: nil)
    }

    func test_mock_ad_response_1() throws {
        // Given
        prepareResponse(json: "mock_ad_response_1")
        
        // Then
        expect(self.ad).toNot(beNil())
        expect(self.error).to(beNil())
        let ad = self.ad!
        expect(ad.advertiserId).to(equal(1))
        expect(ad.publisherId).to(equal(1))
        expect(ad.moat).to(equal(0.2))
        expect(ad.is_fill).to(equal(false))
        expect(ad.is_fallback).to(equal(false))
        expect(ad.campaign_type).to(equal(0))
        expect(ad.is_house).to(equal(false))
        expect(ad.safe_ad_approved).to(equal(true))
        expect(ad.show_padlock).to(equal(true))
        expect(ad.line_item_id).to(equal(931))
        expect(ad.test).to(equal(false))
        expect(ad.app).to(equal(1484))
        expect(ad.device).to(equal("web"))
        expect(ad.creative.click_url).to(equal("https://superawesome.tv"))
        expect(ad.creative.details.duration).to(equal(32))
        expect(ad.creative.details.height).to(equal(480))
        expect(ad.creative.details.image).to(equal("https://s3-eu-west-1.amazonaws.com/sb-ads-video-transcoded/Jnit8s0LdkbOKbx6q6qn4A4jqMid2T4I.mp4"))
        expect(ad.creative.details.placement_format).to(equal("video"))
        expect(ad.creative.details.tag).to(beNil())
        expect(ad.creative.details.transcodedVideos).to(beNil())
        expect(ad.creative.details.url).to(equal("https://s3-eu-west-1.amazonaws.com/sb-ads-video-transcoded/Jnit8s0LdkbOKbx6q6qn4A4jqMid2T4I.mp4"))
        expect(ad.creative.details.vast).to(equal("https://ads.staging.superawesome.tv/v2/video/vast/480/931/4906/?sdkVersion=unknown&rnd=434251983&device=web"))
        expect(ad.creative.details.video).to(equal("https://s3-eu-west-1.amazonaws.com/sb-ads-video-transcoded/Jnit8s0LdkbOKbx6q6qn4A4jqMid2T4I.mp4"))
        expect(ad.creative.details.width).to(equal(600))
        expect(ad.creative.format).to(equal(.video))
        expect(ad.creative.id).to(equal(4906))
        expect(ad.creative.name).to(beNil())
    }
    
    func test_mock_ad_response_2() throws {
        // Given
        prepareResponse(json: "mock_ad_response_2")
        
        // Then
        expect(self.ad).toNot(beNil())
        expect(self.error).to(beNil())
        let ad = self.ad!
        expect(ad.advertiserId).to(equal(1))
        expect(ad.publisherId).to(equal(1))
        expect(ad.moat).to(equal(0.2))
        expect(ad.is_fill).to(equal(false))
        expect(ad.is_fallback).to(equal(false))
        expect(ad.campaign_type).to(equal(0))
        expect(ad.is_house).to(equal(false))
        expect(ad.safe_ad_approved).to(equal(true))
        expect(ad.show_padlock).to(equal(true))
        expect(ad.line_item_id).to(equal(138))
        expect(ad.test).to(equal(false))
        expect(ad.app).to(equal(105))
        expect(ad.device).to(equal("web"))
        expect(ad.creative.click_url).to(equal("http://superawesome.tv"))
        expect(ad.creative.details.duration).to(equal(0))
        expect(ad.creative.details.height).to(equal(50))
        expect(ad.creative.details.placement_format).to(equal("mobile_display"))
        expect(ad.creative.details.tag).to(beNil())
        expect(ad.creative.details.transcodedVideos).to(beNil())
        expect(ad.creative.details.url).to(equal("https://s3-eu-west-1.amazonaws.com/sb-ads-uploads/images/cvWABPEIS7vUEtlv5U17MwaTNhRARYjB.png"))
        expect(ad.creative.details.image).to(equal("https://s3-eu-west-1.amazonaws.com/sb-ads-uploads/images/cvWABPEIS7vUEtlv5U17MwaTNhRARYjB.png"))
        expect(ad.creative.details.video).to(equal("https://s3-eu-west-1.amazonaws.com/sb-ads-uploads/images/cvWABPEIS7vUEtlv5U17MwaTNhRARYjB.png"))
        expect(ad.creative.details.vast).to(beNil())
        expect(ad.creative.details.width).to(equal(320))
        expect(ad.creative.format).to(equal(.image_with_link))
        expect(ad.creative.id).to(equal(114))
        expect(ad.creative.name).to(equal("Banner 1"))
    }
    
    func test_mock_ad_response_no_placement() throws {
        // Given
        prepareResponse(json: "mock_ad_response_no_placement")
        
        // Then
        expect(self.ad).to(beNil())
        expect(self.error).toNot(beNil())
    }
    
    func test_mock_ad_malformed_response() throws {
        // Given
        prepareResponse(json: "mock_ad_malformed_response")
        
        // Then
        expect(self.ad).to(beNil())
        expect(self.error).toNot(beNil())
    }
    
}
