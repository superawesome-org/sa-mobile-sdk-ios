//
//  ComponentModule.swift
//  SuperAwesome
//
//  Created by Gunhan Sancar on 04/04/2020.
//

@objc(SAComponentModuleType)
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
    var device: DeviceType { get }
    var userAgent: UserAgentType { get }
    var connectionManager: ConnectionManagerType { get }
    var adQueryMaker: AdQueryMakerType { get }
    var sdkInfo: SdkInfoType { get }
}

class ComponentModule: ComponentModuleType {
    lazy var connectionManager: ConnectionManagerType = ConnectionManager()
    lazy var device: DeviceType = Device(UIDevice.current)
    lazy var userAgent: UserAgentType = UserAgent(device: device, dataRepository: dataRepository)
    lazy var adQueryMaker: AdQueryMakerType = AdQueryMaker(device: device, sdkInfo: sdkInfo)
    lazy var sdkInfo: SdkInfoType = SdkInfo()
    
    private var dataRepository: DataRepositoryType
    
    init(dataRepository:DataRepositoryType) {
        self.dataRepository = dataRepository
    }
}
