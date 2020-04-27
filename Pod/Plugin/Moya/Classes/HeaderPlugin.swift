//
//  HeaderPlugin.swift
//  SuperAwesome
//
//  Created by Gunhan Sancar on 08/04/2020.
//

import Moya

struct HeaderPlugin: PluginType {
    private let userAgent:String
    
    init(userAgent: String) {
        self.userAgent = userAgent
    }
    
    func prepare(_ request: URLRequest, target: TargetType) -> URLRequest {
        var request = request
        request.setValue(userAgent, forHTTPHeaderField: "User-Agent")
        return request
    }
}
