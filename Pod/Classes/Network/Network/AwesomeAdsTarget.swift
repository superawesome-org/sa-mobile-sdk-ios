//
//  DynamicTarget.swift
//  SuperAwesome
//
//  Created by Gunhan Sancar on 08/04/2020.
//

import Moya

struct AwesomeAdsTarget: TargetType {
    let environment: Environment
    let target: TargetType

    init(_ environment: Environment, _ target: AwesomeAdsApi) {
        self.environment = environment
        self.target = target
    }

    var baseURL: URL { environment.baseURL }
    var path: String { target.path }
    var method: Moya.Method { target.method }
    var sampleData: Data { target.sampleData }
    var task: Task { target.task }
    var headers: [String: String]? { target.headers }
}

extension AwesomeAdsApi: TargetType {
    var method: Moya.Method { .get }

    var headers: [String: String]? { return ["Content-type": "application/json"] }

    var task: Task {
        switch self {
        case .ad(_, let query):
            return .requestParameters(parameters: query.toDictionary(), encoding: URLEncoding.queryString)
        case .adByLineAndCreativeId(lineItemId: _, creativeId: _, let query):
            return .requestParameters(parameters: query.toDictionary(), encoding: URLEncoding.queryString)
        case .impression(let query):
            return .requestParameters(parameters: query.toDictionary(), encoding: URLEncoding.queryString)
        case .click(let query):
            return .requestParameters(parameters: query.toDictionary(), encoding: URLEncoding.queryString)
        case .videoClick(let query):
            return .requestParameters(parameters: query.toDictionary(), encoding: URLEncoding.queryString)
        case .event(let query):
            return .requestParameters(parameters: query.toDictionary(), encoding: URLEncoding.queryString)
        case .signature:
            return .requestParameters(parameters: [:], encoding: URLEncoding.queryString)
        }
    }

    var sampleData: Data { Data() }

    // baseURL is set using the environment in Target
    var baseURL: URL { Environment.staging.baseURL }
}
