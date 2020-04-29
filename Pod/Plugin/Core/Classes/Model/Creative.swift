//
//  Creative.swift
//  SuperAwesome
//
//  Created by Gunhan Sancar on 16/04/2020.
//

struct Creative: Codable {
    let id: Int
    let name: String?
    let format: CreativeFormatType
    let click_url: String
    let details: CreativeDetail
}

struct CreativeDetail: Codable {
    let url: String
    let image: String
    let video: String
    let placement_format: String
    let tag: String?
    let width: Int
    let height: Int
    let transcodedVideos: String?
    let duration: Int
    let vast: String?
}

enum CreativeFormatType: String, Codable {
    case video
    case image_with_link
    case tag
    case rich_media
}
