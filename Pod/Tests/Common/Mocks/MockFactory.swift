//
//  AdMock.swift
//  Tests
//
//  Created by Gunhan Sancar on 24/04/2020.
//

@testable import SuperAwesome

class MockFactory {

    static func makeAdWithTagAndClickUrl(_ tag: String?, _ url: String?) -> Ad {
        makeAd(.tag, nil, url, tag)
    }

    static func makeAdWithImageLink(_ url: String?) -> Ad {
        makeAd(.image_with_link, nil, url)
    }

    static func makeAd(
        _ format: CreativeFormatType = .image_with_link,
        _ vast: String? = nil,
        _ clickUrl: String? = nil,
        _ tag: String? = nil
    ) -> Ad {
        Ad(advertiserId: 10,
           publisherId: 20,
           moat: 0.1,
           is_fill: true,
           is_fallback: false,
           campaign_id: 30,
           campaign_type: 40,
           is_house: true,
           safe_ad_approved: true,
           show_padlock: false,
           line_item_id: 50,
           test: false,
           app: 70,
           device: "device",
           creative: Creative(
            id: 80,
            name: "name",
            format: format,
            click_url: clickUrl,
            details: CreativeDetail(
                url: "detailurl",
                image: "image",
                video: "video",
                placement_format: "placement",
                tag: tag,
                width: 90,
                height: 100,
                duration: 110,
                vast: vast),
            bumper: true))
    }

    static func makeError() -> Error { NSError(domain: "", code: 404, userInfo: nil) }

    static func makeAdRequest() -> AdRequest {
        AdRequest(
            test: false,
            pos: .aboveTheFold,
            skip: .no,
            playbackmethod: 10,
            startdelay: .genericMidRoll,
            instl: .off,
            w: 25,
            h: 35)
    }

    static func makeAdQueryInstance() -> AdQuery {
        AdQuery(
            test: true,
            sdkVersion: "",
            rnd: 1,
            bundle: "",
            name: "",
            dauid: 1,
            ct: .wifi,
            lang: "",
            device: "",
            pos: 1,
            skip: 1,
            playbackmethod: 1,
            startdelay: 1,
            instl: 1,
            w: 1,
            h: 1)
    }

    static func makeEventQueryInstance() -> EventQuery {
        EventQuery(
            placement: 1,
            bundle: "",
            creative: 1,
            line_item: 1,
            ct: .wifi,
            sdkVersion: "",
            rnd: 1,
            type: nil,
            no_image: nil,
            data: nil)
    }

    static func makeAdResponse() -> AdResponse {
        AdResponse(10, makeAd())
    }
}
