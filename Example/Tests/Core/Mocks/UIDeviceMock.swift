//
//  UIDeviceMock.swift
//  Tests
//
//  Created by Gunhan Sancar on 07/04/2020.
//  Copyright © 2020 Gabriel Coman. All rights reserved.
//

@testable import SuperAwesome

class UIDeviceMock: UIDevice {
    private let modelMock: String
    private let systemVersionMock: String
    
    init(model:String, systemVersion: String) {
        self.modelMock = model
        self.systemVersionMock = systemVersion
    }
    
    override var model : String { return modelMock }
    override var systemVersion : String { return systemVersionMock }
}
