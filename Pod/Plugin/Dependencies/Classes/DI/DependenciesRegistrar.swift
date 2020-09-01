//
//  MoyaPluginRegistrar.swift
//  SuperAwesome
//
//  Created by Gunhan Sancar on 27/04/2020.
//

import Moya

class DependenciesRegistrar {
    static func register(_ container: DependencyContainer) {
        container.registerSingle(VastParserType.self) { c in
            VastParser(connectionProvider: c.resolve())
        }
        container.registerFactory(MoyaHeaderPlugin.self) { c in
            MoyaHeaderPlugin(userAgentProvider: c.resolve() as UserAgentProviderType)
        }
        container.registerSingle(MoyaProvider<AwesomeAdsTarget>.self) { c in
            MoyaProvider<AwesomeAdsTarget>(plugins:[c.resolve() as MoyaHeaderPlugin])
        }
        container.registerSingle(AdDataSourceType.self) { c in
            MoyaAdDataSource(provider: c.resolve(), environment: c.resolve())
        }
        container.registerSingle(NetworkDataSourceType.self) { c in
            AFNetworkDataSource()
        }
    }
}
