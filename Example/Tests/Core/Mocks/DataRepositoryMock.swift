//
//  DataRepositoryMock.swift
//  Tests
//
//  Created by Gunhan Sancar on 07/04/2020.
//  Copyright © 2020 Gabriel Coman. All rights reserved.
//

@testable import SuperAwesome

class DataRepositoryMock: DataRepositoryType {
    var userAgent: String?
    
    init(_ userAgent:String?) {
        self.userAgent = userAgent
    }
}
