//
//  TimeProviderMock.swift
//  SuperAwesomeExampleTests
//
//  Created by Gunhan Sancar on 20/10/2022.
//

@testable import SuperAwesome

class TimeProviderMock: TimeProviderType {
    var secondsSince1970Mock: TimeInterval?

    var secondsSince1970: TimeInterval {
        print("I am here: \(secondsSince1970Mock)")
        return secondsSince1970Mock ?? NSDate().timeIntervalSince1970
    }
}
