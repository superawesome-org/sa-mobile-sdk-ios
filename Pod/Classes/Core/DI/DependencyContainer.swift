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

//protocol Injectable {
//    var dependencies: DependencyContainer { get }
//}
//
//extension Injectable {
//    var dependencies: DependencyContainer { DependencyContainer.shared }
//}

class DependencyContainer {
    public private(set) static var shared: DependencyContainer!

    //private var dependencies: [String: Dependency] = [:]
    private var dependencies: [String: Any] = [:]

//    static func initContainer(_ dependencies: @escaping (DependencyContainer) -> [Dependency]) {
//        shared = DependencyContainer()
//        modules(shared).forEach { shared.add($0) }
//    }
    
//    func register(_ factory: @escaping (DependencyContainer) -> Dependency) {
//        let dependency = factory(self)
//        dependencies[dependency.name] = dependency
//    }
    
    func register(_ factory: @escaping (DependencyContainer) -> Any) {
        let dependency = factory(self)
        dependencies[String(describing: dependency.self)] = dependency
    }

//    func register(_ dependency: Dependency) {
//        dependencies[dependency.name] = dependency
//    }

//    /// Resolves a module
//    func resolve<T>(for name: String? = nil) -> T {
//        let name = name ?? String(describing: T.self)
//
//        guard let component: T = dependencies[name]?.resolve() as? T else {
//            fatalError("Dependency '\(T.self)' not found")
//        }
//
//        return component
//    }
    /// Resolves a module
    func resolve<T>(for name: String? = nil) -> T {
        let name = name ?? String(describing: T.self)

        guard let component: T = dependencies[name] as? T else {
            fatalError("Dependency '\(T.self)' not found")
        }

        return component
    }
}

//struct Dependency {
//    fileprivate let name: String
//    fileprivate let resolve: () -> Any
//
//    public init<T>(_ name: String? = nil, _ resolve: @escaping () -> T) {
//        self.name = name ?? String(describing: T.self)
//        self.resolve = resolve
//    }
//}

//class Tester {
//    func testing() {
//        let container = DependencyContainer()
//        container.register { c in ComponentModule(c.resolve() as RepositoryModuleType) as ComponentModuleType }
//        container.register { c in NetworkModule(c.resolve() as ComponentModuleType) as NetworkModuleType }
//        container.register { c in RepositoryModule(c.resolve() as NetworkModuleType) as RepositoryModuleType }
//
//    }
//}
