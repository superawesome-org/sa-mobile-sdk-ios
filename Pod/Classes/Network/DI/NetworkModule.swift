//
//  MoyaPluginRegistrar.swift
//  SuperAwesome
//
//  Created by Gunhan Sancar on 27/04/2020.
//

import Moya

class NetworkModule: DependencyModule {
    func register(_ container: DependencyContainer) {
        container.factory(MoyaLoggerPlugin.self) { cont, _ in
            MoyaLoggerPlugin(logger: cont.resolve(param: MoyaLoggerPlugin.self) as LoggerType)
        }
        container.factory(MoyaHeaderPlugin.self) { cont, _ in
            MoyaHeaderPlugin(userAgentProvider: cont.resolve() as UserAgentProviderType)
        }
        container.single(MoyaProvider<AwesomeAdsTarget>.self) { cont, _ in
            MoyaProvider<AwesomeAdsTarget>(plugins: [cont.resolve() as MoyaHeaderPlugin,
                                                     cont.resolve() as MoyaLoggerPlugin])
        }
        container.single(AwesomeAdsApiDataSourceType.self) { cont, _ in
            MoyaAwesomeAdsApiDataSource(provider: cont.resolve(), environment: cont.resolve())
        }
        container.single(NetworkDataSourceType.self) { _, _ in
            AFNetworkDataSource()
        }
    }
}
