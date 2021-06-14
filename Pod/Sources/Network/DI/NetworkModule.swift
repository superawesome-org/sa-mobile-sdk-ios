//
//  MoyaPluginRegistrar.swift
//  SuperAwesome
//
//  Created by Gunhan Sancar on 27/04/2020.
//

class NetworkModule: DependencyModule {
    func register(_ container: DependencyContainer) {
        container.single(AwesomeAdsApiDataSourceType.self) { cont, _ in
            UrlSessionAwesomeAdsDataSource(environment: cont.resolve(),
                                           userAgentProvider: container.resolve() as UserAgentProviderType)
        }
        container.single(NetworkDataSourceType.self) { container, _ in
            UrlSessionDataSource(userAgentProvider: container.resolve() as UserAgentProviderType)
        }
    }
}
