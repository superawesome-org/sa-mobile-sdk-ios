//
//  Error.swift
//  SuperAwesome
//
//  Created by Gunhan Sancar on 08/07/2020.
//

enum AwesomeAdsError {
    case network
    case fileInvalid
    case jsonNotFound(json: String, endPoint: String)
}

extension AwesomeAdsError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .network: return "Network error"
        case .fileInvalid: return "File error: Invalid format"
        case .jsonNotFound(json: let json, let endPoint): return "could not pass \(json) from \(endPoint)"
        }
    }
}
