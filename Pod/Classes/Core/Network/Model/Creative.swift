//
//  Creative.swift
//  SuperAwesome
//
//  Created by Gunhan Sancar on 16/04/2020.
//

@objc(SACreative2)
class Creative: NSObject, Codable {
    let id: Int
    let format: String
    let click_url: String
    let details: CreativeDetail
}

@objc(SACreativeDetail2)
class CreativeDetail: NSObject, Codable {
    let url: String
    let image: String
    let video: String
    let placement_format: String
    let tag: String?
    let width: Int
    let height: Int
    let transcodedVideos: String?
    let duration: Int
    let vast: String
}
