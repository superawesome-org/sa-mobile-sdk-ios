//
//  EventModels.swift
//  SuperAwesome
//
//  Created by Gunhan Sancar on 30/04/2020.
//

struct EventQuery: Codable {
    let placement: Int
    let bundle: String
    let creative: Int
    let line_item: Int
    let ct: ConnectionType
    let sdkVersion: String
    let rnd: Int
    let type: EventType?
    let no_image: Bool?
    let data: String?
}

struct EventData: Codable {
    let placement: Int
    let line_item: Int
    let creative: Int
    let type: EventType
}

enum EventType: String, Codable {
    case impressionDownloaded
    case viewable_impression
    case parentalGateOpen
    case parentalGateClose
    case parentalGateFail
    case parentalGateSuccess
}
