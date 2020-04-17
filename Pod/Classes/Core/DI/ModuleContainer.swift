//
//  File.swift
//  SuperAwesome
//
//  Created by Gunhan Sancar on 04/04/2020.
//

@objc(SAModuleContainerType)
public protocol ModuleContainerObjcType {
    @objc(componentModule)
    var componentModule: ComponentModuleObjcType { get }
    
    @objc(repositoryModule)
    var repositoryModule: RepositoryModuleObjcType { get }
}

@objc(SAModuleContainer)
public class ModuleContainerObjc: NSObject, ModuleContainerObjcType {
    lazy public var repositoryModule: RepositoryModuleObjcType = RepositoryModuleObjc()
    lazy public var componentModule: ComponentModuleObjcType = ComponentModuleObjc(dataRepository: repositoryModule.dataRepository)
}

// MARK: Swift only module container

protocol ModuleContainerType {
    var componentModule: ComponentModuleType { get }
    var repositoryModule: RepositoryModuleType { get }
    var networkModule: NetworkModuleType { get }
}

class ModuleContainer: ModuleContainerType {
    lazy public var repositoryModule: RepositoryModuleType =
        RepositoryModule(provider: networkModule.apiProvider, adQueryMaker: componentModule.adQueryMaker)
    lazy public var componentModule: ComponentModuleType = ComponentModule(dataRepository: repositoryModule.dataRepository)
    lazy public var networkModule: NetworkModuleType = NetworkModule(userAgent: componentModule.userAgent)
}
