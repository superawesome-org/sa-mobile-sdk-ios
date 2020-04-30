//
//  AdModels.swift
//  SuperAwesome
//
//  Created by Gunhan Sancar on 15/04/2020.
//

struct Ad: Codable {
    let advertiserId: Int
    let publisherId: Int
    let moat: Float
    let is_fill: Bool
    let is_fallback: Bool
    let campaign_type: Int
    let is_house: Bool
    let safe_ad_approved: Bool
    let show_padlock: Bool
    let line_item_id: Int
    let test: Bool
    let app: Int
    let device: String
    let creative: Creative
}

struct AdQuery: Codable {
    let test: Bool
    let sdkVersion: String
    let rnd: Int
    let bundle: String
    let name: String
    let dauid: Int
    let ct: ConnectionType
    let lang: String
    let device: String
    let pos: Int
    let skip: Int
    let playbackmethod: Int
    let startdelay: Int
    let instl: Int
    let w: Int
    let h: Int
}

struct AdRequest: Codable {
    let environment: Environment
    let test: Bool
    let pos: Int
    let skip: Int
    let playbackmethod: Int
    let startdelay: Int
    let instl: Int
    let w: Int
    let h: Int
}
