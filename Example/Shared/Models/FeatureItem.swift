//
//  FeatureItem.swift
//  AwesomeAdsSDKKitchenSink
//
//  Created by Myles Eynon on 19/01/2023.
//

import Foundation

struct FeatureItem: Identifiable, Hashable, Codable {

    let id = UUID()
    let type: FeatureType
    let placements: [PlacementItem]
}
