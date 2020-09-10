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
    
    private func registerComponentModule(_ configuration: Configuration) {
        container.registerFactory(ViewableDetectorType.self) { c, param in
            ViewableDetector(logger: c.resolve(param: ViewableDetector.self)) }
        container.registerSingle(Bundle.self) { _,_  in Bundle.main }
        container.registerSingle(StringProviderType.self) { _,_  in StringProvider() }
        container.registerFactory(AdControllerType.self) { _, _ in AdController() }
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
            SdkInfo(mainBundle: c.resolve(),
                    sdkBundle: Bundle(for: DependencyContainer.self),
                    locale: Locale.current,
                    encoder: c.resolve())
        }
        container.registerSingle(UserAgentProviderType.self) { c, _ in
            UserAgentProvider(device: c.resolve(), preferencesRepository: c.resolve())
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
            AdProcessor(htmlFormatter: c.resolve(), vastParser: c.resolve(), networkDataSource: c.resolve(),
                        logger: c.resolve(param: AdProcessor.self))
        }
        container.registerSingle(HtmlFormatterType.self) { c, _ in
            HtmlFormatter(numberGenerator: c.resolve(), encoder: c.resolve())
        }
        container.registerSingle(ImageProviderType.self) { _, _ in ImageProvider() }
        container.registerSingle(OrientationProviderType.self) { c, _ in OrientationProvider(c.resolve()) }
    }
    
    private func registerRepositoryModule() {
        container.registerSingle(PreferencesRepositoryType.self) { c, _ in
            PreferencesRepository(UserDefaults.standard)
        }
        container.registerSingle(AdRepositoryType.self) { c, _ in
            AdRepository(dataSource: c.resolve(), adQueryMaker: c.resolve(), adProcessor: c.resolve())
        }
        container.registerSingle(EventRepositoryType.self) { c, _ in
            EventRepository(dataSource: c.resolve(), adQueryMaker: c.resolve())
        }
        container.registerFactory(VastEventRepositoryType.self) { c, param in
            VastEventRepository(adResponse: param as! AdResponse,
                                networkDataSource: c.resolve(),
                                logger: c.resolve(param: VastEventRepository.self))
        }
    }
    
    private func registerDependencies(_ configuration: Configuration) {
        self.container = DependencyContainer()
        
        registerComponentModule(configuration)
        registerRepositoryModule()
        
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
    var dependencies: DependencyContainer { AwesomeAdsSdk.shared.container }
    static var dependencies: DependencyContainer { AwesomeAdsSdk.shared.container }
}
