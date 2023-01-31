//
//  FeatureType.swift
//  AwesomeAdsSDKKitchenSink
//
//  Created by Myles Eynon on 18/01/2023.
//

import Foundation

enum FeatureType: String {
    case banner
    case interstial
    case video

    var title: String {
        rawValue.capitalized
    }
}
