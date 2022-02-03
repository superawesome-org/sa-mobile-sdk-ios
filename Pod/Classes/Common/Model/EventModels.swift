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
    let lineItem: Int
    let connectionType: ConnectionType
    let sdkVersion: String
    let rnd: Int
    let type: EventType?
    let noImage: Bool?
    let data: String?

    enum CodingKeys: String, CodingKey {
        case placement
        case bundle
        case creative
        case lineItem = "line_item"
        case connectionType = "ct"
        case sdkVersion
        case rnd
        case type
        case noImage = "no_image"
        case data
        }
}

struct EventData: Codable {
    let placement: Int
    let lineItem: Int
    let creative: Int
    let type: EventType

    enum CodingKeys: String, CodingKey {
        case lineItem = "line_item"
        case placement
        case creative
        case type
    }
}

enum EventType: String, Codable {
    case impressionDownloaded
    case viewableImpression = "viewable_impression"
    case parentalGateOpen
    case parentalGateClose
    case parentalGateFail
    case parentalGateSuccess
    case dwellTime = "viewTime"
}
