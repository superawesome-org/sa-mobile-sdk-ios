//
//  TestDependencies.swift
//  SuperAwesomeExampleTests
//
//  Created by Gunhan Sancar on 30/03/2022.
//

@testable import SuperAwesome

struct TestDependencies {
    static func register(adRepository: AdRepositoryType = AdRepositoryMock(),
                         timeProvider: TimeProviderType = TimeProviderMock()) {
        let container = DependencyContainer()
        container.single(TimeProviderType.self) { _, _ in
            timeProvider
        }
        container.single(AdRepositoryType.self) { _, _ in
            adRepository
        }
        container.single(LoggerType.self) { _, _ in
            LoggerMock()
        }
        container.single(ImageProviderType.self) { _, _ in
            ImageProvider()
        }
        container.single(StringProviderType.self) { _, _ in
            StringProvider()
        }
        container.single(EventRepositoryType.self) { container, _ in
            EventRepository(dataSource: AdDataSourceMock(),
                            adQueryMaker: AdQueryMakerMock(),
                            logger: container.resolve(param: EventRepository.self))
        }
        InjectableComponent.register(container)
    }
}
