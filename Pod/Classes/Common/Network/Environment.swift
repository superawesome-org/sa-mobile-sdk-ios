//
//  Environment.swift
//  SuperAwesome
//
//  Created by Gunhan Sancar on 08/04/2020.
//

public enum Environment: String, Codable {
    case production
    case staging
}

extension Environment {
   var baseURL: URL {
        switch self {
        case .production: return URL(string: "https://eu-west-1-ads.superawesome.tv/v2")!
        case .staging: return URL(string: "https://us-east-1-ads.staging.superawesome.tv/v2")!
        }
    }
}
