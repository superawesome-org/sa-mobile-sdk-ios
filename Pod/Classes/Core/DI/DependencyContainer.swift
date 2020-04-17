//
//  Injectable.swift
//  SuperAwesome
//
//  Created by Gunhan Sancar on 06/04/2020.
//

@objc(SADependencyContainer)
public class DependencyContainer: NSObject {
    @objc(shared)
    public private(set) static var shared: DependencyContainer!
    
    @objc(initModules:)
    public static func initModules(_ modules: ModuleContainerObjcType) {
        shared = DependencyContainer(modules)
    }
    
    @objc(modules)
    public let moduleContainer: ModuleContainerObjcType
    
    @objc(initWith:)
    public init(_ moduleContainer: ModuleContainerObjcType) {
        self.moduleContainer = moduleContainer
    }
}

//@objc(SAInjectable)
//public protocol Injectable {
//    @objc(dependencies)
//    var dependencies: ModuleContainerType { get }
//}
//
//extension Injectable {
//    var dependencies: ModuleContainerType { DependencyContainer.shared.moduleContainer }
//}
