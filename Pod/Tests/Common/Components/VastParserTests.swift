import XCTest
import Nimble
@testable import SuperAwesome

class VastParserTests: XCTestCase {

    func test_merge_vastAds() throws {
        // Given
        let vastAd1 = VastAd()
        vastAd1.type = .InLine
        vastAd1.url = "url1"
        vastAd1.addEvent(VastEvent(event: "vast_start", url: ""))
        vastAd1.addEvent(VastEvent(event: "vast_start", url: ""))
        vastAd1.addMedia(VastMedia())
        vastAd1.addMedia(VastMedia())

        let vastAd2 = VastAd()
        vastAd2.type = .Wrapper
        vastAd2.url = "url2"
        vastAd2.addEvent(VastEvent(event: "vast_start", url: ""))
        vastAd2.addMedia(VastMedia())

        // When
        let merged = vastAd1.merge(from: vastAd2)

        // Then
        expect(merged.url).to(equal("url2"))
        expect(merged.startEvents.count).to(equal(3))
        expect(merged.media.count).to(equal(3))
    }

    func test_parse_response1() throws {
        // Given
        let parser = VastParser(connectionProvider: ConnectionProviderMock())

        // When
        let vast = parser.parse(xmlFile("mock_vast_response_1.0"))

        // Then
        expect(vast.url).to(equal("https://ads.superawesome.tv/v2/demo_images/video.mp4"))
        expect(vast.errorEvents.first).to(equal("https://ads.superawesome.tv/v2/video/error?placement=30479&amp;creative=-1&amp;line_item=-1&amp;sdkVersion=unknown&amp;rnd=3232269&amp;device=web&amp;country=GB&amp;code=[ERRORCODE]"))
        expect(vast.impressionEvents.first).to(equal("https://ads.superawesome.tv/v2/video/impression?placement=30479&amp;creative=-1&amp;line_item=-1&amp;sdkVersion=unknown&amp;rnd=4538730&amp;device=web&amp;country=GB"))
        expect(vast.clickThroughUrl).to(equal("https://ads.superawesome.tv/v2/video/click?placement=30479&creative=-1&line_item=-1&sdkVersion=unknown&rnd=1809240&device=web&country=GB"))
        expect(vast.redirect).to(beNil())
        expect(vast.type).to(equal(.InLine))
        expect(vast.media.count).to(equal(1))
    }

    func test_parse_response2() throws {
        // Given
        let parser = VastParser(connectionProvider: ConnectionProviderMock())

        // When
        let vast = parser.parse(xmlFile("mock_vast_response_2.0"))

        // Then
        expect(vast.errorEvents.count).to(equal(1))
        expect(vast.impressionEvents.count).to(equal(1))
        expect(vast.clickTrackingEvents.count).to(equal(2))
        expect(vast.redirect).to(equal("https://my.mock.api/vast/vast2.1.xml"))
    }
}
