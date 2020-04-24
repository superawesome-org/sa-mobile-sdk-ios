//
//  EventType.swift
//  SuperAwesome
//
//  Created by Gunhan Sancar on 15/04/2020.
//

enum EventType: String, Codable {
    case impressionDownloaded
    case viewableImpression
    case parentalGateOpen
    case parentalGateClose
    case parentalGateError
    case parentalGateSuccess
}
