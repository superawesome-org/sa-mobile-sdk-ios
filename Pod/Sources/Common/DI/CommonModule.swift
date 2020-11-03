//
//  CommonModule.swift
//  SuperAwesome
//
//  Created by Gunhan Sancar on 03/11/2020.
//

struct CommonModule: DependencyModule {
    
    let configuration: Configuration
    
    func register(_ container: DependencyContainer) {
        registerComponentModule(container)
        registerRepositoryModule(container)
    }
    
    private func registerComponentModule(_ container: DependencyContainer) {
        container.factory(ViewableDetectorType.self) { c, param in
            ViewableDetector(logger: c.resolve(param: ViewableDetector.self)) }
        container.single(Bundle.self) { _,_  in Bundle.main }
        container.single(StringProviderType.self) { _,_  in StringProvider() }
        container.single(AdControllerType.self) { _, _ in AdController() }
        container.factory(ParentalGate.self) { c, _ in
            ParentalGate(numberGenerator: c.resolve(), stringProvider: c.resolve()) }
        container.factory(LoggerType.self) { _, param in
            OsLogger(configuration.logging, "\(param[0] ?? "")") }
        container.single(Environment.self) { _, _ in configuration.environment }
        container.single(ConnectionProviderType.self) { _, _ in ConnectionProvider() }
        container.single(DeviceType.self) { _, _ in Device(UIDevice.current) }
        container.single(EncoderType.self) { _, _ in Encoder() }
        container.single(IdGeneratorType.self) { c, _ in
            IdGenerator(preferencesRepository: c.resolve(),
                        sdkInfo: c.resolve(),
                        numberGenerator: c.resolve(),
                        dateProvider: c.resolve())
        }
        container.single(NumberGeneratorType.self) { _, _ in NumberGenerator() }
        container.single(SdkInfoType.self) { c, _ in
            SdkInfo(mainBundle: c.resolve(),
                    sdkBundle: Bundle(for: DependencyContainer.self),
                    locale: Locale.current,
                    encoder: c.resolve())
        }
        container.single(UserAgentProviderType.self) { c, _ in
            UserAgentProvider(device: c.resolve(), preferencesRepository: c.resolve())
        }
        container.single(AdQueryMakerType.self) { c, _ in
            AdQueryMaker(device: c.resolve(),
                         sdkInfo: c.resolve(),
                         connectionProvider: c.resolve(),
                         numberGenerator: c.resolve(),
                         idGenerator: c.resolve(),
                         encoder: c.resolve())
        }
        container.single(VastParserType.self) { c, _ in
            VastParser(connectionProvider: c.resolve())
        }
        container.single(AdProcessorType.self) { c, _ in
            AdProcessor(htmlFormatter: c.resolve(), vastParser: c.resolve(), networkDataSource: c.resolve(),
                        logger: c.resolve(param: AdProcessor.self))
        }
        container.single(HtmlFormatterType.self) { c, _ in
            HtmlFormatter(numberGenerator: c.resolve(), encoder: c.resolve())
        }
        container.single(ImageProviderType.self) { _, _ in ImageProvider() }
        container.single(OrientationProviderType.self) { c, _ in OrientationProvider(c.resolve()) }
        container.single(DateProviderType.self) { _, _ in  DateProvider() }
    }
    
    private func registerRepositoryModule(_ container: DependencyContainer) {
        container.single(PreferencesRepositoryType.self) { c, _ in
            PreferencesRepository(UserDefaults.standard)
        }
        container.single(AdRepositoryType.self) { c, _ in
            AdRepository(dataSource: c.resolve(), adQueryMaker: c.resolve(), adProcessor: c.resolve())
        }
        container.single(EventRepositoryType.self) { c, _ in
            EventRepository(dataSource: c.resolve(), adQueryMaker: c.resolve())
        }
        container.factory(VastEventRepositoryType.self) { c, param in
            VastEventRepository(adResponse: param[0] as! AdResponse,
                                networkDataSource: c.resolve(),
                                logger: c.resolve(param: VastEventRepository.self))
        }
    }
}
