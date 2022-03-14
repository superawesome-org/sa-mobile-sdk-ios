//
//  UIDeviceMock.swift
//  Tests
//
//  Created by Gunhan Sancar on 07/04/2020.
//

@testable import SuperAwesome

class UIDeviceMock: UIDevice {
    private let modelMock: String
    private let systemVersionMock: String

    init(model: String, systemVersion: String) {
        self.modelMock = model
        self.systemVersionMock = systemVersion
    }

    override var model: String { return modelMock }
    override var systemVersion: String { return systemVersionMock }
}
