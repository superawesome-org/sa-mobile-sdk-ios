//
//  PerformanceRepositoryTests.swift
//  SuperAwesomeExampleTests
//
//  Created by Gunhan Sancar on 02/06/2023.
//

import XCTest
import Nimble
@testable import SuperAwesome

class PerformanceRepositoryTests: XCTestCase {
    private var result: Result<Void, Error>?
    private let mockDataSource = AdDataSourceMock()
    private var repository: PerformanceRepository!

    override func setUp() {
        super.setUp()
        result = nil
        repository = PerformanceRepository(dataSource: mockDataSource,
                                           logger: LoggerMock())
    }

    func test_givenSuccess_sendCloseButtonCalled_returnsSuccess() throws {
        // Given
        let expectedResult = Result<(), Error>.success(())
        mockDataSource.mockEventResult = expectedResult

        // When
        let expectation = self.expectation(description: "request")
        repository.sendCloseButtonPressTime(value: 10) { [weak self] result in
            self?.result = result
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2.0, handler: nil)

        // Then
        expect(self.result?.isSuccess).to(equal(expectedResult.isSuccess))
    }
}
