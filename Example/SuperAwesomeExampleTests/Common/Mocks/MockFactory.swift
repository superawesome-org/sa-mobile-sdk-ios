//
//  AdMock.swift
//  Tests
//
//  Created by Gunhan Sancar on 24/04/2020.
//

@testable import SuperAwesome

class MockFactory {

    static func makeAdWithTagAndClickUrl(_ tag: String?, _ url: String?) -> Ad {
        makeAd(format: .tag, vast: nil, clickUrl: url, tag: tag)
    }

    static func makeAdWithImageLink(_ url: String?) -> Ad {
        makeAd(format: .imageWithLink, vast: nil, clickUrl: url)
    }

    static func makeAd(
        format: CreativeFormatType = .imageWithLink,
        vast: String? = nil,
        clickUrl: String? = nil,
        tag: String? = nil,
        showPadlock: Bool = false,
        ksfRequest: String? = nil,
        bumper: Bool = true,
        isVpaid: Bool = false
    ) -> Ad {
        Ad(
           isVpaid: isVpaid,
           showPadlock: showPadlock,
           lineItemId: 50,
           test: false,
           creative: Creative(
            id: 80,
            name: "name",
            format: format,
            clickUrl: clickUrl,
            details: CreativeDetail(
                url: "detailurl",
                image: "image",
                video: "video",
                placementFormat: "placement",
                tag: tag,
                width: 90,
                height: 100,
                vast: vast),
            bumper: bumper,
            payload: nil),
           ksfRequest: ksfRequest)
    }

    static func makeError() -> Error { NSError(domain: "", code: 404, userInfo: nil) }

    static func makeAdRequest() -> AdRequest {
        AdRequest(test: false,
                  position: .aboveTheFold,
                  skip: .no,
                  playbackMethod: 0,
                  startDelay: AdRequest.StartDelay.midRoll,
                  instl: .off,
                  width: 25,
                  height: 35,
                  options: nil)
    }

    static func makeAdQueryInstance() -> QueryBundle {
        QueryBundle(parameters: AdQuery(
            test: true,
            sdkVersion: "",
            random: 1,
            bundle: "",
            name: "",
            dauid: 1,
            connectionType: .wifi,
            lang: "",
            device: "",
            position: 1,
            skip: 1,
            playbackMethod: 1,
            startDelay: 1,
            instl: 1,
            width: 1,
            height: 1),
                    options: nil)

    }

    static func makeEventQueryInstance() -> QueryBundle {
        QueryBundle(parameters: EventQuery(
            placement: 1,
            bundle: "",
            creative: 1,
            lineItem: 1,
            connectionType: .wifi,
            sdkVersion: "",
            rnd: 1,
            type: nil,
            noImage: nil,
            data: nil),
                    options: nil)
    }

    static func makeAdResponse() -> AdResponse {
        AdResponse(10, makeAd(), nil)
    }

    static func makeVastAd(clickThrough: String? = nil) -> VastAd {
        VastAd(url: nil,
               type: .inLine,
               redirect: nil,
               errorEvents: [],
               impressions: [],
               clickThrough: clickThrough,
               creativeViewEvents: [],
               startEvents: [],
               firstQuartileEvents: [],
               midPointEvents: [],
               thirdQuartileEvents: [],
               completeEvents: [],
               clickTrackingEvents: [],
               media: [])
    }
}
