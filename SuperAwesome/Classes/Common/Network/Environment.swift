//
//  Environment.swift
//  SuperAwesome
//
//  Created by Gunhan Sancar on 08/04/2020.
//

public enum Environment: String, Codable {
    case production
    case staging
    case uitesting
}

extension Environment {
   var baseURL: URL {
        switch self {
        case .production: return URL(string: "https://ads.superawesome.tv/v2")!
        case .staging: return URL(string: "https://ads.staging.superawesome.tv/v2")!
        case .uitesting: return URL(string: "http://localhost:8080")!
        }
    }
}
