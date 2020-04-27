//
//  AwesomeAdsSdk.swift
//  SuperAwesome
//
//  Created by Gunhan Sancar on 26/04/2020.
//

public class AwesomeAdsSdk {
    static let shared = AwesomeAdsSdk()
    
    private let container: DependencyContainer
    
    init() {
        self.container = DependencyContainer()
        container.registerSingle(ConnectionManagerType.self) { _ in ConnectionManager() }
        container.registerSingle(DeviceType.self) { _ in Device(UIDevice.current) }
        container.registerSingle(EncoderType.self) { _ in Encoder() }
        container.registerSingle(IdGeneratorType.self) { _ in IdGenerator() }
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
        container.registerSingle(UserAgentType.self) { c in
            UserAgent(device: c.resolve(), dataRepository: c.resolve())
        }
        container.registerSingle(AdRepositoryType.self) { c in
            AdRepository(c.resolve())
        }
        
        #if MOYA_PLUGIN
        MoyaPluginRegistrar.register(container)
        #endif
    }
}
