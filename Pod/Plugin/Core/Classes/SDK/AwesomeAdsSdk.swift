//
//  AwesomeAdsSdk.swift
//  SuperAwesome
//
//  Created by Gunhan Sancar on 26/04/2020.
//


public class AwesomeAdsSdk {
    static let shared = AwesomeAdsSdk()
    
    private var container: DependencyContainer = DependencyContainer()
    private var initialised: Bool = false
    
    private func registerDependencies(_ configuration: Configuration) {
        self.container = DependencyContainer()
        container.registerSingle(Environment.self) { _ in configuration.environment }
        container.registerSingle(ConnectionProviderType.self) { _ in ConnectionProvider() }
        container.registerSingle(DeviceType.self) { _ in Device(UIDevice.current) }
        container.registerSingle(EncoderType.self) { _ in Encoder() }
        container.registerSingle(IdGeneratorType.self) { c in
            IdGenerator(preferencesRepository: c.resolve(),
                        sdkInfo: c.resolve(),
                        numberGenerator: c.resolve())
        }
        container.registerSingle(NumberGeneratorType.self) { _ in NumberGenerator() }
        container.registerSingle(SdkInfoType.self) { c in
            SdkInfo(mainBundle: Bundle.main,
                    sdkBundle: Bundle(for: DependencyContainer.self),
                    locale: Locale.current,
                    encoder: c.resolve())
        }
        container.registerSingle(DataRepositoryType.self) { c in
            DataRepository(UserDefaults.standard)
        }
        container.registerSingle(UserAgentProviderType.self) { c in
            UserAgentProvider(device: c.resolve(), preferencesRepository: c.resolve())
        }
        container.registerSingle(AdRepositoryType.self) { c in
            AdRepository(dataSource: c.resolve(), adQueryMaker: c.resolve(), adProcessor: c.resolve())
        }
        container.registerSingle(AdQueryMakerType.self) { c in
            AdQueryMaker(device: c.resolve(),
                         sdkInfo: c.resolve(),
                         connectionProvider: c.resolve(),
                         numberGenerator: c.resolve(),
                         idGenerator: c.resolve(),
                         encoder: c.resolve())
        }
        
        #if MOYA_PLUGIN
        MoyaPluginRegistrar.register(container)
        #endif
    }
    
    func initSdk(configuration: Configuration = Configuration(), completion: (()->())? = nil) {
        guard !initialised else { return }
        registerDependencies(configuration)
        initialised = true
        completion?()
    }
    
    public class Configuration {
        var environment = Environment.production
        var logging = false
        
        init(environment:Environment = .production) {
            self.environment = environment
        }
    }
}
