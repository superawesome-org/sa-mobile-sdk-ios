//
//  DeviceTests.swift
//  Tests
//
//  Created by Gunhan Sancar on 02/04/2020.
//  Copyright © 2020 Gabriel Coman. All rights reserved.
//

import XCTest
import Nimble
@testable import SuperAwesome

class UIDeviceMock: UIDevice {
    private let modelMock: String
    private let systemVersionMock: String
    
    init(model:String, systemVersion: String) {
        self.modelMock = model
        self.systemVersionMock = systemVersion
    }
    
    override var model : String { return modelMock }
    override var systemVersion : String { return systemVersionMock }
}

class DeviceMock: DeviceType {
    var type: String = ""
    var systemVersion: String = ""
    var systemVersionEscaped: String = ""
    var userAgent: String
    
    init() {
        self.userAgent = "mockDeviceUserAgent"
    }
}

class DeviceTests: XCTestCase {
    var device: Device!
    let uiDevice = UIDevice()
    
    override func setUp() {
        super.setUp()
        device = Device(uiDevice)
    }

    func testDeviceModelIpad() throws {
        // Given: Device model is iPad variant
        let model = "iPadXYZ"
        let device = Device(UIDeviceMock(model: model, systemVersion: "any"))
        
        // Then: Type is `iPad`
        expect(device.type).to(equal("iPad"))
    }
    
    func testDeviceModelIPhone() throws {
        // Given: Device model is iPhone variant
        let model = "iPhoneXyz"
        let device = Device(UIDeviceMock(model: model, systemVersion: "any"))
        
        // Then: Type is `iPhone`
        expect(device.type).to(equal("iPhone"))
    }
    
    func testUserAgent() throws {
        // Given: model and system version
        let model = "iPhoneVariant"
        let systemVersion = "13.0"
        let type = "iPhone"
        let systemVersionEscaped = "13_0"
        
        let device = Device(UIDeviceMock(model: model, systemVersion: systemVersion))
        
        // Then
        expect(device.userAgent).to(equal("Mozilla/5.0 (\(type); CPU \(type) OS \(systemVersionEscaped) like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148"
        ))
    }
}
