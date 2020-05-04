//
//  LocalDataRepositoryMock.swift
//  Tests
//
//  Created by Gunhan Sancar on 07/04/2020.
//

@testable import SuperAwesome

class PreferencesRepositoryMock: PreferencesRepositoryType {
    var dauUniquePart: String?
    var userAgent: String?
    
    init(userAgent: String? = nil, dauUniquePart: String? = nil) {
        self.userAgent = userAgent
        self.dauUniquePart = dauUniquePart
    }
}
