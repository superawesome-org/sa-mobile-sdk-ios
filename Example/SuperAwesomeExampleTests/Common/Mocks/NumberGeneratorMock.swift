//
//  NumberGeneratorMock.swift
//  SuperAwesome-Unit-Moya-Tests
//
//  Created by Gunhan Sancar on 30/04/2020.
//

@testable import SuperAwesome

class NumberGeneratorMock: NumberGeneratorType {

    let mockNextInt: Int
    let mockAlphanumberic: String?
    let mockNextParentalGate: Int

    init(_ mockNextInt: Int, nextAlphaNumberic: String? = nil, nextParental: Int = 0) {
        self.mockNextInt = mockNextInt
        self.mockAlphanumberic = nextAlphaNumberic
        self.mockNextParentalGate = nextParental
    }

    func nextIntForCache() -> Int { mockNextInt }
    func nextAlphanumericString(length: Int) -> String { mockAlphanumberic! }
    func nextIntForParentalGate() -> Int { mockNextParentalGate }
}
