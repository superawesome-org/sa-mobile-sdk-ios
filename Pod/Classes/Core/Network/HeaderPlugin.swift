//
//  HeaderPlugin.swift
//  SuperAwesome
//
//  Created by Gunhan Sancar on 08/04/2020.
//

import Moya

/*
 A plugin for adding user-agent headers to requests.
 */
public struct HeaderPlugin: PluginType {
    private let userAgent:String
    
    init(userAgent: String) {
        self.userAgent = userAgent
    }
    
    /*
     Prepares a request by adding a user-agent header
     */
    public func prepare(_ request: URLRequest, target: TargetType) -> URLRequest {
        var request = request
        request.setValue(userAgent, forHTTPHeaderField: "User-Agent")
        
        return request
    }
}
