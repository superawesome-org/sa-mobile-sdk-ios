//
//  Device.swift
//  SuperAwesome
//
//  Created by Gunhan Sancar on 02/04/2020.
//

import Foundation

public protocol DeviceType {
    var type: String { get }
    var systemVersion: String { get }
    var systemVersionEscaped: String { get }
    var userAgent: String { get }
}

public class Device : NSObject, DeviceType {
    public var type: String
    public var systemVersion: String
    public var systemVersionEscaped: String
    public var userAgent: String

    public override init() {
        type = UIDevice.current.model.hasPrefix("iPad") ? "iPad" : "iPhone"
        systemVersion = UIDevice.current.systemVersion
        systemVersionEscaped = systemVersion.replacingOccurrences(of: ".", with: "_")
        userAgent = "Mozilla/5.0 (\(type); CPU \(type) OS \(systemVersionEscaped) like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148"
        
        super.init()
    }
}
