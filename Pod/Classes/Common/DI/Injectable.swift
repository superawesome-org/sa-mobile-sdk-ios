//
//  Injectable.swift
//  SuperAwesome
//
//  Created by Gunhan Sancar on 09/11/2020.
//

/// Injectable protocol helps to inject a dependency container to any class
protocol Injectable {
    //// Injecting into instances
    var dependencies: DependencyContainer { get }

    /// Injecting into static classes
    static var dependencies: DependencyContainer { get }
}

extension Injectable {
    var dependencies: DependencyContainer { InjectableComponent.container }
    static var dependencies: DependencyContainer { InjectableComponent.container }
}

/// Provides the default `DependencyContainer` for `Injectable` protocol
class InjectableComponent {
    static var container: DependencyContainer!

    static func register(_ container: DependencyContainer) {
        self.container = container
    }
}
