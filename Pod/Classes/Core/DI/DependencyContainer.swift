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

class DependencyContainer {
    public private(set) static var shared: DependencyContainer!

    private var dependencies: [String: Any] = [:]
    
    /// Registers a dependency
    func register(_ factory: @escaping (DependencyContainer) -> Any) {
        let dependency = factory(self)
        dependencies[String(describing: dependency.self)] = dependency
    }
    
    /// Resolves a module
    func resolve<T>(for name: String? = nil) -> T {
        let name = name ?? String(describing: T.self)

        guard let component: T = dependencies[name] as? T else {
            fatalError("Dependency '\(T.self)' not found")
        }

        return component
    }
}
