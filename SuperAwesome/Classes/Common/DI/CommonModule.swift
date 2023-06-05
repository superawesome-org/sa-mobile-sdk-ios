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
        container.single(Bundle.self) { _, _  in Bundle.main }
        container.single(StringProviderType.self) { _, _  in StringProvider() }
        container.factory(LoggerType.self) { _, param in
            OsLogger(configuration.logging, "\(param[0] ?? "")") }
        container.single(Environment.self) { _, _ in configuration.environment }
        container.single(ConnectionProviderType.self) { _, _ in ConnectionProvider() }
        container.single(DeviceType.self) { _, _ in Device(UIDevice.current) }
        container.single(EncoderType.self) { _, _ in CustomEncoder() }
        container.single(IdGeneratorType.self) { container, _ in
            IdGenerator(preferencesRepository: container.resolve(),
                        sdkInfo: container.resolve(),
                        numberGenerator: container.resolve(),
                        dateProvider: container.resolve())
        }
        container.single(NumberGeneratorType.self) { _, _ in NumberGenerator() }
        container.single(SdkInfoType.self) { container, _ in
            SdkInfo(mainBundle: container.resolve(),
                    locale: Locale.current,
                    encoder: container.resolve())
        }
        container.single(UserAgentProviderType.self) { container, _ in
            UserAgentProvider(device: container.resolve(), preferencesRepository: container.resolve())
        }
        container.single(AdQueryMakerType.self) { container, _ in
            AdQueryMaker(device: container.resolve(),
                         sdkInfo: container.resolve(),
                         connectionProvider: container.resolve(),
                         numberGenerator: container.resolve(),
                         idGenerator: container.resolve(),
                         encoder: container.resolve(),
                         options: configuration.options)
        }
        container.single(VastParserType.self) { container, _ in
            VastParser(connectionProvider: container.resolve())
        }
        container.single(AdProcessorType.self) { container, _ in
            AdProcessor(htmlFormatter: container.resolve(),
                        vastParser: container.resolve(),
                        networkDataSource: container.resolve(),
                        logger: container.resolve(param: AdProcessor.self))
        }
        container.single(HtmlFormatterType.self) { container, _ in
            HtmlFormatter(numberGenerator: container.resolve(), encoder: container.resolve())
        }
        container.single(ImageProviderType.self) { _, _ in ImageProvider() }
        container.single(OrientationProviderType.self) { container, _ in OrientationProvider(container.resolve()) }
        container.single(DateProviderType.self) { _, _ in  DateProvider() }
        container.single(TimeProviderType.self) { _, _ in  TimeProvider() }
        if #available(iOS 14.5, *) {
            container.single(SKAdNetworkManager.self) {container, _ in
                SKAdNetworkManagerImpl(repository: container.resolve())
            }
        }
    }

    private func registerRepositoryModule(_ container: DependencyContainer) {
        container.single(PreferencesRepositoryType.self) { _, _ in
            PreferencesRepository(UserDefaults.standard)
        }
        container.single(AdRepositoryType.self) { container, _ in
            AdRepository(dataSource: container.resolve(),
                         adQueryMaker: container.resolve(),
                         adProcessor: container.resolve())
        }
        container.single(EventRepositoryType.self) { container, _ in
            EventRepository(dataSource: container.resolve(),
                            adQueryMaker: container.resolve(),
                            logger: container.resolve(param: EventRepository.self))
        }
        container.factory(VastEventRepositoryType.self) { container, param in
            guard let adResponse = param[0] as?  AdResponse else {
                fatalError()
            }
            return VastEventRepository(adResponse: adResponse,
                                networkDataSource: container.resolve(),
                                logger: container.resolve(param: VastEventRepository.self))
        }
        container.single(PerformanceRepositoryType.self) { container, _ in
            PerformanceRepository(dataSource: container.resolve(),
                            logger: container.resolve(param: PerformanceRepository.self))
        }
    }
}
