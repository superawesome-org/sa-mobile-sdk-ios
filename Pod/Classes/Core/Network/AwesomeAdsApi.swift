//
//  AwesomeAdsApi.swift
//  SuperAwesome
//
//  Created by Gunhan Sancar on 08/04/2020.
//

import Moya

enum AwesomeAdsApi {
    case ad(placementId: Int)
    case impression
    case click
    case videoClick
    case event
}

extension AwesomeAdsApi: TargetType {
    var path: String {
        switch self {
        case .ad: return "/ad"
        case .impression: return "/impression"
        case .click: return "/click"
        case .videoClick: return "/video/click"
        case .event: return "/event"
        }
    }
    
    var method: Moya.Method { .get }
    
    var sampleData: Data {
        switch self {
        case .ad: return "".utf8Encoded
        case .impression: return "".utf8Encoded
        case .click: return "".utf8Encoded
        case .videoClick: return "".utf8Encoded
        case .event: return "".utf8Encoded
        }
    }
    
    var task: Task {
        switch self {
        case .ad: return .requestParameters(parameters: ["String" : "Any"], encoding: URLEncoding.queryString)
        case .impression: return .requestParameters(parameters: ["String" : "Any"], encoding: URLEncoding.queryString)
        case .click: return .requestParameters(parameters: ["String" : "Any"], encoding: URLEncoding.queryString)
        case .videoClick: return .requestParameters(parameters: ["String" : "Any"], encoding: URLEncoding.queryString)
        case .event: return .requestParameters(parameters: ["String" : "Any"], encoding: URLEncoding.queryString)
        }
    }
    
    var headers: [String : String]? { return ["Content-type": "application/json"] }
    
    // baseURL is set using the environement in Target
    var baseURL: URL { URL(string: "")! }
}
