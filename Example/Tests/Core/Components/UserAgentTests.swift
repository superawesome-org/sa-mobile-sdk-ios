//
//  UserAgentTests.swift
//  Tests
//
//  Created by Gunhan Sancar on 06/04/2020.
//  Copyright © 2020 Gabriel Coman. All rights reserved.
//

import XCTest
import Nimble
@testable import SuperAwesome

class UserAgentTests: XCTestCase {
    func testUserAgentName_dataRepositryHasData_useDataRepositoryAgent() throws {
        // Given: Data repository has data
        let dataUserAgent: String? = "mockUserAgent"
        let userAgent = UserAgent(device: DeviceMock(), dataRepository: DataRepositoryMock(dataUserAgent))
        
        // Then
        expect(userAgent.name).to(equal(dataUserAgent))
    }
    
    func testUserAgentName_dataRepositryHasNoData_useDeviceAgent() throws {
        // Given: Data repository no data
        let dataUserAgent: String? = nil
        let userAgent = UserAgent(device: DeviceMock(), dataRepository: DataRepositoryMock(dataUserAgent))
        
        // Then
        expect(userAgent.name).to(equal("mockDeviceUserAgent"))
    }
}
