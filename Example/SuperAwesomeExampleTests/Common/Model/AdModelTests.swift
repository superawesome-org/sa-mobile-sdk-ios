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
            placementFormat: "image",
            tag: nil,
            width: 400,
            height: 150,
            duration: 0,
            vast: nil)
        let creative = Creative(
            id: 2000,
            name: "test",
            format: CreativeFormatType.video,
            clickUrl: "http://test.com",
            details: details,
            bumper: false,
            payload: nil)
        let ad = Ad(
            advertiserId: 1000,
            publisherId: 1000,
            moat: false,
            isFill: false,
            isFallback: false,
            campaignId: 0,
            campaignType: 1,
            isHouse: false,
            safeAdApproved: true,
            showPadlock: true,
            lineItemId: 2000,
            test: true,
            app: 1000,
            device: "abc",
            creative: creative,
            ksfRequest: nil)
        let response = AdResponse(3000, ad)

        // when
        let result = response.aspectRatio()

        // then
        expect(result).to(equal(2.6666666666666665))
    }
}
