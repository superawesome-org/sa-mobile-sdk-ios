//
//  CreativeModels.swift
//  SuperAwesome
//
//  Created by Gunhan Sancar on 16/04/2020.
//

public struct Creative: Codable {
    public let id: Int
    let name: String?
    let format: CreativeFormatType
    let clickUrl: String?
    let details: CreativeDetail
    let bumper: Bool?
    public let payload: String?

    public init(id: Int) {
        self.id = id
        self.name = ""
        self.format = .imageWithLink
        self.clickUrl = nil
        self.details = CreativeDetail(url: "", image: nil, video: "", placementFormat: "", tag: nil, width: 0, height: 0, duration: 0, vast: nil)
        self.bumper = false
        self.payload = nil
    }

    init(id: Int, name: String?, format: CreativeFormatType, clickUrl: String?, details: CreativeDetail, bumper: Bool, payload: String?) {
        self.id = id
        self.name = name
        self.format = format
        self.clickUrl = clickUrl
        self.details = details
        self.bumper = bumper
        self.payload = payload
    }

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case format
        case clickUrl = "click_url"
        case details
        case bumper
        case payload
        }
}

struct CreativeDetail: Codable {
    let url: String
    let image: String?
    let video: String
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
