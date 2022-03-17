//
//  DeviceTests.swift
//  Tests
//
//  Created by Gunhan Sancar on 02/04/2020.
//

import XCTest
import Nimble
@testable import SuperAwesome

class DeviceTests: XCTestCase {
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

        let device = Device(UIDeviceMock(model: model, systemVersion: systemVersion))

        // Then
        expect(device.userAgent).to(equal(
            "Mozilla/5.0 (iPhone; CPU iPhone OS 13_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148"
        ))
    }
}
