//
//  Injectable.swift
//  SuperAwesome
//
//  Created by Gunhan Sancar on 06/04/2020.
//

typealias Factory = (DependencyContainer) -> Any

enum DependencyScope {
    case single
    case factory
}

struct Dependency {
    let name: String
    let factory: Factory
    let scope: DependencyScope
}

class DependencyContainer {
    private var dependencies: [String: Dependency] = [:]
    private var singleInstances: [String: Any] = [:]
    
    func registerSingle<T>(name: String? = nil, _ type: T.Type, _ factory: @escaping Factory) {
        let name = name ?? String(describing: T.self)
        
        guard dependencies[name] == nil else {
            fatalError("You cannot register multiple dependencies using a same name (\(name)")
        }
        
        dependencies[name] = Dependency(name: name, factory: factory, scope: .single)
    }
    
    func registerFactory<T>(_ name: String? = nil, type: T.Type, scope: DependencyScope, _ factory: @escaping Factory) {
        let name = name ?? String(describing: type)
        
        guard dependencies[name] == nil else {
            fatalError("You cannot register multiple dependencies using a same name (\(name)")
        }
        
        dependencies[name] = Dependency(name: name, factory: factory, scope: scope)
    }
    
    func resolve<T>(for name: String? = nil) -> T {
        let name = name ?? String(describing: T.self)
        
        guard let dependency: Dependency = dependencies[name] else {
            fatalError("Dependency '\(name)' is not registered")
        }
        
        switch dependency.scope {
        case .single:
            if singleInstances[name] == nil {
                singleInstances[name] = dependency.factory(self)
            }
            guard let instance = singleInstances[name] as? T else {
                fatalError("Dependency '\(T.self)' has different type")
            }
            return instance
        case .factory:
            guard let instance = dependency.factory(self) as? T else {
                fatalError("Dependency '\(T.self)' has different type")
            }
            return instance
        }
    }
    
    deinit {
        dependencies.removeAll()
        singleInstances.removeAll()
    }
}

class DependencyContainerTests {
    func testContainer() {
        let container = DependencyContainer()
        container.registerSingle(ConnectionManagerType.self) { c in ConnectionManager() }
        container.registerSingle(DeviceType.self) { c in Device(UIDevice.current) }
        container.registerSingle(EncoderType.self) { c in Encoder() }
        container.registerSingle(IdGeneratorType.self) { c in IdGenerator() }
        container.registerSingle(NumberGeneratorType.self) { c in NumberGenerator() }
        container.registerSingle(SdkInfoType.self) { c in
            SdkInfo(mainBundle: Bundle.main, sdkBundle: Bundle(for: DependencyContainer.self),
                    locale: Locale.current, encoder: c.resolve())
        }
        
    }
}
