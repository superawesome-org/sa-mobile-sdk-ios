//
//  CodableExtensionTests.swift
//  SuperAwesome-Unit-Full-Tests
//
//  Created by Gabriel Coman on 15/12/2020.
//

import XCTest
import Nimble
@testable import SuperAwesome

struct TestCodable: Codable {
    let id: Int
    let name: String
}

class CodableExtensionTests: XCTestCase {

    func test_toDictionary_method_on_Codable_type() {
        // given
        let codable = TestCodable(id: 3, name: "test")

        // when
        let result = codable.toDictionary()

        // then
        let id: Int = result["id"] as? Int ?? 0
        expect(id).to(equal(3))
        let name: String = result["name"] as? String ?? ""
        expect(name).to(equal("test"))
    }
}
