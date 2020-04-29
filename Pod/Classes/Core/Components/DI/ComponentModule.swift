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
