//
//  AwesomeAdsApi.swift
//  SuperAwesome
//
//  Created by Gunhan Sancar on 08/04/2020.
//

import Moya

enum AwesomeAdsApi {
    case ad(placementId: Int, query: AdQuery)
    case impression(request: ImpressionRequest)
    case click(request: ClickRequest)
    case videoClick(request: ClickRequest)
    case event(request: EventRequest)
}

extension AwesomeAdsApi: TargetType {
    
    var path: String {
        switch self {
        case .ad(let placementId, _): return "/ad/\(placementId)"
        case .impression: return "/impression"
        case .click: return "/click"
        case .videoClick: return "/video/click"
        case .event: return "/event"
        }
    }
    
    var method: Moya.Method { .get }
    
    var headers: [String : String]? { return ["Content-type": "application/json"] }
    
    var task: Task {
        switch self {
        case .ad(_,let query): return .requestParameters(parameters: query.toDictionary(), encoding: URLEncoding.queryString)
        case .impression(let request): return .requestParameters(parameters: request.toDictionary(), encoding: URLEncoding.queryString)
        case .click(let request): return .requestParameters(parameters: request.toDictionary(), encoding: URLEncoding.queryString)
        case .videoClick(let request): return .requestParameters(parameters: request.toDictionary(), encoding: URLEncoding.queryString)
        case .event(let request): return .requestParameters(parameters: request.toDictionary(), encoding: URLEncoding.queryString)
        }
    }
    
    var sampleData: Data { Data() }
    
    // baseURL is set using the environment in Target
    var baseURL: URL { Environment.staging.baseURL }
}
