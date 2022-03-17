//
//  UserAgentProviderMock.swift
//  SuperAwesome-Unit-Moya-Tests
//
//  Created by Gunhan Sancar on 30/04/2020.
//

@testable import SuperAwesome

class UserAgentProviderMock: UserAgentProviderType {
    var name: String

    init(name: String) {
        self.name = name
    }
}
