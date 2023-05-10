//
//  AdProcessorTests.swift
//  SuperAwesome-Unit-Full-Tests
//
//  Created by Gunhan Sancar on 28/10/2020.
//

import XCTest
import Nimble
@testable import SuperAwesome

class AdProcessorTests: XCTestCase {
    var response: AdResponse?

    private let imageFormatUsed = "imgformatused"
    private let mediaFormatUsed = "mediaformatused"
    private let tagFormatUsed = "tagformatused"

    private func testProcess(_ format: CreativeFormatType, _ html: String?, _ vast: String?) {
        // Given
        let placementId = 1
        let ad = MockFactory.makeAd(format: format, vast: vast)
        let dataResult: Result<Data, Error> = Result.success(Data())
        let downloadResult: Result<String, Error> = Result.success("")
        let adProcessor = AdProcessor(htmlFormatter: HtmlFormatterMock(imageFormat: imageFormatUsed,
                                                                       mediaFormat: mediaFormatUsed,
                                                                       tagFormat: tagFormatUsed),
                                      vastParser: VastParserMock(firstVast: VastAd(type: .inLine),
                                                                 secondVast: VastAd(type: .inLine)),
                                      networkDataSource: NetworkDataSourceMock(getDataResult: dataResult,
                                                                               getDataResult2: dataResult,
                                                                               downloadFileResult: downloadResult),
                                      logger: LoggerMock())
        // When
        let expectation = self.expectation(description: "request")
        adProcessor.process(placementId, ad, nil) { [weak self] response in
            self?.response = response
            expectation.fulfill()
        }

        waitForExpectations(timeout: 2.0, handler: nil)

        // Then
        expect(self.response?.html).to(equalSmart(html))
    }

    private func testVideo(_ url: String?,
                           filePath: String?,
                           dataResult: Result<Data, Error>,
                           dataResult2: Result<Data, Error>,
                           downloadResult: Result<String, Error>,
                           vastAd: VastAd,
                           secondVastAd: VastAd,
                           impressionEventCount: Int?,
                           tag: String? = nil,
                           isVpaid: Bool = false,
                           additionalAssertions: (() -> Void)? = nil) {
        // Given
        let placementId = 1
        let ad = MockFactory.makeAd(format: .video, vast: url, tag: tag, isVpaid: isVpaid)
        let adProcessor = AdProcessor(htmlFormatter: HtmlFormatterMock(imageFormat: imageFormatUsed,
                                                                       mediaFormat: mediaFormatUsed,
                                                                       tagFormat: tagFormatUsed),
                                      vastParser: VastParserMock(firstVast: vastAd, secondVast: secondVastAd),
                                      networkDataSource: NetworkDataSourceMock(getDataResult: dataResult,
                                                                               getDataResult2: dataResult2,
                                                                               downloadFileResult: downloadResult),
                                      logger: LoggerMock())
        // When
        let expectation = self.expectation(description: "request")
        adProcessor.process(placementId, ad, nil) { [weak self] response in
            self?.response = response
            expectation.fulfill()
        }

        waitForExpectations(timeout: 2.0, handler: nil)

        // Then
        expect(self.response?.filePath).to(filePath != nil ? equal(filePath) : beNil())
        expect(self.response?.vast?.impressionEvents.count).to(equalSmart(impressionEventCount))
        additionalAssertions?()
    }

    func test_process() throws {
        testProcess(.imageWithLink, imageFormatUsed, nil)
        testProcess(.richMedia, mediaFormatUsed, nil)
        testProcess(.tag, tagFormatUsed, nil)
        testProcess(.unknown, nil, nil)
    }

    func test_videoTag_networkDataCalled() throws {
        let downloadFilePath = "localfilepath"
        let first = VastAd(url: "blah",
                           type: .inLine,
                           impressions: ["url1"])

        testVideo("firsturl",
                  filePath: downloadFilePath,
                  dataResult: Result.success(Data("firstdata".utf8)),
                  dataResult2: Result.success(Data()),
                  downloadResult: Result.success(downloadFilePath),
                  vastAd: first,
                  secondVastAd: VastAd(type: .inLine),
                  impressionEventCount: 1)
    }

    func test_videoTag_vastRedirect_mergeVasts() throws {
        let downloadFilePath = "localfilepath"
        let first = VastAd(url: "blah",
                           type: .invalid,
                           redirect: "redirecturl",
                           impressions: ["url1"])
        let second = VastAd(url: "blah2",
                            type: .inLine,
                            impressions: ["url2"])

        testVideo("firsturl",
                  filePath: downloadFilePath,
                  dataResult: Result.success(Data("firstdata".utf8)),
                  dataResult2: Result.success(Data()),
                  downloadResult: Result.success(downloadFilePath),
                  vastAd: first,
                  secondVastAd: second,
                  impressionEventCount: 2)
    }

    func test_videoTag_downloadFailure_emptyResponse() throws {
        testVideo("firsturl", filePath: nil,
                  dataResult: Result.failure(AwesomeAdsError.network),
                  dataResult2: Result.failure(AwesomeAdsError.network),
                  downloadResult: Result.failure(AwesomeAdsError.network),
                  vastAd: VastAd(type: .inLine), secondVastAd: VastAd(type: .inLine),
                  impressionEventCount: nil)
    }

    func test_videoTag_noUrl_emptyResponse() throws {
        testVideo(nil, filePath: nil,
                  dataResult: Result.failure(AwesomeAdsError.network),
                  dataResult2: Result.failure(AwesomeAdsError.network),
                  downloadResult: Result.failure(AwesomeAdsError.network),
                  vastAd: VastAd(type: .inLine), secondVastAd: VastAd(type: .inLine),
                  impressionEventCount: nil)
    }

    func test_videoTag_isVpaid_networkDataCalled() throws {
        let first = VastAd(url: "blah",
                           type: .inLine,
                           impressions: ["url1"])

        testVideo("firsturl",
                  filePath: nil,
                  dataResult: Result.success(Data("firstdata".utf8)),
                  dataResult2: Result.success(Data()),
                  downloadResult: Result.success(""),
                  vastAd: first,
                  secondVastAd: VastAd(type: .inLine),
                  impressionEventCount: nil,
                  tag: "<script href=\"https://test.com/ad.js?blah=this\"/>",
                  isVpaid: true) { [weak self] in
            XCTAssertEqual(self?.response?.baseUrl, "https://test.com")
        }
    }

    func test_videoVAST_isVpaid_networkDataCalled() throws {
        let first = VastAd(url: "https://test.com/ad.js?blah=this",
                           type: .inLine,
                           impressions: ["url1"])

        testVideo("https://test.com/ad.js?blah=this",
                  filePath: nil,
                  dataResult: Result.success(Data("firstdata".utf8)),
                  dataResult2: Result.success(Data()),
                  downloadResult: Result.success(""),
                  vastAd: first,
                  secondVastAd: VastAd(type: .inLine),
                  impressionEventCount: nil,
                  isVpaid: true) { [weak self] in
            XCTAssertEqual(self?.response?.baseUrl, "https://test.com")
        }
    }

}
