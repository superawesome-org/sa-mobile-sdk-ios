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
            fatalError("You cannot register multiple dependencies using the same name (\(name)")
        }
        
        dependencies[name] = Dependency(name: name, factory: factory, scope: .single)
    }
    
    func registerFactory<T>(_ name: String? = nil, type: T.Type, _ factory: @escaping Factory) {
        let name = name ?? String(describing: type)
        
        guard dependencies[name] == nil else {
            fatalError("You cannot register multiple dependencies using the same name (\(name)")
        }
        
        dependencies[name] = Dependency(name: name, factory: factory, scope: .factory)
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
                fatalError("Dependency '\(T.self)' has not found")
            }
            return instance
        case .factory:
            guard let instance = dependency.factory(self) as? T else {
                fatalError("Dependency '\(T.self)' has not found")
            }
            return instance
        }
    }
    
    deinit {
        dependencies.removeAll()
        singleInstances.removeAll()
    }
}
