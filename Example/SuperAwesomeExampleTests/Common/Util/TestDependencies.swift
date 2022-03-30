//
//  TestDependencies.swift
//  SuperAwesomeExampleTests
//
//  Created by Gunhan Sancar on 30/03/2022.
//

@testable import SuperAwesome

struct TestDependencies {
    static func register(adRepository: AdRepositoryType = AdRepositoryMock()) {
        let container = DependencyContainer()
        container.single(AdRepositoryType.self) { _, _ in
            adRepository
        }
        container.single(LoggerType.self) { _, _ in
            LoggerMock()
        }
        InjectableComponent.register(container)
    }
}
