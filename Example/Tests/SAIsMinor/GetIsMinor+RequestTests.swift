//
//  GetIsMinor+RequestTests.swift
//  SAGDPRKisMinor_Tests
//
//  Created by Guilherme Mota on 01/05/2018.
//  Copyright © 2018 GuilhermeMota93. All rights reserved.
//


import XCTest
import Nimble
import SAGDPRKisMinor

class GetIsMinorRequestTests: XCTestCase {
    
    private var request: GetIsMinorProcess!
    private var method: HTTP_METHOD!
    private var endpoint: String!
    
    //specifis
    private var bundleId: String!
    private var dateOfBirth : String!
    
    override func setUp() {
        super.setUp()
        
        // given
        bundleId = "tv.superawesome.bundleId"
        dateOfBirth = "2012-02-02"
        method = .GET
        endpoint = "v1/countries/child-age"
        
        //when
        request = GetIsMinorProcess(values: dateOfBirth, bundleId)
        
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func test_Request_ToBe_NotNil(){
        //then
        expect(self.request).toNot(beNil())
    }
    
    func test_Request_Method(){
        //then
        expect(self.method).to(equal(self.request.getMethod()))
    }
    
    func test_Endpoint(){
        //then
        expect(self.endpoint).to(equal(self.request.getEndpoint()))
    }
    
    func test_Constants_ToBe_NotNil(){
        //then
        expect(self.bundleId).toNot(beNil())
        expect(self.dateOfBirth).toNot(beNil())
        expect(self.endpoint).toNot(beNil())
        expect(self.method).toNot(beNil())
    }
    
    func test_Request_Body_ToBe_Empty(){
        //then
        expect(self.request.getBody().count).to(equal(0))
    }
    
    public func test_RequestHeader_ToBe_Empty() {
        //then
        expect(self.request.getHeader().count).to(equal(0))
    }
    
    func test_Request_Query_ToBe_NotNil() {
        let query = self.request.getQuery()
        //then
        expect(query).toNot(beNil())
        expect(query?.keys.contains("bundleId")).to(beTrue())
        expect(query?.keys.contains("dob")).to(beTrue())
        
    }
}
