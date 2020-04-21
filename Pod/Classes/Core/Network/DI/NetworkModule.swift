//
//  NetworkModule.swift
//  SuperAwesome
//
//  Created by Gunhan Sancar on 08/04/2020.
//

import Moya

protocol NetworkModuleType {
    func resolve() -> MoyaProvider<AwesomeAdsTarget>
    func resolve() -> AdQueryMakerType
}

class NetworkModule: NetworkModuleType {
    private var componentModule: ComponentModuleType
    private lazy var userAgent: UserAgentType = componentModule.resolve()
    private lazy var headerPlugin: PluginType = HeaderPlugin(userAgent: userAgent.name)
    private lazy var apiProvider: MoyaProvider<AwesomeAdsTarget> = MoyaProvider<AwesomeAdsTarget>(plugins: [headerPlugin])
    private lazy var adQueryMaker: AdQueryMakerType = AdQueryMaker(device: componentModule.resolve(),
                                                                   sdkInfo: componentModule.resolve(),
                                                                   connectionManager: componentModule.resolve(),
                                                                   numberGenerator: componentModule.resolve(),
                                                                   idGenerator: componentModule.resolve())
    
    init(_ componentModule: ComponentModuleType) {
        self.componentModule = componentModule
    }
    
    func resolve() -> MoyaProvider<AwesomeAdsTarget> { apiProvider }
    func resolve() -> AdQueryMakerType { adQueryMaker }
}
