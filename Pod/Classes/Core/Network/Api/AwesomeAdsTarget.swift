//
//  DynamicTarget.swift
//  SuperAwesome
//
//  Created by Gunhan Sancar on 08/04/2020.
//

import Moya

/*
 Helper class to dynamically set the baseURL for the MoyaProvider
 */
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
    var headers: [String : String]? { target.headers }
}

extension Environment {
    /// Factory method to make an AwesomeAdsTarget object
    func make(_ target: AwesomeAdsApi) -> AwesomeAdsTarget { AwesomeAdsTarget(self, target) }
}
