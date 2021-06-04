//
//  MoyaHeaderPlugin.swift
//  SuperAwesome
//
//  Created by Gunhan Sancar on 08/04/2020.
//

import Moya

struct MoyaHeaderPlugin: PluginType {
    private let userAgent: String

    init(userAgentProvider: UserAgentProviderType) {
        self.userAgent = userAgentProvider.name
    }

    func prepare(_ request: URLRequest, target: TargetType) -> URLRequest {
        var request = request
        request.setValue(userAgent, forHTTPHeaderField: "User-Agent")
        return request
    }
}
