//
//  NumberGeneratorMock.swift
//  SuperAwesome-Unit-Moya-Tests
//
//  Created by Gunhan Sancar on 30/04/2020.
//

@testable import SuperAwesome

class NumberGeneratorMock: NumberGeneratorType {
    let mockValue: Int
    init(_ mockValue: Int) {
        self.mockValue = mockValue
    }
    
    func nextIntForCache() -> Int {
        return mockValue
    }
}
