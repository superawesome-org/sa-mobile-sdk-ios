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
    private let options = ["testKey": "testValue"]

    private func testProcess(_ format: CreativeFormatType, _ html: String?, _ vast: String?, _ options: [String: Any]?) {
        // Given
        let placementId = 1
        let ad = MockFactory.makeAd(format, vast)
        let dataResult: Result<Data, Error> = Result.success(Data())
        let downloadResult: Result<String, Error> = Result.success("")
        let adProcessor = AdProcessor(htmlFormatter: HtmlFormatterMock(imageFormat: imageFormatUsed,
                                                                       mediaFormat: mediaFormatUsed,
                                                                       tagFormat: tagFormatUsed),
                                      vastParser: VastParserMock(firstVast: VastAd(type: .inLine), secondVast: VastAd(type: .inLine)),
                                      networkDataSource: NetworkDataSourceMock(getDataResult: dataResult,
                                                                               getDataResult2: dataResult,
                                                                               downloadFileResult: downloadResult),
                                      logger: LoggerMock())
        // When
        let expectation = self.expectation(description: "request")
        adProcessor.process(placementId, ad, options) { response in
            self.response = response
            expectation.fulfill()
        }

        waitForExpectations(timeout: 2.0, handler: nil)

        // Then
        expect(self.response?.html).to(equalSmart(html))
        expect(self.response?.requestOptions as? [String: String]).to(equalSmart(options as? [String: String]))
    }

    private func testVideo(_ url: String?, filePath: String?,
                           dataResult: Result<Data, Error>,
                           dataResult2: Result<Data, Error>,
                           downloadResult: Result<String, Error>,
                           vastAd: VastAd, secondVastAd: VastAd,
                           impressionEventCount: Int?,
                           options: [String: Any]?) {
        // Given
        let placementId = 1
        let ad = MockFactory.makeAd(.video, url)
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
        adProcessor.process(placementId, ad, options) { response in
            self.response = response
            expectation.fulfill()
        }

        waitForExpectations(timeout: 2.0, handler: nil)

        // Then
        expect(self.response?.filePath).to(filePath != nil ? equal(filePath) : beNil())
        expect(self.response?.vast?.impressionEvents.count).to(equalSmart(impressionEventCount))
        expect(self.response?.requestOptions as? [String: String]).to(equalSmart(options as? [String: String]))
    }

    func test_process() throws {
        // With additional request options
        testProcess(.imageWithLink, imageFormatUsed, nil, options)
        testProcess(.richMedia, mediaFormatUsed, nil, options)
        testProcess(.tag, tagFormatUsed, nil, options)
        testProcess(.unknown, nil, nil, options)

        // Without additional request options
        testProcess(.imageWithLink, imageFormatUsed, nil, nil)
        testProcess(.richMedia, mediaFormatUsed, nil, nil)
        testProcess(.tag, tagFormatUsed, nil, nil)
        testProcess(.unknown, nil, nil, nil)
    }

    func test_videoTag_networkDataCalled() throws {
        let downloadFilePath = "localfilepath"
        let first = VastAd(type: .inLine, impressions: ["url1"])

        testVideo("first_url", filePath: downloadFilePath,
                  dataResult: Result.success(Data("firstdata".utf8)),
                  dataResult2: Result.success(Data()),
                  downloadResult: Result.success(downloadFilePath),
                  vastAd: first, secondVastAd: VastAd(type: .inLine),
                  impressionEventCount: 1,
                  options: nil)
    }

    func test_videoTag_withOptions() throws {
        let downloadFilePath = "localfilepath"
        let first = VastAd(type: .inLine, impressions: ["url1"])

        testVideo("first_url",
                  filePath: downloadFilePath,
                  dataResult: Result.success(Data("firstdata".utf8)),
                  dataResult2: Result.success(Data()),
                  downloadResult: Result.success(downloadFilePath),
                  vastAd: first, 
                  secondVastAd: VastAd(type: .inLine),
                  impressionEventCount: 1,
                  options: options)
    }

    func test_videoTag_vastRedirect_mergeVasts() throws {
        let downloadFilePath = "localfilepath"
        let first =  VastAd(type: .invalid, redirect: "redirecturl", impressions: ["url1"])
        let second =  VastAd(type: .inLine, impressions: ["url2"])

        testVideo("firsturl", filePath: downloadFilePath,
                  dataResult: Result.success(Data("firstdata".utf8)),
                  dataResult2: Result.success(Data()),
                  downloadResult: Result.success(downloadFilePath),
                  vastAd: first, secondVastAd: second,
                  impressionEventCount: 2,
                  options: nil)
    }

    func test_videoTag_downloadFailure_emptyResponse() throws {
        testVideo("firsturl", filePath: nil,
                  dataResult: Result.failure(AwesomeAdsError.network),
                  dataResult2: Result.failure(AwesomeAdsError.network),
                  downloadResult: Result.failure(AwesomeAdsError.network),
                  vastAd: VastAd(type: .inLine), secondVastAd: VastAd(type: .inLine),
                  impressionEventCount: nil,
                  options: nil)
    }

    func test_videoTag_noUrl_emptyResponse() throws {
        testVideo(nil, filePath: nil,
                  dataResult: Result.failure(AwesomeAdsError.network),
                  dataResult2: Result.failure(AwesomeAdsError.network),
                  downloadResult: Result.failure(AwesomeAdsError.network),
                  vastAd: VastAd(type: .inLine), secondVastAd: VastAd(type: .inLine),
                  impressionEventCount: nil,
                  options: nil)
    }
}
