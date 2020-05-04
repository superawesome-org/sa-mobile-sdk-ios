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
    
    init(_ mockNextInt: Int, nextAlphaNumberic: String? = nil) {
        self.mockNextInt = mockNextInt
        self.mockAlphanumberic = nextAlphaNumberic
    }
    
    func nextIntForCache() -> Int { mockNextInt }
    func nextAlphanumericString(length: Int) -> String { mockAlphanumberic! }
}
