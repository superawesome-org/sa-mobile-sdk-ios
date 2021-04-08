//
//  ConnectionTypeTests.swift
//  SuperAwesome-Unit-Full-Tests
//
//  Created by Gabriel Coman on 15/12/2020.
//

import XCTest
import Nimble
@testable import SuperAwesome

class ConnectionTypeTests: XCTestCase {

    func test_ConnectionType_findQuality_returns_minimum_correctly() {
        // given
        let connection1 = ConnectionType.cellular2g
        let connection2 = ConnectionType.cellularUnknown

        // when
        let result1 = connection1.findQuality()
        let result2 = connection2.findQuality()

        // then
        expect(result1).to(equal(ConnectionQuality.minumum))
        expect(result2).to(equal(ConnectionQuality.minumum))
    }

    func test_ConnectionType_findQuality_returns_maximum_correctly() {
        // given
        let connection1 = ConnectionType.unknown
        let connection2 = ConnectionType.ethernet
        let connection3 = ConnectionType.cellular4g
        let connection4 = ConnectionType.wifi

        // when
        let result1 = connection1.findQuality()
        let result2 = connection2.findQuality()
        let result3 = connection3.findQuality()
        let result4 = connection4.findQuality()

        // then
        expect(result1).to(equal(ConnectionQuality.maximum))
        expect(result2).to(equal(ConnectionQuality.maximum))
        expect(result3).to(equal(ConnectionQuality.maximum))
        expect(result4).to(equal(ConnectionQuality.maximum))
    }

    func test_ConnectionType_findQuality_returns_medium_correctly() {
        // given
        let connection1 = ConnectionType.cellular3g

        // when
        let result1 = connection1.findQuality()

        // then
        expect(result1).to(equal(ConnectionQuality.medium))
    }
}
