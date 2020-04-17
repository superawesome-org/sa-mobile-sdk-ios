//
//  ConnectionManager.swift
//  SuperAwesome
//
//  Created by Gunhan Sancar on 17/04/2020.
//

import Foundation
import SystemConfiguration

protocol ConnectionManagerType {
    func findConnectionType() -> ConnectionType
}

class ConnectionManager: ConnectionManagerType {
    func findConnectionType() -> ConnectionType {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        guard let reachability = withUnsafePointer(to: &zeroAddress, {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
                SCNetworkReachabilityCreateWithAddress(nil, $0)
            }
        }) else {
            return .unknown
        }
        
        var flags = SCNetworkReachabilityFlags()
        
        if !SCNetworkReachabilityGetFlags(reachability, &flags) {
            return .unknown
        }
        
        if !flags.contains(.reachable) {
            return .unknown
        } else if flags.contains(.isWWAN) {
            return .cellularUnknown
        } else if !flags.contains(.connectionRequired) {
            return .wifi
        } else if (flags.contains(.connectionOnDemand) || flags.contains(.connectionOnTraffic)) && !flags.contains(.interventionRequired) {
            return .wifi
        } else {
            return .unknown
        }
    }
}
