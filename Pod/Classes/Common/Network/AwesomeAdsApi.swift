//
//  AwesomeAdsApi.swift
//  SuperAwesome
//
//  Created by Gunhan Sancar on 08/04/2020.
//

enum AwesomeAdsApi {
    case ad(placementId: Int, query: AdQuery)
    case adByPlacementLineAndCreativeId(placementId: Int, lineItemId: Int, creativeId: Int, query: AdQuery)
    case impression(query: EventQuery)
    case click(query: EventQuery)
    case videoClick(query: EventQuery)
    case event(query: EventQuery)
    case signature(lineItemId: Int, creativeId: Int)

    var path: String {
        switch self {
        case .ad(let placementId, _): return "/ad/\(placementId)"
        case .adByPlacementLineAndCreativeId(
            placementId: let placementId,
            lineItemId: let lineItemId,
            creativeId: let creativeId, _): return "/ad/\(placementId)/\(lineItemId)/\(creativeId)"
        case .impression: return "/impression"
        case .click: return "/click"
        case .videoClick: return "/video/click"
        case .event: return "/event"
        case .signature(let lineItemId, let creativeId): return "/skadnetwork/sign/\(lineItemId)/\(creativeId)"
        }
    }
}
