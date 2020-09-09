//
//  CreativeModels.swift
//  SuperAwesome
//
//  Created by Gunhan Sancar on 16/04/2020.
//

struct Creative: Codable {
    let id: Int
    let name: String?
    let format: CreativeFormatType
    let click_url: String?
    let details: CreativeDetail
    let bumper: Bool?
}

struct CreativeDetail: Codable {
    let url: String
    let image: String?
    let video: String
    let placement_format: String
    let tag: String?
    let width: Int
    let height: Int
    let duration: Int
    let vast: String?
}

enum CreativeFormatType: String, Codable, DecodableDefaultLastItem {
    case video
    case image_with_link
    case tag
    case rich_media
    case unknown
}
