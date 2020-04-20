//
//  NetworkModule.swift
//  SuperAwesome
//
//  Created by Gunhan Sancar on 08/04/2020.
//

import Moya

protocol NetworkModuleType {
    func resolve() -> MoyaProvider<AwesomeAdsTarget>
}

class NetworkModule: NetworkModuleType, Injectable {
    private lazy var userAgent: UserAgentType = (dependencies.resolve() as ComponentModuleType).resolve()
    private lazy var headerPlugin: PluginType = HeaderPlugin(userAgent: userAgent.name)
    private lazy var apiProvider: MoyaProvider<AwesomeAdsTarget> = MoyaProvider<AwesomeAdsTarget>(plugins: [headerPlugin])
    
    func resolve() -> MoyaProvider<AwesomeAdsTarget> { apiProvider }
}
