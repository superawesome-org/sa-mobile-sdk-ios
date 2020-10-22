//
//  IdGeneratorMock.swift
//  SuperAwesome-Unit-Moya-Tests
//
//  Created by Gunhan Sancar on 30/04/2020.
//

@testable import SuperAwesome

class IdGeneratorMock: IdGeneratorType {
    var uniqueDauId: Int
    
    init(_ uniqueDauId: Int) {
        self.uniqueDauId = uniqueDauId
    }
}
