//
//  ConnectionProviderMock.swift
//  SuperAwesome-Unit-Moya-Tests
//
//  Created by Gunhan Sancar on 30/04/2020.
//

@testable import SuperAwesome

class ConnectionProviderMock: ConnectionProviderType {
    func findConnectionType() -> ConnectionType {
        return .ethernet
    }
}
