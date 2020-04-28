//
//  Ad.swift
//  SuperAwesome
//
//  Created by Gunhan Sancar on 16/04/2020.
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
