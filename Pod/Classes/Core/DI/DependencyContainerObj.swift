//
//  Injectable.swift
//  SuperAwesome
//
//  Created by Gunhan Sancar on 06/04/2020.
//

@objc(SADependencyContainer)
@available(*, deprecated, message: "Will be deleted")
public class DependencyContainerObj: NSObject {
    @objc(shared)
    public private(set) static var shared: DependencyContainerObj!
    
    @objc(initModules:)
    public static func initModules(_ modules: ModuleContainerType) {
        shared = DependencyContainerObj(modules)
    }
    
    @objc(modules)
    public let moduleContainer: ModuleContainerType
    
    @objc(initWith:)
    public init(_ moduleContainer: ModuleContainerType) {
        self.moduleContainer = moduleContainer
    }
}
