//
//  ConnectionType.swift
//  SuperAwesome
//
//  Created by Gunhan Sancar on 17/04/2020.
//

/// Possible network connection types
enum ConnectionType: Int, Codable {
    case unknown = 0
    case ethernet = 1
    case wifi = 2
    case cellularUnknown = 3
    case cellular2g      = 4
    case cellular3g      = 5
    case cellular4g      = 6
}
