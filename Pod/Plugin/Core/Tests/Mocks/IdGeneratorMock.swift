//
//  IdGeneratorMock.swift
//  SuperAwesome-Unit-Moya-Tests
//
//  Created by Gunhan Sancar on 30/04/2020.
//

@testable import SuperAwesome

class IdGeneratorMock: IdGeneratorType {
    let dauId: Int
    init(_ dauId: Int) {
        self.dauId = dauId
    }
    func findDauId() -> Int {
        return dauId
    }
}
