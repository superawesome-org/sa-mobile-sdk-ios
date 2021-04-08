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
    let mockNextMoat: Float
    let mockNextParentalGate: Int

    init(_ mockNextInt: Int, nextAlphaNumberic: String? = nil, nextMoat: Float = 0, nextParental: Int = 0) {
        self.mockNextInt = mockNextInt
        self.mockAlphanumberic = nextAlphaNumberic
        self.mockNextMoat = nextMoat
        self.mockNextParentalGate = nextParental
    }

    func nextIntForCache() -> Int { mockNextInt }
    func nextAlphanumericString(length: Int) -> String { mockAlphanumberic! }
    func nextFloatForMoat() -> Float { mockNextMoat }
    func nextIntForParentalGate() -> Int { mockNextParentalGate }
}
