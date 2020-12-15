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
    var response: AdResponse? = nil
    
    private let imageFormatUsed = "imgformatused"
    private let mediaFormatUsed = "mediaformatused"
    private let tagFormatUsed = "tagformatused"
    
    private func testProcess(_ format: CreativeFormatType, _ html: String?, _ vast: String?) {
        // Given
        let placementId = 1
        let ad = MockFactory.makeAd(format, vast)
        let dataResult: Result<Data, Error> = Result.success(Data())
        let downloadResult: Result<String, Error> = Result.success("")
        let adProcessor = AdProcessor(htmlFormatter: HtmlFormatterMock(imageFormat: imageFormatUsed,
                                                                       mediaFormat: mediaFormatUsed,
                                                                       tagFormat: tagFormatUsed),
                                      vastParser: VastParserMock(firstVast: VastAd(), secondVast: VastAd()),
                                      networkDataSource: NetworkDataSourceMock(getDataResult: dataResult,
                                                                               getDataResult2: dataResult,
                                                                               downloadFileResult: downloadResult),
                                      logger: LoggerMock())
        // When
        let expectation = self.expectation(description: "request")
        adProcessor.process(placementId, ad) { response in
            self.response = response
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 2.0, handler: nil)
        
        // Then
        expect(self.response?.html).to(equalSmart(html))
    }
    
    private func testVideo(_ url: String?, filePath: String?,
                           dataResult: Result<Data, Error>,
                           dataResult2: Result<Data, Error>,
                           downloadResult: Result<String, Error>,
                           vastAd: VastAd, secondVastAd: VastAd,
                           impressionEventCount: Int?) {
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
        adProcessor.process(placementId, ad) { response in
            self.response = response
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 2.0, handler: nil)
        
        // Then
        expect(self.response?.filePath).to(filePath != nil ? equal(filePath) : beNil())
        expect(self.response?.vast?.impressionEvents.count).to(equalSmart(impressionEventCount))
    }
    
    func test_process() throws {
        testProcess(.image_with_link, imageFormatUsed, nil)
        testProcess(.rich_media, mediaFormatUsed, nil)
        testProcess(.tag, tagFormatUsed, nil)
        testProcess(.unknown, nil, nil)
    }
    
    func test_videoTag_networkDataCalled() throws {
        let downloadFilePath = "localfilepath"
        let first = VastAd()
        first.addEvent(VastEvent(event: "vast_impression", url: "url1"))
        
        testVideo("first_url", filePath: downloadFilePath,
                  dataResult: Result.success(Data("firstdata".utf8)),
                  dataResult2: Result.success(Data()),
                  downloadResult: Result.success(downloadFilePath),
                  vastAd: first, secondVastAd: VastAd(),
                  impressionEventCount: 1)
    }
    
    func test_videoTag_vastRedirect_mergeVasts() throws {
        let downloadFilePath = "localfilepath"
        let first = VastAd()
        first.redirect = "redirecturl"
        first.addEvent(VastEvent(event: "vast_impression", url: "url1"))
        
        let second = VastAd()
        second.addEvent(VastEvent(event: "vast_impression", url: "url2"))
        
        testVideo("firsturl", filePath: downloadFilePath,
                  dataResult: Result.success(Data("firstdata".utf8)),
                  dataResult2: Result.success(Data()),
                  downloadResult: Result.success(downloadFilePath),
                  vastAd: first, secondVastAd: second,
                  impressionEventCount: 2)
    }
    
    func test_videoTag_downloadFailure_emptyResponse() throws {
        testVideo("firsturl", filePath: nil,
                  dataResult: Result.failure(AwesomeAdsError.network),
                  dataResult2: Result.failure(AwesomeAdsError.network),
                  downloadResult: Result.failure(AwesomeAdsError.network),
                  vastAd: VastAd(), secondVastAd: VastAd(),
                  impressionEventCount: nil)
    }
    
    func test_videoTag_noUrl_emptyResponse() throws {
        testVideo(nil, filePath: nil,
                  dataResult: Result.failure(AwesomeAdsError.network),
                  dataResult2: Result.failure(AwesomeAdsError.network),
                  downloadResult: Result.failure(AwesomeAdsError.network),
                  vastAd: VastAd(), secondVastAd: VastAd(),
                  impressionEventCount: nil)
    }
}
