//
//  AdModelTests.swift
//  SuperAwesome-Unit-Full-Tests
//
//  Created by Gabriel Coman on 15/12/2020.
//

import XCTest
import Nimble
@testable import SuperAwesome

class AdModelTests: XCTestCase {
    
    func test_AdResponse_aspectRatio() {
        // given
        let details = CreativeDetail(
            url: "http://test.com",
            image: "http://test.com/image.png",
            video: "",
            placement_format: "image",
            tag: nil,
            width: 400,
            height: 150,
            duration: 0,
            vast: nil)
        let creative = Creative(
            id: 2000,
            name: "test",
            format: CreativeFormatType.video,
            click_url: "http://test.com",
            details: details,
            bumper: false)
        let ad = Ad(
            advertiserId: 1000,
            publisherId: 1000,
            moat: false,
            is_fill: false,
            is_fallback: false,
            campaign_id: 0,
            campaign_type: 1,
            is_house: false,
            safe_ad_approved: true,
            show_padlock: true,
            line_item_id: 2000,
            test: true,
            app: 1000,
            device: "abc",
            creative: creative)
        let response = AdResponse(3000, ad)
        
        // when
        let result = response.aspectRatio()
        
        // then
        expect(result).to(equal(2.6666666666666665))
    }
}
