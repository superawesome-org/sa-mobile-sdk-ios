//
//  AwesomeAdsApiTests.swift
//  Tests
//
//  Created by Gunhan Sancar on 16/04/2020.
//  Copyright © 2020 Gabriel Coman. All rights reserved.
//

import XCTest
import Nimble
import Moya
@testable import SuperAwesome

class AwesomeAdsApiTests: XCTestCase {
    var provider: MoyaProvider<AwesomeAdsApi>!
    
    override func setUp() {
        super.setUp()
        provider = MoyaProvider<AwesomeAdsApi>(stubClosure: MoyaProvider.immediatelyStub)
    }
    
    func testApi() throws {
        
    }
}
