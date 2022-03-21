//
//  CreativeModels.swift
//  SuperAwesome
//
//  Created by Gunhan Sancar on 16/04/2020.
//

public struct Creative: Codable {
    let id: Int
    let name: String?
    let format: CreativeFormatType
    let clickUrl: String?
    let details: CreativeDetail
    let bumper: Bool?

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case format
        case clickUrl = "click_url"
        case details
        case bumper
        }
}

struct CreativeDetail: Codable {
    let url: String?
    let image: String?
    let video: String?
    let placementFormat: String
    let tag: String?
    let width: Int
    let height: Int
    let duration: Int
    let vast: String?

    enum CodingKeys: String, CodingKey {
        case url
        case image
        case video
        case placementFormat = "placement_format"
        case tag
        case width
        case height
        case duration
        case vast
        }
}

enum CreativeFormatType: String, Codable, DecodableDefaultLastItem {
    case video
    case imageWithLink = "image_with_link"
    case tag
    case richMedia = "rich_media"
    case unknown
}
