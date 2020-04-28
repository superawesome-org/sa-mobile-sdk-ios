//
//  AdMock.swift
//  Tests
//
//  Created by Gunhan Sancar on 24/04/2020.
//

@testable import SuperAwesome

func makeAd() -> Ad {
    Ad(advertiserId: 1, publisherId: 1,
    moat: 1, is_fill: true, is_fallback: true, campaign_type: 1, is_house: true,
    safe_ad_approved: true, show_padlock: true, line_item_id: 1, test: true, app: 1, device: "",
    creative: Creative(id: 1,
                       name: "", format: .image_with_link, click_url: "",
                       details: CreativeDetail(url: "", image: "", video: "", placement_format: "",
                                               tag: "", width: 1, height: 1,
                                               transcodedVideos: "", duration: 1, vast: "")))
}

func makeError() -> Error { NSError(domain:"", code:404, userInfo:nil) }

func makeAdRequest() -> AdRequest { AdRequest(environment: .staging, test: true, pos: 1, skip: 1,
                                              playbackmethod: 1, startdelay: 1,instl: 1, w: 1, h: 1) }

func makeAdQuery() -> AdQuery { AdQuery(test: true, sdkVersion: "", rnd: 1, bundle: "",
name: "", dauid: 1, ct: .wifi, lang: "", device: "",
pos: 1, skip: 1, playbackmethod: 1, startdelay: 1, instl: 1, w: 1, h: 1) }
