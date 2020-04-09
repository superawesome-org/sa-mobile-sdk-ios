//
//  File.swift
//  SuperAwesome
//
//  Created by Gunhan Sancar on 04/04/2020.
//

@objc(SAModuleContainerType)
public protocol ModuleContainerType {
    @objc(componentModule)
    var componentModule: ComponentModuleType { get }
    
    @objc(repositoryModule)
    var repositoryModule: RepositoryModuleType { get }
    
    @objc(networkModule)
    var networkModule: NetworkModuleType { get }
}

@objc(SAModuleContainer)
public class ModuleContainer: NSObject, ModuleContainerType {
    lazy public var repositoryModule: RepositoryModuleType = RepositoryModule()
    lazy public var componentModule: ComponentModuleType = ComponentModule(dataRepository: repositoryModule.dataRepository)
    lazy public var networkModule: NetworkModuleType = NetworkModule(userAgent: componentModule.userAgent)
}
