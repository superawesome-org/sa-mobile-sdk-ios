//
//  GetIsMinorModel+Mapping.swift
//  SAGDPRKisMinor_Tests
//
//  Created by Guilherme Mota on 01/05/2018.
//  Copyright © 2018 GuilhermeMota93. All rights reserved.
//

import XCTest
import Nimble
import SAGDPRKisMinor

class GetIsMinorModelMappingTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func test_GetIsMinor_Mapping_Success_Response() {
        
        var JSON: Any?
        JSON = try? fixtureWithName(name:"get_is_minor_success_response")
    
        let getIsMinorResponse = GetIsMinorModel(jsonDictionary: JSON! as? [AnyHashable : Any])
        
        expect(getIsMinorResponse).toNot(beNil())
        expect(getIsMinorResponse?.country).to(equal("gb"))
        expect(getIsMinorResponse?.consentAgeForCountry).to(equal(13))
        expect(getIsMinorResponse?.age).to(equal(6))
    }
    
    func test_GetIsMinor_With_Flag_Mapping_Success_Response() {
        
        var JSON: Any?
        JSON = try? fixtureWithName(name:"get_is_minor_with_flag_success_response")
        
        let getIsMinorResponse =  GetIsMinorModel(jsonDictionary: JSON! as? [AnyHashable : Any])
        
        expect(getIsMinorResponse).toNot(beNil())
        expect(getIsMinorResponse?.country).to(equal("gb"))
        expect(getIsMinorResponse?.consentAgeForCountry).to(equal(13))
        expect(getIsMinorResponse?.age).to(equal(6))
        expect(getIsMinorResponse?.isMinor).to(beTrue())
    }
}
