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

    func test_givenKsfSafeAd_whenAdLoads_thenShowPadlockFalse() {
        // Given
        adRepository.response = .success(
            AdResponse(123, MockFactory.makeAd(.tag, nil, nil, nil, true, "ksfUrl"))
        )

        let controller = AdController()

        // When
        controller.load(123, MockFactory.makeAdRequest())

        // Then
        expect(controller.showPadlock).to(equal(false))
    }

    func test_givenNotKsfSafeAd_whenAdLoads_thenShowPadlockTrue() {
        // Given
        adRepository.response = .success(
            AdResponse(123, MockFactory.makeAd(.tag, nil, nil, nil, true, nil))
        )

        let controller = AdController()

        // When
        controller.load(123, MockFactory.makeAdRequest())

        // Then
        expect(controller.showPadlock).to(equal(true))
    }
}
