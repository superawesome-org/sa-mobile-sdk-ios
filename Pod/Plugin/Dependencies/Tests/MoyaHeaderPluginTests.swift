//
//  MoyaHeaderPluginTests.swift
//  SuperAwesome-Unit-Moya-Tests
//
//  Created by Gunhan Sancar on 30/04/2020.
//

import XCTest
import Nimble
import Moya
import Mockingjay
@testable import SuperAwesome

class MoyaHeaderPluginTests: XCTestCase {
    func test_givenUserAgent_setOnRequest() {
        // Given
        let name = "mockAgentName"
        let userAgentProvider = UserAgentProviderMock(name: name)
        let moyaHeaderPlugin = MoyaHeaderPlugin(userAgentProvider: userAgentProvider)
        let request = URLRequest(url: URL(string: "https://superawesome.com")!)

        // When
        let updatedRequest = moyaHeaderPlugin.prepare(request,
                                                      target: AwesomeAdsApi.event(query: makeEventQueryInstance()))

        // Then
        expect(updatedRequest.headers["User-Agent"]).to(equal(name))
    }
}
