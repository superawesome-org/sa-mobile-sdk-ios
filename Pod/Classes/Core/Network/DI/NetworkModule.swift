//
//  NetworkModule.swift
//  SuperAwesome
//
//  Created by Gunhan Sancar on 08/04/2020.
//

import Moya

protocol NetworkModuleType {
    var headerPlugin: HeaderPlugin { get }
    var apiProvider: MoyaProvider<AwesomeAdsTarget> { get }
}

class NetworkModule: NetworkModuleType {
    var headerPlugin: HeaderPlugin
    var apiProvider: MoyaProvider<AwesomeAdsTarget>

    init(userAgent: UserAgentType) {
        self.headerPlugin = HeaderPlugin(userAgent: userAgent.name)
        self.apiProvider = MoyaProvider<AwesomeAdsTarget>(plugins: [headerPlugin])
    }
}
