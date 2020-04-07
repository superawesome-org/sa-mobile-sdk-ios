//
//  DeviceMock.swift
//  Tests
//
//  Created by Gunhan Sancar on 07/04/2020.
//  Copyright © 2020 Gabriel Coman. All rights reserved.
//

@testable import SuperAwesome

class DeviceMock: DeviceType {
    var type: String = ""
    var systemVersion: String = ""
    var systemVersionEscaped: String = ""
    var userAgent: String
    
    init() {
        self.userAgent = "mockDeviceUserAgent"
    }
}
