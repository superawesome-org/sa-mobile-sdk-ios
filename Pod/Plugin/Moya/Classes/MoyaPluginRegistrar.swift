//
//  MoyaPluginRegistrar.swift
//  SuperAwesome
//
//  Created by Gunhan Sancar on 27/04/2020.
//

import Moya

class MoyaPluginRegistrar {
    static func register(_ container: DependencyContainer) {
        container.registerFactory(MoyaHeaderPlugin.self) { c in
            MoyaHeaderPlugin(userAgentProvider: c.resolve() as UserAgentProvider)
        }
        container.registerSingle(MoyaProvider<AwesomeAdsTarget>.self) { c in
            MoyaProvider<AwesomeAdsTarget>(plugins:[c.resolve() as MoyaHeaderPlugin])
        }
        container.registerSingle(AdDataSourceType.self) { c in
            MoyaAdDataSource(c.resolve(), adQueryMaker: c.resolve())
        }
    }
}
