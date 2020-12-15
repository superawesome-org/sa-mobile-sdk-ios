//
//  MoatModuleTests.swift
//  SuperAwesome-Unit-Full-Tests
//
//  Created by Gunhan Sancar on 28/10/2020.
//

import XCTest
import Nimble
import Moya
import SUPMoatMobileAppKit
@testable import SuperAwesome

class MoatModuleTests: XCTestCase {
    func test_moatModule_register() {
        // Given
        let container = DependencyContainer()
        container.factory(LoggerType.self) { c, _ in LoggerMock() }
        container.factory(NumberGeneratorType.self) { c, _ in NumberGeneratorMock(0) }
        
        // When
        let module = MoatModule()
        module.initMoat(true)
        module.register(container)
        
        // Then
        let expectedDependency = container.resolve(param: MockFactory.makeAdResponse(), false) as MoatRepositoryType
        expect(expectedDependency).notTo(beNil())
    }
}
