//
//  CreativeModels.swift
//  SuperAwesome
//
//  Created by Gunhan Sancar on 16/04/2020.
//

public struct Creative: Codable {
    public let id: Int
    public let name: String?
    public let format: CreativeFormatType
    public let clickUrl: String?
    public let details: CreativeDetail
    public let bumper: Bool?
    public let payload: String?

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case format
        case clickUrl = "click_url"
        case details
        case bumper
        case payload = "customPayload"
    }
}

public struct CreativeDetail: Codable {
    public let url: String?
    public let image: String?
    public let video: String?
    public let placementFormat: String
    public let tag: String?
    public let width: Int
    public let height: Int
    public let duration: Int
    public let vast: String?

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

public enum CreativeFormatType: String, Codable, DecodableDefaultLastItem {
    case video
    case imageWithLink = "image_with_link"
    case tag
    case richMedia = "rich_media"
    case unknown
}
