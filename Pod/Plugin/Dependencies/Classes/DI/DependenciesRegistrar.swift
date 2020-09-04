//
//  MoyaPluginRegistrar.swift
//  SuperAwesome
//
//  Created by Gunhan Sancar on 27/04/2020.
//

import Moya

class DependenciesRegistrar {
    static func register(_ container: DependencyContainer) {
        container.registerSingle(VastParserType.self) { c, _ in
            VastParser(connectionProvider: c.resolve())
        }
        container.registerFactory(MoyaHeaderPlugin.self) { c, _ in
            MoyaHeaderPlugin(userAgentProvider: c.resolve() as UserAgentProviderType)
        }
        container.registerSingle(MoyaProvider<AwesomeAdsTarget>.self) { c, _ in
            MoyaProvider<AwesomeAdsTarget>(plugins:[c.resolve() as MoyaHeaderPlugin])
        }
        container.registerSingle(AwsomeAdsDataSourceType.self) { c, _ in
            MoyaAdDataSource(provider: c.resolve(), environment: c.resolve())
        }
        container.registerSingle(NetworkDataSourceType.self) { c, _ in
            AFNetworkDataSource()
        }
    }
}
