//
//  NetworkModule.swift
//  SuperAwesome
//
//  Created by Gunhan Sancar on 08/04/2020.
//

import Moya

@objc(SANetworkModuleType)
public protocol NetworkModuleType {
    //var headerPlugin: HeaderPlugin { get }
    var apiProvider: AwesomeAdsApiProvider { get }
}

@objc(SANetworkModule)
class NetworkModule: NSObject, NetworkModuleType {
    var apiProvider: AwesomeAdsApiProvider
    
    //var headerPlugin: HeaderPlugin
    //var apiProvider: MoyaProvider<AwesomeAdsApi>

    init(userAgent: UserAgentType) {
        //let headerPlugin = HeaderPlugin(userAgent: userAgent.name)
        self.apiProvider = AwesomeAdsApiProvider(userAgent: userAgent)
    }
}

// TODO: Temporary class to overcome objc integration
@objc(SAAwesomeAdsApiProvider)
public class AwesomeAdsApiProvider: NSObject {
    var headerPlugin: HeaderPlugin
    var apiProvider: MoyaProvider<AwesomeAdsTarget>

    init(userAgent: UserAgentType) {
//        let endpointClosure = { (target: AwesomeAdsTarget) -> Endpoint in
//            let defaultEndpoint = MoyaProvider.defaultEndpointMapping(for: target)
//            return defaultEndpoint.adding(newHTTPHeaderFields: ["User-Agent" : userAgent.name])
//        }
        
        self.headerPlugin = HeaderPlugin(userAgent: userAgent.name)
        self.apiProvider = MoyaProvider<AwesomeAdsTarget>(plugins: [headerPlugin])
    }
}
