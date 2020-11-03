//
//  MoyaPluginRegistrar.swift
//  SuperAwesome
//
//  Created by Gunhan Sancar on 27/04/2020.
//

import Moya

class NetworkModule: DependencyModule {
    func register(_ container: DependencyContainer) {
        container.factory(MoyaHeaderPlugin.self) { c, _ in
            MoyaHeaderPlugin(userAgentProvider: c.resolve() as UserAgentProviderType)
        }
        container.single(MoyaProvider<AwesomeAdsTarget>.self) { c, _ in
            MoyaProvider<AwesomeAdsTarget>(plugins:[c.resolve() as MoyaHeaderPlugin])
        }
        container.single(AwesomeAdsApiDataSourceType.self) { c, _ in
            MoyaAwesomeAdsApiDataSource(provider: c.resolve(), environment: c.resolve())
        }
        container.single(NetworkDataSourceType.self) { c, _ in
            AFNetworkDataSource()
        }
    }
}
