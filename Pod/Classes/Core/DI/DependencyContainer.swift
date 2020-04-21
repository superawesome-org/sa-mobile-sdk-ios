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

protocol Injectable {
    var dependencies: DependencyContainer { get }
}

extension Injectable {
    var dependencies: DependencyContainer { DependencyContainer.shared }
}

class DependencyContainer {
    public private(set) static var shared: DependencyContainer!

    private var modules: [String: Module] = [:]
    
    static func initContainer(_ modules: @escaping (DependencyContainer) -> [Module]) {
        shared = DependencyContainer()
        modules(shared).forEach { shared.add(module: $0) }
    }

    private func add(module: Module) {
        modules[module.name] = module
    }

    /// Resolves a module
    func resolve<T>(for name: String? = nil) -> T {
        let name = name ?? String(describing: T.self)

        guard let component: T = modules[name]?.resolve() as? T else {
            fatalError("Dependency '\(T.self)' not found")
        }

        return component
    }
}

struct Module {
    fileprivate let name: String
    fileprivate let resolve: () -> Any

    public init<T>(_ name: String? = nil, _ resolve: @escaping () -> T) {
        self.name = name ?? String(describing: T.self)
        self.resolve = resolve
    }
}

//class Tester {
//    func testing() {
//        DependencyContainer.initContainer { container in
//            [
//                Module { RepositoryModule() as RepositoryModuleType },
//                Module { ComponentModule() as ComponentModuleType },
//                Module { NetworkModule() as NetworkModuleType }
//            ]
//        }
//    }
//}
