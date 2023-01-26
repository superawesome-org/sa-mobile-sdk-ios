//
//  FeatureType.swift
//  AwesomeAdsSDKKitchenSink
//
//  Created by Myles Eynon on 18/01/2023.
//

import Foundation

enum FeatureType {
    case banner
    case interstial
    case video

    var title: String {
        var type = ""
        switch self {
        case .interstial:
            type = "Interstital"
        case .video:
            type = "Video"
        default:
            type = "Banner"
        }
        return type
    }
}
