//
//  File.swift
//  SuperAwesome
//
//  Created by Gunhan Sancar on 04/04/2020.
//

@objc(SAModuleContainerType)
@available(*, deprecated, message: "Will be deleted")
public protocol ModuleContainerType {
    @objc(componentModule)
    var componentModule: ComponentModuleObjcType { get }
    
    @objc(repositoryModule)
    var repositoryModule: RepositoryModuleObjcType { get }
}

@objc(SAModuleContainer)
public class ModuleContainer: NSObject, ModuleContainerType {
    lazy public var repositoryModule: RepositoryModuleObjcType = RepositoryModuleObjc()
    lazy public var componentModule: ComponentModuleObjcType = ComponentModuleObjc(dataRepository: repositoryModule.dataRepository)
}
