//
//  EventRepositoryTests.swift
//  SuperAwesome-Unit-Moya-Tests
//
//  Created by Gunhan Sancar on 30/04/2020.
//

import XCTest
import Nimble
import Mockingjay
@testable import SuperAwesome

class EventRepositoryTests: XCTestCase {
    private var result: Result<Void, Error>?
    private let mockAdQueryMaker = AdQueryMakerMock()
    private let mockDataSource = AdDataSourceMock()
    private var repository: EventRepository!

    override func setUp() {
        super.setUp()
        result = nil
        repository = EventRepository(dataSource: mockDataSource, adQueryMaker: mockAdQueryMaker)
    }

    func test_givenSuccess_impressionCalled_returnsSuccess() throws {
        // Given
        let expectedResult = Result<(), Error>.success(())
        mockDataSource.mockEventResult = expectedResult

        // When
        let expectation = self.expectation(description: "request")
        repository.impression(MockFactory.makeAdResponse()) { result in
            self.result = result
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2.0, handler: nil)

        // Then
        expect(self.result?.isSuccess).to(equal(expectedResult.isSuccess))
    }

    func test_givenSuccess_clickCalled_returnsSuccess() throws {
        // Given
        let expectedResult = Result<(), Error>.success(())
        mockDataSource.mockEventResult = expectedResult

        // When
        let expectation = self.expectation(description: "request")
        repository.impression(MockFactory.makeAdResponse()) { result in
            self.result = result
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2.0, handler: nil)

        // Then
        expect(self.result?.isSuccess).to(equal(expectedResult.isSuccess))
    }

    func test_givenSuccess_videoClickCalled_returnsSuccess() throws {
        // Given
        let expectedResult = Result<(), Error>.success(())
        mockDataSource.mockEventResult = expectedResult

        // When
        let expectation = self.expectation(description: "request")
        repository.impression(MockFactory.makeAdResponse()) { result in
            self.result = result
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2.0, handler: nil)

        // Then
        expect(self.result?.isSuccess).to(equal(expectedResult.isSuccess))
    }

    func test_givenSuccess_eventCalled_returnsSuccess() throws {
        // Given
        let expectedResult = Result<(), Error>.success(())
        mockDataSource.mockEventResult = expectedResult

        // When
        let expectation = self.expectation(description: "request")
        repository.impression(MockFactory.makeAdResponse()) { result in
            self.result = result
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2.0, handler: nil)

        // Then
        expect(self.result?.isSuccess).to(equal(expectedResult.isSuccess))
    }
}
