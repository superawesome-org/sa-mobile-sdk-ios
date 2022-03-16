//
//  NativeVastPasserTests.swift
//  SuperAwesome-Unit-Full-Tests
//
//  Created by Mark on 09/06/2021.
//

import XCTest
import Nimble
@testable import SuperAwesome

class VastParserTests: XCTestCase {

    func test_merge_vastAds() throws {
        // Given
        let vastAd1 = VastAd(url: "url1", type: .inLine, redirect: nil, startEvents: ["", ""], media: [VastMedia(), VastMedia()])
        let vastAd2 = VastAd(url: "url2", type: .wrapper, startEvents: [""], media: [VastMedia()])

        // When
        let merged = vastAd1.merge(from: vastAd2)

        // Then
        expect(merged.url).to(equal("url2"))
        expect(merged.startEvents.count).to(equal(3))
        expect(merged.media.count).to(equal(3))
    }

    func test_parse_response_sample() throws {
        // Given
        let parser = VastParser(connectionProvider: ConnectionProviderMock())

        // When
        let vast = parser.parse(xmlFile("sample"))

        // Then
        expect(vast?.url).to(equal("https://video-transcoded-api-main-awesomeads.sacdn.net/MB7k7pTym4lGaqt3wd167TLCOMg6Lh4P.mp4"))
        expect(vast?.errorEvents).to(equal(["https://eu-west-1-ads.superawesome.tv/v2/video/error?placement=44262&creative=345867&line_item=74792&sdkVersion=ios_8.0.7&rnd=58472dfc-df49-4299-899a-ea004efe317f&dauid=326997549390609966&device=phone&bundle=tv.superawesome.awesomeads.sdk&ct=2&lang=en_US&country=GB&region=ENG&flow=normal&ua=SuperAwesomeExample%2F1.0%20(tv.superawesome.awesomeads.sdk%3B%20build%3A2%3B%20iOS%2014.5.0)%20Alamofire%2F5.4.3&aua=eyJhbGciOiJIUzI1NiJ9.TW96aWxsYS81LjAgKGlQaG9uZTsgQ1BVIGlQaG9uZSBPUyAxM181XzEgbGlrZSBNYWMgT1MgWCkgQXBwbGVXZWJLaXQvNjA1LjEuMTUgKEtIVE1MLCBsaWtlIEdlY2tvKSBWZXJzaW9uLzEzLjEgTW9iaWxlLzE1RTE0OCBTYWZhcmkvNjA0LjE.4BfJdabo9HtuqgyAOcE3uqHJbhq4FDACJX-Fh1MQdJY&tip=eyJhbGciOiJIUzI1NiJ9.MTM0LjE5LjE5Mi4w.JajWr5M0WbD9_90UR8MzKE4sb4XP_kqk0rKhIwBRtxs&code=[ERRORCODE]"]))
        expect(vast?.impressionEvents.first).to(equal("https://eu-west-1-ads.superawesome.tv/v2/video/impression?placement=44262&creative=345867&line_item=74792&sdkVersion=ios_8.0.7&rnd=58472dfc-df49-4299-899a-ea004efe317f&dauid=326997549390609966&device=phone&bundle=tv.superawesome.awesomeads.sdk&ct=2&lang=en_US&country=GB&region=ENG&flow=normal&ua=SuperAwesomeExample%2F1.0%20(tv.superawesome.awesomeads.sdk%3B%20build%3A2%3B%20iOS%2014.5.0)%20Alamofire%2F5.4.3&aua=eyJhbGciOiJIUzI1NiJ9.TW96aWxsYS81LjAgKGlQaG9uZTsgQ1BVIGlQaG9uZSBPUyAxM181XzEgbGlrZSBNYWMgT1MgWCkgQXBwbGVXZWJLaXQvNjA1LjEuMTUgKEtIVE1MLCBsaWtlIEdlY2tvKSBWZXJzaW9uLzEzLjEgTW9iaWxlLzE1RTE0OCBTYWZhcmkvNjA0LjE.4BfJdabo9HtuqgyAOcE3uqHJbhq4FDACJX-Fh1MQdJY&tip=eyJhbGciOiJIUzI1NiJ9.MTM0LjE5LjE5Mi4w.JajWr5M0WbD9_90UR8MzKE4sb4XP_kqk0rKhIwBRtxs"))
        expect(vast?.clickThroughUrl).to(equal("https://eu-west-1-ads.superawesome.tv/v2/video/click?placement=44262&creative=345867&line_item=74792&sdkVersion=ios_8.0.7&rnd=58472dfc-df49-4299-899a-ea004efe317f&dauid=326997549390609966&device=phone&bundle=tv.superawesome.awesomeads.sdk&ct=2&lang=en_US&country=GB&region=ENG&flow=normal&ua=SuperAwesomeExample%2F1.0%20(tv.superawesome.awesomeads.sdk%3B%20build%3A2%3B%20iOS%2014.5.0)%20Alamofire%2F5.4.3&aua=eyJhbGciOiJIUzI1NiJ9.TW96aWxsYS81LjAgKGlQaG9uZTsgQ1BVIGlQaG9uZSBPUyAxM181XzEgbGlrZSBNYWMgT1MgWCkgQXBwbGVXZWJLaXQvNjA1LjEuMTUgKEtIVE1MLCBsaWtlIEdlY2tvKSBWZXJzaW9uLzEzLjEgTW9iaWxlLzE1RTE0OCBTYWZhcmkvNjA0LjE.4BfJdabo9HtuqgyAOcE3uqHJbhq4FDACJX-Fh1MQdJY&tip=eyJhbGciOiJIUzI1NiJ9.MTM0LjE5LjE5Mi4w.JajWr5M0WbD9_90UR8MzKE4sb4XP_kqk0rKhIwBRtxs"))
        expect(vast?.redirect).to(beNil())
        expect(vast?.type).to(equal(.inLine))
        //expect(vast?.media.first).to(equal(
        //VastMedia(type: "video/mp4", url: "https://video-transcoded-api-main-awesomeads.sacdn.net/MB7k7pTym4lGaqt3wd167TLCOMg6Lh4P-low.mp4", bitrate: 360, width: 600, height: 480)))
        expect(vast?.media.count).to(equal(3))
        expect(vast?.creativeViewEvents).to(equal(["https://eu-west-1-ads.superawesome.tv/v2/video/tracking?event=creativeView&placement=44262&creative=345867&line_item=74792&sdkVersion=ios_8.0.7&rnd=58472dfc-df49-4299-899a-ea004efe317f&dauid=326997549390609966&device=phone&bundle=tv.superawesome.awesomeads.sdk&ct=2&lang=en_US&country=GB&region=ENG&flow=normal&ua=SuperAwesomeExample%2F1.0%20(tv.superawesome.awesomeads.sdk%3B%20build%3A2%3B%20iOS%2014.5.0)%20Alamofire%2F5.4.3&aua=eyJhbGciOiJIUzI1NiJ9.TW96aWxsYS81LjAgKGlQaG9uZTsgQ1BVIGlQaG9uZSBPUyAxM181XzEgbGlrZSBNYWMgT1MgWCkgQXBwbGVXZWJLaXQvNjA1LjEuMTUgKEtIVE1MLCBsaWtlIEdlY2tvKSBWZXJzaW9uLzEzLjEgTW9iaWxlLzE1RTE0OCBTYWZhcmkvNjA0LjE.4BfJdabo9HtuqgyAOcE3uqHJbhq4FDACJX-Fh1MQdJY&tip=eyJhbGciOiJIUzI1NiJ9.MTM0LjE5LjE5Mi4w.JajWr5M0WbD9_90UR8MzKE4sb4XP_kqk0rKhIwBRtxs"]))
        expect(vast?.startEvents).to(equal(["https://eu-west-1-ads.superawesome.tv/v2/video/tracking?event=start&placement=44262&creative=345867&line_item=74792&sdkVersion=ios_8.0.7&rnd=58472dfc-df49-4299-899a-ea004efe317f&dauid=326997549390609966&device=phone&bundle=tv.superawesome.awesomeads.sdk&ct=2&lang=en_US&country=GB&region=ENG&flow=normal&ua=SuperAwesomeExample%2F1.0%20(tv.superawesome.awesomeads.sdk%3B%20build%3A2%3B%20iOS%2014.5.0)%20Alamofire%2F5.4.3&aua=eyJhbGciOiJIUzI1NiJ9.TW96aWxsYS81LjAgKGlQaG9uZTsgQ1BVIGlQaG9uZSBPUyAxM181XzEgbGlrZSBNYWMgT1MgWCkgQXBwbGVXZWJLaXQvNjA1LjEuMTUgKEtIVE1MLCBsaWtlIEdlY2tvKSBWZXJzaW9uLzEzLjEgTW9iaWxlLzE1RTE0OCBTYWZhcmkvNjA0LjE.4BfJdabo9HtuqgyAOcE3uqHJbhq4FDACJX-Fh1MQdJY&tip=eyJhbGciOiJIUzI1NiJ9.MTM0LjE5LjE5Mi4w.JajWr5M0WbD9_90UR8MzKE4sb4XP_kqk0rKhIwBRtxs"]))
        expect( vast?.firstQuartileEvents).to(equal([
            "https://eu-west-1-ads.superawesome.tv/v2/video/tracking?event=firstQuartile&placement=44262&creative=345867&line_item=74792&sdkVersion=ios_8.0.7&rnd=58472dfc-df49-4299-899a-ea004efe317f&dauid=326997549390609966&device=phone&bundle=tv.superawesome.awesomeads.sdk&ct=2&lang=en_US&country=GB&region=ENG&flow=normal&ua=SuperAwesomeExample%2F1.0%20(tv.superawesome.awesomeads.sdk%3B%20build%3A2%3B%20iOS%2014.5.0)%20Alamofire%2F5.4.3&aua=eyJhbGciOiJIUzI1NiJ9.TW96aWxsYS81LjAgKGlQaG9uZTsgQ1BVIGlQaG9uZSBPUyAxM181XzEgbGlrZSBNYWMgT1MgWCkgQXBwbGVXZWJLaXQvNjA1LjEuMTUgKEtIVE1MLCBsaWtlIEdlY2tvKSBWZXJzaW9uLzEzLjEgTW9iaWxlLzE1RTE0OCBTYWZhcmkvNjA0LjE.4BfJdabo9HtuqgyAOcE3uqHJbhq4FDACJX-Fh1MQdJY&tip=eyJhbGciOiJIUzI1NiJ9.MTM0LjE5LjE5Mi4w.JajWr5M0WbD9_90UR8MzKE4sb4XP_kqk0rKhIwBRtxs"
        ]))
        expect( vast?.midPointEvents).to(equal([ "https://eu-west-1-ads.superawesome.tv/v2/video/tracking?event=midpoint&placement=44262&creative=345867&line_item=74792&sdkVersion=ios_8.0.7&rnd=58472dfc-df49-4299-899a-ea004efe317f&dauid=326997549390609966&device=phone&bundle=tv.superawesome.awesomeads.sdk&ct=2&lang=en_US&country=GB&region=ENG&flow=normal&ua=SuperAwesomeExample%2F1.0%20(tv.superawesome.awesomeads.sdk%3B%20build%3A2%3B%20iOS%2014.5.0)%20Alamofire%2F5.4.3&aua=eyJhbGciOiJIUzI1NiJ9.TW96aWxsYS81LjAgKGlQaG9uZTsgQ1BVIGlQaG9uZSBPUyAxM181XzEgbGlrZSBNYWMgT1MgWCkgQXBwbGVXZWJLaXQvNjA1LjEuMTUgKEtIVE1MLCBsaWtlIEdlY2tvKSBWZXJzaW9uLzEzLjEgTW9iaWxlLzE1RTE0OCBTYWZhcmkvNjA0LjE.4BfJdabo9HtuqgyAOcE3uqHJbhq4FDACJX-Fh1MQdJY&tip=eyJhbGciOiJIUzI1NiJ9.MTM0LjE5LjE5Mi4w.JajWr5M0WbD9_90UR8MzKE4sb4XP_kqk0rKhIwBRtxs"]))

        expect( vast?.thirdQuartileEvents).to(equal([ "https://eu-west-1-ads.superawesome.tv/v2/video/tracking?event=thirdQuartile&placement=44262&creative=345867&line_item=74792&sdkVersion=ios_8.0.7&rnd=58472dfc-df49-4299-899a-ea004efe317f&dauid=326997549390609966&device=phone&bundle=tv.superawesome.awesomeads.sdk&ct=2&lang=en_US&country=GB&region=ENG&flow=normal&ua=SuperAwesomeExample%2F1.0%20(tv.superawesome.awesomeads.sdk%3B%20build%3A2%3B%20iOS%2014.5.0)%20Alamofire%2F5.4.3&aua=eyJhbGciOiJIUzI1NiJ9.TW96aWxsYS81LjAgKGlQaG9uZTsgQ1BVIGlQaG9uZSBPUyAxM181XzEgbGlrZSBNYWMgT1MgWCkgQXBwbGVXZWJLaXQvNjA1LjEuMTUgKEtIVE1MLCBsaWtlIEdlY2tvKSBWZXJzaW9uLzEzLjEgTW9iaWxlLzE1RTE0OCBTYWZhcmkvNjA0LjE.4BfJdabo9HtuqgyAOcE3uqHJbhq4FDACJX-Fh1MQdJY&tip=eyJhbGciOiJIUzI1NiJ9.MTM0LjE5LjE5Mi4w.JajWr5M0WbD9_90UR8MzKE4sb4XP_kqk0rKhIwBRtxs"]))

        expect(  vast?.completeEvents          ).to(equal(["https://eu-west-1-ads.superawesome.tv/v2/video/tracking?event=complete&placement=44262&creative=345867&line_item=74792&sdkVersion=ios_8.0.7&rnd=58472dfc-df49-4299-899a-ea004efe317f&dauid=326997549390609966&device=phone&bundle=tv.superawesome.awesomeads.sdk&ct=2&lang=en_US&country=GB&region=ENG&flow=normal&ua=SuperAwesomeExample%2F1.0%20(tv.superawesome.awesomeads.sdk%3B%20build%3A2%3B%20iOS%2014.5.0)%20Alamofire%2F5.4.3&aua=eyJhbGciOiJIUzI1NiJ9.TW96aWxsYS81LjAgKGlQaG9uZTsgQ1BVIGlQaG9uZSBPUyAxM181XzEgbGlrZSBNYWMgT1MgWCkgQXBwbGVXZWJLaXQvNjA1LjEuMTUgKEtIVE1MLCBsaWtlIEdlY2tvKSBWZXJzaW9uLzEzLjEgTW9iaWxlLzE1RTE0OCBTYWZhcmkvNjA0LjE.4BfJdabo9HtuqgyAOcE3uqHJbhq4FDACJX-Fh1MQdJY&tip=eyJhbGciOiJIUzI1NiJ9.MTM0LjE5LjE5Mi4w.JajWr5M0WbD9_90UR8MzKE4sb4XP_kqk0rKhIwBRtxs"]))

        expect(vast?.clickTrackingEvents).to(equal([]))
    }

    func test_parse_response1() throws {
        // Given
        let parser = VastParser(connectionProvider: ConnectionProviderMock())

        // When
        let vast = parser.parse(xmlFile("mock_vast_response_2.1"))

        // Then
        expect(vast?.url).to(equal("https://ads.superawesome.tv/v2/demo_images/video.mp4"))
        expect(vast?.errorEvents).to(equal(["https://pubads.g.doubleclick.net/pagead/conversion/?ai=B4fABspJ4WI7IIOfQxgLToLbAC_jXj-sGAAAAEAEgqN27JjgAWPDXgsbXAWC7vq6D0Aq6AQo3Mjh4OTBfeG1syAEFwAIC4AIA6gIjLzEyNDMxOTA5Ni9leHRlcm5hbC91dGlsaXR5X3NhbXBsZXP4AvfRHoADAZAD0AWYA_ABqAMB4AQB0gUGEKCr9NICkAYBoAYj2AcB4AcK&amp;sigh=US9RxyYaTkY&amp;label=videoplayfailed"]))
        expect(vast?.impressionEvents.first).to(equal("https://securepubads.g.doubleclick.net/pcs/view?xai=AKAOjsvu_KHi7FozgcUQ_KvpFfESzUfUOI0AMJfAs8hGlPO7fYz7ABNEy2ZPY4yqxPbz-xQUIgQsi3DBAP0rXWP6SR8bbrwP6hYHWzhMJwFnyb76dMwn4-K_USe_6yhy9CXJeJcEvl0t3bdJi5veWgiE-gJ4JSBl4fidhOC9VjIT09aCaptXTdUWE0P5JRAFVdJBccg11lB5T7X3OyROZPF0AUSQyjoEQ5jb6Orhuu_MlyI&amp;sig=Cg0ArKJSzD8mjjRQaKzgEAE&amp;adurl="))
        expect(vast?.clickThroughUrl).to(equal("https://pubads.g.doubleclick.net/pcs/click?xai=AKAOjsspolSuXa7AwEbPP7AZ-GxS21aUHa9uiCLztqPfZWzuDeBfP6YjdyprsdOp9BCHCEQDZh-gcCZA79vQnFj_eY7nSvD1ARORC5Ve2bofK1CxuU66k0XPX5mrHChaKn7VQi-iXxuiIuxa_-su7JuWpij9jBopE8WvoPTNgIl6HzfKpqSL7gsWXyCBy_j34zeywTjbPByh4Zp43QMKohRxs-sXRgPi7zoJZIoT&amp;sig=Cg0ArKJSzEfYCW3PG__E&amp;adurl=https://developers.google.com/interactive-media-ads/docs/vastinspector_dual"))
        expect(vast?.redirect).to(beNil())
        expect(vast?.type).to(equal(.inLine))
        //expect(vast?.media.first).to(equal(
        //VastMedia(type: "video/mp4", url: "https://ads.superawesome.tv/v2/demo_images/video.mp4", bitrate: 524, width: 1280, height: 720)))
        expect(vast?.media.count).to(equal(3))
//        expect(vast?.creativeViewEvents).to(equal(["https://pubads.g.doubleclick.net/pagead/conversion/?ai=B4fABspJ4WI7IIOfQxgLToLbAC_jXj-sGAAAAEAEgqN27JjgAWPDXgsbXAWC7vq6D0Aq6AQo3Mjh4OTBfeG1syAEFwAIC4AIA6gIjLzEyNDMxOTA5Ni9leHRlcm5hbC91dGlsaXR5X3NhbXBsZXP4AvfRHoADAZAD0AWYA_ABqAMB4AQB0gUGEKCr9NICkAYBoAYj2AcB4AcK&amp;sigh=US9RxyYaTkY&amp;label=vast_creativeview&amp;ad_mt=[AD_MT]", "https://securepubads.g.doubleclick.net/pcs/view?xai=AKAOjsvTB5ol1x1lM64QbnRzVlRm8G-60S9J1iykgL1YRmHbJjk9tkdYmRnShkkIGB5DtIIssHpa-xjKLlbJZY0I3MkiOzgPejGl49WUU7xgIEKLgk5dvaTI2fbTGGvJ_NpRkgceoTp6Q34-xD6jGr9WZDBfjLcagVtOMKoTaPScsPqp9BEjCEfV9Eu5cKStGMfpATC095nf4eYfSVToJKJ7JQCwMA-DfBnbeHeqwNbP5mA&amp;sig=Cg0ArKJSzNlAgX3qZliFEAE&amp;adurl="]))

        expect(vast?.startEvents).to(equal(["https://pubads.g.doubleclick.net/pagead/conversion/?ai=B4fABspJ4WI7IIOfQxgLToLbAC_jXj-sGAAAAEAEgqN27JjgAWPDXgsbXAWC7vq6D0Aq6AQo3Mjh4OTBfeG1syAEFwAIC4AIA6gIjLzEyNDMxOTA5Ni9leHRlcm5hbC91dGlsaXR5X3NhbXBsZXP4AvfRHoADAZAD0AWYA_ABqAMB4AQB0gUGEKCr9NICkAYBoAYj2AcB4AcK&amp;sigh=US9RxyYaTkY&amp;label=part2viewed&amp;ad_mt=[AD_MT]", "https://video-ad-stats.googlesyndication.com/video/client_events?event=2&amp;web_property=ca-pub-3279133228669082&amp;cpn=[CPN]&amp;break_type=[BREAK_TYPE]&amp;slot_pos=[SLOT_POS]&amp;ad_id=[AD_ID]&amp;ad_sys=[AD_SYS]&amp;ad_len=[AD_LEN]&amp;p_w=[P_W]&amp;p_h=[P_H]&amp;mt=[MT]&amp;rwt=[RWT]&amp;wt=[WT]&amp;sdkv=[SDKV]&amp;vol=[VOL]&amp;content_v=[CONTENT_V]&amp;conn=[CONN]&amp;format=[FORMAT_NAMESPACE]_[FORMAT_TYPE]_[FORMAT_SUBTYPE]"]))

        expect( vast?.firstQuartileEvents).to(equal([
            "https://pubads.g.doubleclick.net/pagead/conversion/?ai=B4fABspJ4WI7IIOfQxgLToLbAC_jXj-sGAAAAEAEgqN27JjgAWPDXgsbXAWC7vq6D0Aq6AQo3Mjh4OTBfeG1syAEFwAIC4AIA6gIjLzEyNDMxOTA5Ni9leHRlcm5hbC91dGlsaXR5X3NhbXBsZXP4AvfRHoADAZAD0AWYA_ABqAMB4AQB0gUGEKCr9NICkAYBoAYj2AcB4AcK&amp;sigh=US9RxyYaTkY&amp;label=videoplaytime25&amp;ad_mt=[AD_MT]"
        ]))
        expect( vast?.midPointEvents).to(equal([ "https://pubads.g.doubleclick.net/pagead/conversion/?ai=B4fABspJ4WI7IIOfQxgLToLbAC_jXj-sGAAAAEAEgqN27JjgAWPDXgsbXAWC7vq6D0Aq6AQo3Mjh4OTBfeG1syAEFwAIC4AIA6gIjLzEyNDMxOTA5Ni9leHRlcm5hbC91dGlsaXR5X3NhbXBsZXP4AvfRHoADAZAD0AWYA_ABqAMB4AQB0gUGEKCr9NICkAYBoAYj2AcB4AcK&amp;sigh=US9RxyYaTkY&amp;label=videoplaytime50&amp;ad_mt=[AD_MT]"]))

        expect( vast?.thirdQuartileEvents).to(equal([ "https://pubads.g.doubleclick.net/pagead/conversion/?ai=B4fABspJ4WI7IIOfQxgLToLbAC_jXj-sGAAAAEAEgqN27JjgAWPDXgsbXAWC7vq6D0Aq6AQo3Mjh4OTBfeG1syAEFwAIC4AIA6gIjLzEyNDMxOTA5Ni9leHRlcm5hbC91dGlsaXR5X3NhbXBsZXP4AvfRHoADAZAD0AWYA_ABqAMB4AQB0gUGEKCr9NICkAYBoAYj2AcB4AcK&amp;sigh=US9RxyYaTkY&amp;label=videoplaytime75&amp;ad_mt=[AD_MT]"]))

        expect(  vast?.completeEvents          ).to(equal(["https://pubads.g.doubleclick.net/pagead/conversion/?ai=B4fABspJ4WI7IIOfQxgLToLbAC_jXj-sGAAAAEAEgqN27JjgAWPDXgsbXAWC7vq6D0Aq6AQo3Mjh4OTBfeG1syAEFwAIC4AIA6gIjLzEyNDMxOTA5Ni9leHRlcm5hbC91dGlsaXR5X3NhbXBsZXP4AvfRHoADAZAD0AWYA_ABqAMB4AQB0gUGEKCr9NICkAYBoAYj2AcB4AcK&amp;sigh=US9RxyYaTkY&amp;label=videoplaytime100&amp;ad_mt=[AD_MT]", "https://video-ad-stats.googlesyndication.com/video/client_events?event=3&amp;web_property=ca-pub-3279133228669082&amp;cpn=[CPN]&amp;break_type=[BREAK_TYPE]&amp;slot_pos=[SLOT_POS]&amp;ad_id=[AD_ID]&amp;ad_sys=[AD_SYS]&amp;ad_len=[AD_LEN]&amp;p_w=[P_W]&amp;p_h=[P_H]&amp;mt=[MT]&amp;rwt=[RWT]&amp;wt=[WT]&amp;sdkv=[SDKV]&amp;vol=[VOL]&amp;content_v=[CONTENT_V]&amp;conn=[CONN]&amp;format=[FORMAT_NAMESPACE]_[FORMAT_TYPE]_[FORMAT_SUBTYPE]"]))

        expect(vast?.clickTrackingEvents).to(equal(["https://video-ad-stats.googlesyndication.com/video/client_events?event=6&amp;web_property=ca-pub-3279133228669082&amp;cpn=[CPN]&amp;break_type=[BREAK_TYPE]&amp;slot_pos=[SLOT_POS]&amp;ad_id=[AD_ID]&amp;ad_sys=[AD_SYS]&amp;ad_len=[AD_LEN]&amp;p_w=[P_W]&amp;p_h=[P_H]&amp;mt=[MT]&amp;rwt=[RWT]&amp;wt=[WT]&amp;sdkv=[SDKV]&amp;vol=[VOL]&amp;content_v=[CONTENT_V]&amp;conn=[CONN]&amp;format=[FORMAT_NAMESPACE]_[FORMAT_TYPE]_[FORMAT_SUBTYPE]"]))
    }

    func test_parse_response2() throws {
        // Given
        let parser = VastParser(connectionProvider: ConnectionProviderMock())

        // When
        let vast = parser.parse(xmlFile("mock_vast_response_2.0"))

        // Then
        expect(vast?.errorEvents.count).to(equal(1))
        expect(vast?.impressionEvents.count).to(equal(1))
        expect(vast?.clickTrackingEvents.count).to(equal(2))
        expect(vast?.redirect).to(equal("https://my.mock.api/vast/vast2.1.xml"))
        expect(vast?.type).to(equal(.wrapper))
        expect(vast?.media.count).to(equal(0))
        expect(vast?.creativeViewEvents).to(equal(["https://pubads.g.doubleclick.net/pagead/conversion/?ai=BLY-QpZJ4WL-oDcOLbcvpodAOoK2Q6wYAAAAQASCo3bsmOABYiKrYxtcBYLu-roPQCrIBFWRldmVsb3BlcnMuZ29vZ2xlLmNvbboBCjcyOHg5MF94bWzIAQXaAUhodHRwczovL2RldmVsb3BlcnMuZ29vZ2xlLmNvbS9pbnRlcmFjdGl2ZS1tZWRpYS1hZHMvZG9jcy9zZGtzL2h0bWw1L3RhZ3PAAgLgAgDqAiUvMTI0MzE5MDk2L2V4dGVybmFsL3NpbmdsZV9hZF9zYW1wbGVz-AL30R6AAwGQA9AFmAPwAagDAeAEAdIFBhCIrvTSApAGAaAGJNgHAOAHCg&amp;sigh=ClmLNunom9E&amp;label=vast_creativeview&amp;ad_mt=[AD_MT]"]))

        expect(vast?.startEvents).to(equal(["https://pubads.g.doubleclick.net/pagead/conversion/?ai=BLY-QpZJ4WL-oDcOLbcvpodAOoK2Q6wYAAAAQASCo3bsmOABYiKrYxtcBYLu-roPQCrIBFWRldmVsb3BlcnMuZ29vZ2xlLmNvbboBCjcyOHg5MF94bWzIAQXaAUhodHRwczovL2RldmVsb3BlcnMuZ29vZ2xlLmNvbS9pbnRlcmFjdGl2ZS1tZWRpYS1hZHMvZG9jcy9zZGtzL2h0bWw1L3RhZ3PAAgLgAgDqAiUvMTI0MzE5MDk2L2V4dGVybmFsL3NpbmdsZV9hZF9zYW1wbGVz-AL30R6AAwGQA9AFmAPwAagDAeAEAdIFBhCIrvTSApAGAaAGJNgHAOAHCg&amp;sigh=ClmLNunom9E&amp;label=part2viewed&amp;ad_mt=[AD_MT]", "https://video-ad-stats.googlesyndication.com/video/client_events?event=2&amp;web_property=ca-pub-3279133228669082&amp;cpn=[CPN]&amp;break_type=[BREAK_TYPE]&amp;slot_pos=[SLOT_POS]&amp;ad_id=[AD_ID]&amp;ad_sys=[AD_SYS]&amp;ad_len=[AD_LEN]&amp;p_w=[P_W]&amp;p_h=[P_H]&amp;mt=[MT]&amp;rwt=[RWT]&amp;wt=[WT]&amp;sdkv=[SDKV]&amp;vol=[VOL]&amp;content_v=[CONTENT_V]&amp;conn=[CONN]&amp;format=[FORMAT_NAMESPACE]_[FORMAT_TYPE]_[FORMAT_SUBTYPE]"]))

        expect( vast?.firstQuartileEvents).to(equal([
            "https://pubads.g.doubleclick.net/pagead/conversion/?ai=BLY-QpZJ4WL-oDcOLbcvpodAOoK2Q6wYAAAAQASCo3bsmOABYiKrYxtcBYLu-roPQCrIBFWRldmVsb3BlcnMuZ29vZ2xlLmNvbboBCjcyOHg5MF94bWzIAQXaAUhodHRwczovL2RldmVsb3BlcnMuZ29vZ2xlLmNvbS9pbnRlcmFjdGl2ZS1tZWRpYS1hZHMvZG9jcy9zZGtzL2h0bWw1L3RhZ3PAAgLgAgDqAiUvMTI0MzE5MDk2L2V4dGVybmFsL3NpbmdsZV9hZF9zYW1wbGVz-AL30R6AAwGQA9AFmAPwAagDAeAEAdIFBhCIrvTSApAGAaAGJNgHAOAHCg&amp;sigh=ClmLNunom9E&amp;label=videoplaytime25&amp;ad_mt=[AD_MT]"
        ]))

        expect( vast?.midPointEvents).to(equal([ "https://pubads.g.doubleclick.net/pagead/conversion/?ai=BLY-QpZJ4WL-oDcOLbcvpodAOoK2Q6wYAAAAQASCo3bsmOABYiKrYxtcBYLu-roPQCrIBFWRldmVsb3BlcnMuZ29vZ2xlLmNvbboBCjcyOHg5MF94bWzIAQXaAUhodHRwczovL2RldmVsb3BlcnMuZ29vZ2xlLmNvbS9pbnRlcmFjdGl2ZS1tZWRpYS1hZHMvZG9jcy9zZGtzL2h0bWw1L3RhZ3PAAgLgAgDqAiUvMTI0MzE5MDk2L2V4dGVybmFsL3NpbmdsZV9hZF9zYW1wbGVz-AL30R6AAwGQA9AFmAPwAagDAeAEAdIFBhCIrvTSApAGAaAGJNgHAOAHCg&amp;sigh=ClmLNunom9E&amp;label=videoplaytime50&amp;ad_mt=[AD_MT]"]))

        expect( vast?.thirdQuartileEvents).to(equal([ "https://pubads.g.doubleclick.net/pagead/conversion/?ai=BLY-QpZJ4WL-oDcOLbcvpodAOoK2Q6wYAAAAQASCo3bsmOABYiKrYxtcBYLu-roPQCrIBFWRldmVsb3BlcnMuZ29vZ2xlLmNvbboBCjcyOHg5MF94bWzIAQXaAUhodHRwczovL2RldmVsb3BlcnMuZ29vZ2xlLmNvbS9pbnRlcmFjdGl2ZS1tZWRpYS1hZHMvZG9jcy9zZGtzL2h0bWw1L3RhZ3PAAgLgAgDqAiUvMTI0MzE5MDk2L2V4dGVybmFsL3NpbmdsZV9hZF9zYW1wbGVz-AL30R6AAwGQA9AFmAPwAagDAeAEAdIFBhCIrvTSApAGAaAGJNgHAOAHCg&amp;sigh=ClmLNunom9E&amp;label=videoplaytime75&amp;ad_mt=[AD_MT]"]))

        expect( vast?.completeEvents).to(equal ([ "https://pubads.g.doubleclick.net/pagead/conversion/?ai=BLY-QpZJ4WL-oDcOLbcvpodAOoK2Q6wYAAAAQASCo3bsmOABYiKrYxtcBYLu-roPQCrIBFWRldmVsb3BlcnMuZ29vZ2xlLmNvbboBCjcyOHg5MF94bWzIAQXaAUhodHRwczovL2RldmVsb3BlcnMuZ29vZ2xlLmNvbS9pbnRlcmFjdGl2ZS1tZWRpYS1hZHMvZG9jcy9zZGtzL2h0bWw1L3RhZ3PAAgLgAgDqAiUvMTI0MzE5MDk2L2V4dGVybmFsL3NpbmdsZV9hZF9zYW1wbGVz-AL30R6AAwGQA9AFmAPwAagDAeAEAdIFBhCIrvTSApAGAaAGJNgHAOAHCg&amp;sigh=ClmLNunom9E&amp;label=videoplaytime100&amp;ad_mt=[AD_MT]", "https://video-ad-stats.googlesyndication.com/video/client_events?event=3&amp;web_property=ca-pub-3279133228669082&amp;cpn=[CPN]&amp;break_type=[BREAK_TYPE]&amp;slot_pos=[SLOT_POS]&amp;ad_id=[AD_ID]&amp;ad_sys=[AD_SYS]&amp;ad_len=[AD_LEN]&amp;p_w=[P_W]&amp;p_h=[P_H]&amp;mt=[MT]&amp;rwt=[RWT]&amp;wt=[WT]&amp;sdkv=[SDKV]&amp;vol=[VOL]&amp;content_v=[CONTENT_V]&amp;conn=[CONN]&amp;format=[FORMAT_NAMESPACE]_[FORMAT_TYPE]_[FORMAT_SUBTYPE]"]))

        expect(vast?.clickTrackingEvents).to(equal(["https://video-ad-stats.googlesyndication.com/video/client_events?event=6&amp;web_property=ca-pub-3279133228669082&amp;cpn=[CPN]&amp;break_type=[BREAK_TYPE]&amp;slot_pos=[SLOT_POS]&amp;ad_id=[AD_ID]&amp;ad_sys=[AD_SYS]&amp;ad_len=[AD_LEN]&amp;p_w=[P_W]&amp;p_h=[P_H]&amp;mt=[MT]&amp;rwt=[RWT]&amp;wt=[WT]&amp;sdkv=[SDKV]&amp;vol=[VOL]&amp;content_v=[CONTENT_V]&amp;conn=[CONN]&amp;format=[FORMAT_NAMESPACE]_[FORMAT_TYPE]_[FORMAT_SUBTYPE]", "https://pubads.g.doubleclick.net/pcs/click?xai=AKAOjsuyjdNJZ1zHVE5WfaJrEvrP7eK0VqSdNyGBRoMjMXd90VYE3xZVr3l5Kn0h166VefqEYqeNX_z_zObIjytcV-YGYRDvmnzU93x3Kplly4YHIdlHtXRrAE3AbaZAjN9HEjoTs4g6GZM7lc4KX_5OdCRwaEq-DuVxs0QZNkyJ5b8nCA3nkya8WzKLmAf_4sjx3e3aAanzjuaYc1__5LMi7hXLuYk_Bubh7HNPofn4y8PKVmnaOZGfaycMkFIr4pTd1DdQJ6Ma&amp;sig=Cg0ArKJSzOdaV5VR9GxbEAE&amp;urlfix=1"]))
    }

}
