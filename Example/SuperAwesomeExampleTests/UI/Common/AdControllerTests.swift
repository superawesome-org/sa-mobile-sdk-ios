//
//  AdControllerTests.swift
//  SuperAwesomeExampleTests
//
//  Created by Gunhan Sancar on 30/03/2022.
//

import XCTest
import Nimble

@testable import SuperAwesome

class AdControllerTests: XCTestCase {
    private var adRepository: AdRepositoryMock = AdRepositoryMock()

    override func setUp() {
        super.setUp()
        TestDependencies.register(adRepository: adRepository)
    }

    private func showPadlockTest(showPadlock: Bool, ksfUrl: String?, expectedResult: Bool) {
        // Given
        adRepository.response = .success(
            AdResponse(123, MockFactory.makeAd(.tag, nil, nil, nil, showPadlock, ksfUrl))
        )

        let controller = AdController()

        // When
        controller.load(123, MockFactory.makeAdRequest())

        // Then
        expect(controller.showPadlock).to(equal(expectedResult))
    }

    func test_showPadlock() {
        showPadlockTest(showPadlock: true, ksfUrl: "http", expectedResult: false)
        showPadlockTest(showPadlock: true, ksfUrl: nil, expectedResult: true)
        showPadlockTest(showPadlock: false, ksfUrl: "http", expectedResult: false)
    }
}
