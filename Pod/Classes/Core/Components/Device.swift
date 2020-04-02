//
//  Device.swift
//  SuperAwesome
//
//  Created by Gunhan Sancar on 02/04/2020.
//

import Foundation

@objc(SADeviceType)
public protocol DeviceType {
    @objc(type) var type: String { get }
    @objc(systemVersion) var systemVersion: String { get }
    @objc(systemVersionEscaped) var systemVersionEscaped: String { get }
}

@objc(SADevice)
public class Device : NSObject, DeviceType {
    public var type: String
    public var systemVersion: String
    public var systemVersionEscaped: String
    
    public override init() {
        type = UIDevice.current.model.hasPrefix("iPad") ? "iPad" : "iPhone"
        systemVersion = UIDevice.current.systemVersion
        systemVersionEscaped = systemVersion.replacingOccurrences(of: ".", with: "_")
        
        super.init()
    }
}
