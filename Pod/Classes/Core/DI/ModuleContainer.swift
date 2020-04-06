//
//  File.swift
//  SuperAwesome
//
//  Created by Gunhan Sancar on 04/04/2020.
//

@objc(SAModuleContainerType)
public protocol ModuleContainerType {
    @objc(componentModule) var componentModule: ComponentModuleType { get }
    var repositoryModule: RepositoryModuleType { get }
}

@objc(SAModuleContainer)
class ModuleContainer: NSObject, ModuleContainerType {
    lazy var repositoryModule: RepositoryModuleType = RepositoryModule()
    lazy var componentModule: ComponentModuleType = ComponentModule(dataRepository: repositoryModule.dataRepository)
}
