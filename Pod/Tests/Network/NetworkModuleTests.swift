//
//  NetworkModuleTests.swift
//  SuperAwesome-Unit-Full-Tests
//
//  Created by Gunhan Sancar on 28/10/2020.
//

import XCTest
import Nimble
import Moya
@testable import SuperAwesome

class NetworkModuleTests: XCTestCase {
    func test_networkModule_register() {
        // Given
        let container = DependencyContainer()
        container.factory(UserAgentProviderType.self) { _, _ in
            UserAgentProvider(device: DeviceMock(), preferencesRepository: PreferencesRepositoryMock())
        }
        container.factory(Environment.self) { _, _ in
            Environment.production
        }

        // When
        NetworkModule().register(container)

        // Then
        let expectedDependency = container.resolve() as MoyaHeaderPlugin
        let expectedDependency2 = container.resolve() as MoyaProvider<AwesomeAdsTarget>
        let expectedDependency3 = container.resolve() as AwesomeAdsApiDataSourceType
        let expectedDependency4 = container.resolve() as NetworkDataSourceType

        expect(expectedDependency).notTo(beNil())
        expect(expectedDependency2).notTo(beNil())
        expect(expectedDependency3).notTo(beNil())
        expect(expectedDependency4).notTo(beNil())
    }
}
