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
    
    var path: String {
        switch self {
        case .ad(let placementId, _): return "/ad/\(placementId)"
        case .impression: return "/impression"
        case .click: return "/click"
        case .videoClick: return "/video/click"
        case .event: return "/event"
        }
    }
}
