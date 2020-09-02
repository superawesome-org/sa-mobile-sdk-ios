//
//  AwesomeAdsSdk.swift
//  SuperAwesome
//
//  Created by Gunhan Sancar on 26/04/2020.
//

import AdSupport

@objc
public class AwesomeAdsSdk: NSObject {
    public static let shared = AwesomeAdsSdk()
    
    private(set) var container: DependencyContainer = DependencyContainer()
    private var initialised: Bool = false
    
    private func registerDependencies(_ configuration: Configuration) {
        self.container = DependencyContainer()
        container.registerSingle(StringProviderType.self) { _,_  in StringProvider() }
        container.registerFactory(ParentalGate.self) { c, _ in
            ParentalGate(numberGenerator: c.resolve(), stringProvider: c.resolve()) }
        container.registerFactory(LoggerType.self) { _, param in
            OsLogger(configuration.logging, "\(param ?? "")") }
        container.registerSingle(Environment.self) { _, _ in configuration.environment }
        container.registerSingle(ConnectionProviderType.self) { _, _ in ConnectionProvider() }
        container.registerSingle(DeviceType.self) { _, _ in Device(UIDevice.current) }
        container.registerSingle(EncoderType.self) { _, _ in Encoder() }
        container.registerSingle(IdGeneratorType.self) { c, _ in
            IdGenerator(preferencesRepository: c.resolve(),
                        sdkInfo: c.resolve(),
                        numberGenerator: c.resolve(),
                        identifierManager: ASIdentifierManager.shared())
        }
        container.registerSingle(NumberGeneratorType.self) { _, _ in NumberGenerator() }
        container.registerSingle(SdkInfoType.self) { c, _ in
            SdkInfo(mainBundle: Bundle.main,
                    sdkBundle: Bundle(for: DependencyContainer.self),
                    locale: Locale.current,
                    encoder: c.resolve())
        }
        container.registerSingle(PreferencesRepositoryType.self) { c, _ in
            PreferencesRepository(UserDefaults.standard)
        }
        container.registerSingle(UserAgentProviderType.self) { c, _ in
            UserAgentProvider(device: c.resolve(), preferencesRepository: c.resolve())
        }
        container.registerSingle(AdRepositoryType.self) { c, _ in
            AdRepository(dataSource: c.resolve(), adQueryMaker: c.resolve(), adProcessor: c.resolve())
        }
        container.registerSingle(EventRepositoryType.self) { c, _ in
            EventRepository(dataSource: c.resolve(), adQueryMaker: c.resolve())
        }
        container.registerSingle(AdQueryMakerType.self) { c, _ in
            AdQueryMaker(device: c.resolve(),
                         sdkInfo: c.resolve(),
                         connectionProvider: c.resolve(),
                         numberGenerator: c.resolve(),
                         idGenerator: c.resolve(),
                         encoder: c.resolve())
        }
        container.registerSingle(AdProcessorType.self) { c, _ in
            AdProcessor(htmlFormatter: c.resolve(), vastParser: c.resolve(), networkDataSource: c.resolve())
        }
        container.registerSingle(HtmlFormatterType.self) { c, _ in
            HtmlFormatter(numberGenerator: c.resolve(), encoder: c.resolve())
        }
        container.registerSingle(ImageProviderType.self) { _, _ in ImageProvider() }
        #if DEPENDENCIES_PLUGIN
        DependenciesRegistrar.register(container)
        #endif
    }
    
    public func initSdk(configuration: Configuration = Configuration(), completion: (()->())? = nil) {
        guard !initialised else { return }
        registerDependencies(configuration)
        initialised = true
        completion?()
    }
    
    public class Configuration {
        var environment = Environment.production
        var logging = false
        
        public init(environment: Environment = .production, logging: Bool = false) {
            self.environment = environment
            self.logging = logging
        }
    }
}

extension Injectable {
    var dependencies: DependencyContainer {
        return AwesomeAdsSdk.shared.container
    }
}
