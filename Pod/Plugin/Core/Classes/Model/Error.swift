//
//  Error.swift
//  SuperAwesome
//
//  Created by Gunhan Sancar on 08/07/2020.
//

enum AwesomeAdsError {
    case network
}

extension AwesomeAdsError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .network: return "Network error"
        }
    }
}
