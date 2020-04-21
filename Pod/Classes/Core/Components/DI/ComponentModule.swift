//
//  ComponentModule.swift
//  SuperAwesome
//
//  Created by Gunhan Sancar on 04/04/2020.
//

@objc(SAComponentModuleType)
@available(*, deprecated, message: "Will be deleted")
public protocol ComponentModuleObjcType {
    var device: DeviceType { get }
    @objc(userAgent) var userAgent: UserAgentType { get }
}

class ComponentModuleObjc: ComponentModuleObjcType {
    private var dataRepository: DataRepositoryType
    
    lazy var device: DeviceType = Device(UIDevice.current)
    lazy var userAgent: UserAgentType = UserAgent(device: device, dataRepository: dataRepository)
    
    init(dataRepository:DataRepositoryType) {
        self.dataRepository = dataRepository
    }
}

protocol ComponentModuleType {
    func resolve() -> DeviceType
    func resolve() -> UserAgentType
    func resolve() -> ConnectionManagerType
    func resolve() -> AdQueryMakerType
    func resolve() -> SdkInfoType
    func resolve() -> NumberGeneratorType
    func resolve() -> IdGeneratorType
    func resolve() -> EncoderType
}

class ComponentModule: ComponentModuleType, Injectable {
    private lazy var repositoryModule: RepositoryModuleType = dependencies.resolve()
    private lazy var connectionManager: ConnectionManagerType = ConnectionManager()
    private lazy var device: DeviceType = Device(UIDevice.current)
    private lazy var userAgent: UserAgentType = UserAgent(device: resolve(),
                                                          dataRepository: repositoryModule.resolve())
    private lazy var adQueryMaker: AdQueryMakerType = AdQueryMaker(device: resolve(),
                                                                   sdkInfo: resolve(),
                                                                   connectionManager: resolve(),
                                                                   numberGenerator: resolve(),
                                                                   idGenerator: resolve())
    private lazy var sdkInfo: SdkInfoType = SdkInfo(mainBundle: Bundle.main,
                                                    sdkBundle: Bundle(for: ComponentModule.self),
                                                    encoder: resolve())
    private lazy var numberGenerator: NumberGeneratorType = NumberGenerator()
    private lazy var idGenerator: IdGeneratorType = IdGenerator()
    private lazy var encoder: EncoderType = Encoder()
    
    func resolve() -> DeviceType { device }
    func resolve() -> UserAgentType { userAgent }
    func resolve() -> ConnectionManagerType { connectionManager }
    func resolve() -> AdQueryMakerType { adQueryMaker }
    func resolve() -> SdkInfoType { sdkInfo }
    func resolve() -> NumberGeneratorType { numberGenerator }
    func resolve() -> IdGeneratorType { idGenerator }
    func resolve() -> EncoderType { encoder }
}
